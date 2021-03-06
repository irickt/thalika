
Backbone = require "backbone"

# collection is the base for filtered collections, constructed when a tag is selected
# args are the models in the filtered collection

# reset is triggered when the models are ready to go
# (reset also triggered on fetch and sort)

FilteredCollection = Backbone.Collection.extend
    constructor: (argmts...) ->
        args = Array::slice.call(argmts)
        Backbone.Collection::constructor.apply this, args
        this.onResetCallbacks = new Backbone.Marionette.Callbacks()
        this.on "reset", this.runOnResetCallbacks, this

    onReset: (callback) ->
        this.onResetCallbacks.add callback

    runOnResetCallbacks: ->
        this.onResetCallbacks.run this, this


module.exports = FilteredCollection
#MainApp.Collection = FilteredCollection

###
# example, itemList is a Collection

    # register a callback to fire when collection is reset, which is triggered by tag change
    displayItemsFilteredBy = (tag) ->
        itemList.onReset (list) ->
            # the collection is ready
            filteredItems = list.forTag tag
            views.showList filteredItems # actually make a view and show it


###
