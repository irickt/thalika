###
Backbone = require "backbone"
$ = require "jquery"
dust = require "dustjs-linkedin"
###

nextTick = (f) ->
    setTimeout f, 0


MainApp = new Backbone.Marionette.Application()

MainApp.addRegions
    content: ".content"

MainApp.vent.on "layout:rendered", ->
    nextTick ->
        Backbone.history.start()
            #pushState: true

window.MainApp = MainApp


Backbone.Marionette.Renderer.render = (templateName, data) ->
    asyncRender = $.Deferred()
    window.dust.render templateName, data, (err, html) ->
        asyncRender.resolve html
    asyncRender.promise()
