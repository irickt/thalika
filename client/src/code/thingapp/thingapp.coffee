###
Backbone = require "backbone"
mainApp.vent
thingApp.Tags
thingApp.thingViews
parent mainApp

###

#thingCssName = "reward"
thingModuleName = "reward"
#thingPathName = "reward"
thingDataName = "reward"
thingEventName = "reward"

window.MainApp.module "#{thingModuleName}App", (thingApp, mainApp, Backbone, Marionette, $, _) ->

    thingApp.Thing = Backbone.Model.extend {}

    thingApp.ThingCollection = mainApp.Collection.extend
        url: "/data/#{thingDataName}"
        model: thingApp.Thing

        # filter items by tag or all items if no tag
        forTag: (tag) ->
            return this unless tag
            filteredItems = this.filter (item) ->
                tags = item.get "tags"
                return tags.indexOf(tag) >= 0
            return new thingApp.ThingCollection filteredItems



    # the "controller" for the router
    # the repeated showTagList is needed because incoming urls don't pass through app level controller
    # router handler: show all items
    thingApp.showItemsList = ->
        mainApp.vent.trigger "#{thingEventName}:show"
        thingApp.Tags.showTagList()

    # router handler: show items for the given tag
    thingApp.showItemsByTag = (tag) ->
        mainApp.vent.trigger "#{thingEventName}:tag:show", tag
        thingApp.Tags.showTagList()

    # router handler: show item detail, by id
    thingApp.showItemDetail = (itemId) ->
        mainApp.vent.trigger "#{thingEventName}:item:show", itemId
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

    # show items filtered by tag
    mainApp.vent.bind "#{thingEventName}:tag:show", (tag) ->
        displayItemsFilteredBy tag

    # show all the items
    mainApp.vent.bind "#{thingEventName}:show", ->
        displayItemsFilteredBy()

    # show one item
    mainApp.vent.bind "#{thingEventName}:item:show", (itemId) ->
        displayItem itemId


    thingApp.addInitializer ->
        thingApp.itemList = new thingApp.ThingCollection()
        thingApp.itemList.fetch()
