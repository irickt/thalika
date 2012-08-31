###
mainApp.vent
thingApp.Tags
thingApp.thingViews
parent mainApp

###

Backbone = require "backbone"
FilteredCollection = require "mainapp/mainapp.collection.js"

#thingCssName = "reward"
thingModuleName = "reward"
#thingPathName = "reward"
thingDataName = "reward"
thingEventName = "reward"

window.MainApp.module "#{thingModuleName}App", (thingApp, mainApp) ->

    thingApp.Thing = Backbone.Model.extend {}

    thingApp.ThingCollection = FilteredCollection.extend # mainApp.Collection.extend
        url: "/data/#{thingDataName}"
        model: thingApp.Thing

        # filter items by tag or all items if no tag
        forTag: (tag) ->
            return this unless tag
            filteredItems = this.filter (item) ->
                tags = item.get "tags"
                return tags.indexOf(tag) >= 0
            return new thingApp.ThingCollection filteredItems


    # listen for mainApp request to show the default view
    mainApp.vent.bind "#{thingEventName}app:show", ->
        thingApp.showItemsList()

    # we're the current view, set up the navigation here (as main does too)
    mainApp.vent.bind "#{thingEventName}app:shown", ->
        thingApp.Tags.showTagList()

    # the "controller" for the router
    # any app url must trigger navigation set up: showTagList and app selector control
    # in effect incoming urls must pass through app level controller

    # router handler: show all items
    thingApp.showItemsList = ->
        mainApp.vent.trigger "#{thingEventName}:show"
        mainApp.vent.trigger "#{thingEventName}app:shown"

    # router handler: show items for the given tag
    thingApp.showItemsByTag = (tag) ->
        mainApp.vent.trigger "#{thingEventName}:tag:show", tag
        mainApp.vent.trigger "#{thingEventName}app:shown"

    # router handler: show item detail, by id
    thingApp.showItemDetail = (itemId) ->
        mainApp.vent.trigger "#{thingEventName}:item:show", itemId
        mainApp.vent.trigger "#{thingEventName}app:shown"



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
    mainApp.vent.bind "#{thingEventName}:show", ->
        displayItemsFilteredBy()

    # show items filtered by tag
    mainApp.vent.bind "#{thingEventName}:tag:show", (tag) ->
        displayItemsFilteredBy tag

    # show one item
    mainApp.vent.bind "#{thingEventName}:item:show", (itemId) ->
        displayItem itemId



    thingApp.addInitializer ->
        thingApp.itemList = new thingApp.ThingCollection()
        thingApp.itemList.fetch()

