
Backbone = require "backbone"
FilteredCollection = require "mainapp/mainapp.collection.js"

{router, vent} = require "mainapp/mainapp.js"

TagModule = require "thingapp/thingapp.tags.js"
ThingViews = require "thingapp/thingapp.views.js"


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


class ThingApp
    constructor: () ->
        router.bindRoutes thingEventName

        vent.bind "#{thingEventName}:appshow", (args...) =>
            vent.trigger "#{thingEventName}:appshown", args...
            this.showThing args...

        this.tagsWidget = new TagModule()
        this.itemList = new ThingCollection()
        this.thingViews = new ThingViews()

        # any app url will trigger navigation set up
        vent.bind "#{thingEventName}:appshown", =>
            this.tagsWidget.showTagList()

        # bind show events to display actions
        # triggered by tag click or route or initialization

        # show all the items
        vent.bind "#{thingEventName}:show", =>
            this.displayItemsFilteredBy()

        # show items filtered by tag
        vent.bind "#{thingEventName}:tag:show", (tag) =>
            this.displayItemsFilteredBy tag

        # show one item
        vent.bind "#{thingEventName}:item:show", (itemId) =>
            this.displayItem itemId

    start: ->
        this.itemList.fetch() # returns promise, resolved before show. onReset is enough?

    # router handler: show all items
    showThing: (args...) ->
        # parse and validate args
        if !args[0]
            vent.trigger "#{thingEventName}:show"
        else if args[0] == "tag"
            vent.trigger "#{thingEventName}:tag:show", args[1] # tagName
        else
            vent.trigger "#{thingEventName}:item:show", args[0] # itemId

    # register a callback to fire when collection is reset, which is triggered by tag change
    displayItemsFilteredBy: (tag) ->
        that = this
        this.itemList.onReset (list) ->
            filteredItems = list.forTag tag
            that.thingViews.showList filteredItems # actually make a view and show it

    # register a callback to fire when collection is reset, which is triggered by ?
    displayItem: (itemId) ->
        that = this
        this.itemList.onReset (list) ->
            item = list.get itemId
            that.thingViews.showItem item



module.exports = ThingApp

