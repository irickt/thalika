require "mainapp/mainapp.js"
require "mainapp/mainapp.layout.js"

require "thingapp/thingapp.js"
require "thingapp/thingapp.tags.js"
require "thingapp/thingapp.views.js"

#require "accountapp/accountapp.js"
#require "accountapp/accountapp.views.js"

require "graphapp/graphapp.js"
require "graphapp/graphdemo.js"

$ () ->
    window.MainApp.start()

module.exports =
    start: ->
