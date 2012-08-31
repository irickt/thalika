###
Backbone = require "backbone"
$ = require "jquery"
dust = require "dustjs-linkedin"
###

nextTick = (f) ->
    setTimeout f, 0


MainApp = new Backbone.Marionette.Application()

MainApp.addRegions
    content: ".content" # div in index.html

MainApp.vent.on "layout:rendered", ->
    nextTick ->
        # history start after routes are set up and dom is ready, because it will act on the current url
        Backbone.history.start()
            #pushState: true

window.MainApp = MainApp


Backbone.Marionette.Renderer.render = (templateName, data) ->
    asyncRender = $.Deferred()
    window.dust.render templateName, data, (err, html) ->
        asyncRender.resolve html
    asyncRender.promise()


# provides a simplified two-way "binding" to the browser's address bar
# each route
    # triggers an event but has no callback.
    # has :param style parameters, not regex patterns.
    # are displayed on a routeShowEvent with route part args. args must be present and in correct order.
    # (tba accept trigger and replace options)
# routePattern, routeName (for event route:routeName), routeShowEvent

makeRoute = (pattern, args...) ->
    keys = pattern.match( /:([a-z_]+)/g ) || []
    for key, i in keys
        pattern = pattern.replace key, args[i]
    console.log "makeRoute", pattern
    pattern

Backbone.Router::bindRoute = (routePattern, routeName, routeShowEvent) ->
    this.route routePattern, routeName
    MainApp.vent.bind routeShowEvent, (args...) =>
        this.navigate makeRoute routePattern, args...

# only one router is needed. it has no state (confirm) and is only an interface to Backbone.history
MainApp.router = new Backbone.Router()
