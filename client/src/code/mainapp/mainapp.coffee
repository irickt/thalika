
Backbone = require "backbone"
$ = require "jquery"

# dust = require "dust" # use window.dust for now.
# sees exports and tries to require("./dust-helpers") ?? ...

# require "asyncRenderer"
Backbone.Marionette.Renderer.render = (templateName, data) ->
    asyncRender = $.Deferred()
    window.dust.render templateName, data, (err, html) ->
        asyncRender.resolve html
    asyncRender.promise()




MainApp = new Backbone.Marionette.Application()

MainApp.addRegions
    content: ".content" # div in index.html

window.MainApp = MainApp
module.exports = mainApp = MainApp
# provides mainApp.vent ... need a fancier one? eg combine events from router and vent
# provides mainApp.addInitializer ... need an async version

# provides mainApp.content ... the region, just one for the top layout
# provides mainApp.layout ... after layout attaches it

# provides mainApp.subApp ... provided at initialization (not module making)

# provides mainApp.Routing ... replaced with Backbone.Router, see below




# router

nextTick = (f) -> setTimeout f, 0

MainApp.vent.on "layout:rendered", ->
    nextTick ->
        # history start after routes are set up and dom is ready, because it will act on the current url
        Backbone.history.start()
            #pushState: true


# provides a simplified two-way "binding" to the browser's address bar
# an app registers only its routeName eg     router.bindRoutes "account"
# app binds to routeName:appshow args to show itself
# app triggers routeName:appshown args to display a url, and to trigger internal and external actions
#        in effect incoming urls pass through app level controller

#     make two routes: routeName and routeName/*args (no callbacks so only events are triggered on route match)
#     bind router events route:routeName and route:routeNameWA (with args) to trigger routeName:show args
#          (could just use router as aggregator, but let apps decide)
#          (or, a common event aggregator that does wildcards cf bb.events does "all")
#     bind routeName:shown args to the inverse url, must be url-encoded
#     (trigger and replace options are false)

Backbone.Router::bindRoutes = (routeName) ->
    this.route routeName, routeName
    this.route "#{routeName}/*args", "#{routeName}WA"
    this.bind "route:#{routeName}", () ->
        console.log "route event", "#{routeName}:appshow"
        MainApp.vent.trigger "#{routeName}:appshow"
    this.bind "route:#{routeName}WA", (args) ->
        args = _.map args.split("/"), decodeURIComponent
        console.log "route event", "#{routeName}:appshow", args
        MainApp.vent.trigger "#{routeName}:appshow", args
    MainApp.vent.bind "#{routeName}:appshown", (args...) =>
        args = _.map args, encodeURIComponent
        args.unshift routeName
        this.navigate args.join "/"

# only one router is needed. it has no state (confirm) and is only an interface to Backbone.history
MainApp.router = new Backbone.Router()




###
# previous take

makeRoute = (pattern, args...) ->
    keys = pattern.match( /:([a-z_]+)/g ) || []
    for key, i in keys
        pattern = pattern.replace key, args[i]
    console.log "makeRoute", pattern
    pattern

Backbone.Router::xbindRoute = (routePattern, routeName, routeShowEvent) ->
    this.route routePattern, routeName
    #this.bind "route:#{routeName}", (args...) ->
    #    MainApp.vent.trigger "#{routeName}app:show", args...
    MainApp.vent.bind routeShowEvent, (args...) =>
        this.navigate makeRoute routePattern, args...

# temporary relays. to install in bindRoute
mainApp.router.bind "route:account", ->
    console.log "event", "route:account"
    mainApp.vent.trigger "accountapp:show"
mainApp.router.bind "route:graph", ->
    console.log "event", "route:graph"
    mainApp.vent.trigger "graphapp:show"
mainApp.router.bind "route:reward", ->
    console.log "event", "route:reward"
    #mainApp.vent.trigger "rewardapp:show"

###

