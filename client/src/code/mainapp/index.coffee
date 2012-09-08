require "mainapp/mainapp.js"
require "mainapp/mainapp.layout.js"

#require "thingapp/thingapp.js"
#require "thingapp/thingapp.tags.js"
#require "thingapp/thingapp.views.js"


$ () ->
    window.MainApp.start()

module.exports =
    start: ->
