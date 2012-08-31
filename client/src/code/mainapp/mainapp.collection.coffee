###
Backbone = require "backbone" # window

###

# collection is the base for filtered collections, constructed when a tag is selected
# args are the models in the filtered collection

# reset is triggered when the models are ready to go
# (reset also triggered on fetch and sort)

MainApp.Collection = Backbone.Collection.extend
    constructor: (argmts...) ->
        args = Array::slice.call(argmts)
        Backbone.Collection::constructor.apply this, args
        this.onResetCallbacks = new Backbone.Marionette.Callbacks()
        this.on "reset", this.runOnResetCallbacks, this

    onReset: (callback) ->
        this.onResetCallbacks.add callback

    runOnResetCallbacks: ->
        this.onResetCallbacks.run this, this



###
# example, itemList is a Collection

    # register a callback to fire when collection is reset, which is triggered by tag change
    displayItemsFilteredBy = (tag) ->
        thingApp.itemList.onReset (list) ->
            # the collection is ready
            filteredItems = list.forTag tag
            thingApp.thingViews.showList filteredItems # actually make a view and show it

###
