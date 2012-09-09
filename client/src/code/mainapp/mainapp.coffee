
Backbone = require "backbone"
$ = require "jquery"



# dust = require "dust" # use window.dust for now.
# sees exports and tries to require("./dust-helpers") ?? ...
# also breaks if it's in a file with module.exports??

# require "asyncRenderer"
Backbone.Marionette.Renderer.render = (templateName, data) ->
    asyncRender = $.Deferred()
    if !templateName
        asyncRender.resolve null
    else
        window.dust.render templateName, data, (err, html) ->
            asyncRender.resolve html
    asyncRender.promise()






MainApp = new Backbone.Marionette.Application()

MainApp.addRegions
    content: ".content" # div in index.html

window.MainApp = MainApp
module.exports = mainApp = MainApp
# provides mainApp.router
# provides mainApp.vent ... need a fancier one? eg see router

# provides mainApp.addInitializer ... need an async version

# provides mainApp.content ... the region, just one for the top layout
# provides mainApp.layout ... after layout attaches it

# provides mainApp.subApp ... make them from config or introspection of modules



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
        MainApp.vent.trigger "#{routeName}:appshow"
        console.log "route match", "#{routeName}:appshow"
    this.bind "route:#{routeName}WA", (argstr) ->
        args = if argstr then argstr.split("/") else []
        args = _.map args, decodeURIComponent
        MainApp.vent.trigger "#{routeName}:appshow", args...
        console.log "route match", "#{routeName}:appshow", args...
    MainApp.vent.bind "#{routeName}:appshown", (args...) =>
        args = _.map args, encodeURIComponent
        args.unshift routeName
        this.navigate args.join "/"
        console.log "route set", "#{routeName}:appshown", args...

# only one router is needed. it has no state (confirm) and is only an interface to Backbone.history
MainApp.router = new Backbone.Router()




AccountApp = require "accountapp/accountapp.js"
console.log "AccountApp.prototype", AccountApp.prototype

mainApp.accountApp = new AccountApp()
# reference not used, communication by events
# app registers on load, then registered apps are made here (or on demand)
console.log "accountApp", mainApp.accountApp

GraphApp = require "graphapp/graphapp.js"
console.log "GraphApp.prototype", GraphApp.prototype

mainApp.graphApp = new GraphApp()
# reference not used, communication by events
# app registers on load, then registered apps are made here (or on demand)
console.log "graphApp", mainApp.graphApp

ThingApp = require "thingapp/thingapp.js"
console.log "ThingApp.prototype", ThingApp.prototype

mainApp.thingApp = new ThingApp()
mainApp.thingApp.start()
# app registers on load, then registered apps are made here (or on demand)
console.log "thingApp", mainApp.thingApp


MainViews = require "mainapp/mainapp.layout.js"

mainApp.mainViews = new MainViews()
mainApp.layout = mainApp.mainViews.layout # FIX
mainApp.mainViews.start()


# using this messes up dust ??
#module.exports = mainApp
