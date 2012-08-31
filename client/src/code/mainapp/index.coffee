require "mainapp/mainapp.js"
require "mainapp/mainapp.collection.js"
require "mainapp/mainapp.layout.js"
require "mainapp/mainapp.routing.js"
require "thingapp/thingapp.js"
require "thingapp/thingapp.routing.js"
require "thingapp/thingapp.tags.js"
require "thingapp/thingapp.thingview.js"
require "accountapp/accountapp.js"
require "accountapp/accountapp.accountviews.js"
require "graphapp/graphapp.js"
require "graphapp/graphdemo.js"

$ () ->
    window.MainApp.start()

module.exports =
    start: ->
