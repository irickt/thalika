###
Backbone = require "backbone"
###

#thingCssName = "reward"
thingModuleName = "reward"
#thingPathName = "reward"
thingDataName = "reward"
thingEventName = "reward"

window.MainApp.module "#{thingModuleName}App", (thingApp, MainApp, Backbone, Marionette, $, _) ->

    thingApp.Thing = Backbone.Model.extend {}

    thingApp.ThingCollection = MainApp.Collection.extend
        url: "/data/#{thingDataName}"
        model: thingApp.Thing

        # filter items by tag or all items if no tag
        forTag: (tag) ->
            return this unless tag
            filteredItems = this.filter (item) ->
                tags = item.get "tags"
                return tags.indexOf(tag) >= 0
            return new thingApp.ThingCollection filteredItems

    # router handler: show all items
    thingApp.showItemsList = ->
        MainApp.vent.trigger "#{thingEventName}:show"
        thingApp.Tags.showTagList() # let the tags app listen for these #######

    # router handler: show items for the given tag
    thingApp.showItemsByTag = (tag) ->
        MainApp.vent.trigger "#{thingEventName}:tag:show", tag
        thingApp.Tags.showTagList()

    # not used, this is done by thingViews directly
    # router handler: show item detail, by id
    thingApp.showItemDetail = (itemId) ->
        MainApp.vent.trigger "#{thingEventName}:item:show", itemId
        thingApp.Tags.showTagList()



    # register a callback to fire when collection is reset, which is triggered by tag change
    displayItemsFilteredBy = (tag) ->
        thingApp.itemList.onReset (list) ->
            filteredItems = list.forTag tag
            thingApp.thingViews.showList filteredItems # actually make a view and show it

    # not used, this is done by thingViews directly
    # register a callback to fire when collection is reset, which is triggered by ?
    displayItem = (itemId) ->
        thingApp.itemList.onReset (list) ->
            item = list.get itemId
            thingApp.thingViews.showItem item

# show items filtered by tag
    # triggered by tag click or route
    MainApp.vent.bind "#{thingEventName}:tag:show", (tag) ->
        displayItemsFilteredBy tag

    # show all the items
    # triggered by tag click or route or initialization
    MainApp.vent.bind "#{thingEventName}:show", ->
        displayItemsFilteredBy()

    # not used, this is done by thingViews directly
    # show one item
    # triggered by item click or route
    MainApp.vent.bind "#{thingEventName}:item:show", (itemId) ->
        displayItem itemId


    thingApp.addInitializer ->
        thingApp.itemList = new thingApp.ThingCollection()
        thingApp.itemList.fetch()
