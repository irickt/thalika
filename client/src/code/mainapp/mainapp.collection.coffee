###
Backbone = require "backbone" # window
###

# collection is the base for filtered collections
# constructed when a tag is selected, args are the items

# reset is triggered when the models are ready to go
# (reset also triggered on fetch and sort)

MainApp.Collection = Backbone.Collection.extend
    constructor: (argmts...) ->
        args = Array::slice.call(argmts)
        #console.log "Collection constructor args", args
        Backbone.Collection::constructor.apply this, args
        this.onResetCallbacks = new Backbone.Marionette.Callbacks()
        this.on "reset", this.runOnResetCallbacks, this

    onReset: (callback) ->
        this.onResetCallbacks.add callback

    runOnResetCallbacks: ->
        this.onResetCallbacks.run this, this
