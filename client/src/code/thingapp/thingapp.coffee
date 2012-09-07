###
thingApp.Tags
thingApp.thingViews

# parent mainApp
###

Backbone = require "backbone"
FilteredCollection = require "mainapp/mainapp.collection.js"

{router, vent} = require "mainapp/mainapp.js"


#thingCssName = "reward"
thingModuleName = "reward"
#thingPathName = "reward"
thingDataName = "reward"
thingEventName = "reward"



Thing = Backbone.Model.extend {}

ThingCollection = FilteredCollection.extend
    url: "/data/#{thingDataName}"
    model: Thing

    # filter items by tag or all items if no tag
    forTag: (tag) ->
        return this unless tag
        filteredItems = this.filter (item) ->
            tags = item.get "tags"
            return tags.indexOf(tag) >= 0
        return new ThingCollection filteredItems


window.MainApp.module "#{thingModuleName}App", (thingApp) ->

    router.bindRoutes thingEventName

    # router handler: show all items
    showThing = (args...) ->
        # parse and validate args
        if !args[0]
            vent.trigger "#{thingEventName}:show"
        else if args[0] == "tag"
            vent.trigger "#{thingEventName}:tag:show", args[1] # tagName
        else
            vent.trigger "#{thingEventName}:item:show", args[0] # itemId

    vent.bind "#{thingEventName}:appshow", (args...) ->
        vent.trigger "#{thingEventName}:appshown", args...
        showThing args...


    # any app url will trigger navigation set up
    vent.bind "#{thingEventName}:appshown", ->
        thingApp.Tags.showTagList()


    # register a callback to fire when collection is reset, which is triggered by tag change
    displayItemsFilteredBy = (tag) ->
        thingApp.itemList.onReset (list) ->
            filteredItems = list.forTag tag
            thingApp.thingViews.showList filteredItems # actually make a view and show it

    # register a callback to fire when collection is reset, which is triggered by ?
    displayItem = (itemId) ->
        thingApp.itemList.onReset (list) ->
            item = list.get itemId
            thingApp.thingViews.showItem item


    # bind show events to display actions
    # triggered by tag click or route or initialization

    # show all the items
    vent.bind "#{thingEventName}:show", ->
        displayItemsFilteredBy()

    # show items filtered by tag
    vent.bind "#{thingEventName}:tag:show", (tag) ->
        displayItemsFilteredBy tag

    # show one item
    vent.bind "#{thingEventName}:item:show", (itemId) ->
        displayItem itemId



    thingApp.addInitializer ->
        thingApp.itemList = new ThingCollection()
        thingApp.itemList.fetch()

