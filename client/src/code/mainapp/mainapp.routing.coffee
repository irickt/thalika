###
Backbone = require "backbone"
mainApp.addInitializer -> # mainApp.thingApp.addInitializer
mainApp.vent
mainApp.layout # is the controller
mainApp.Routing # events to self

config for the list of sub apps
###


window.MainApp.module "Routing", (routing, mainApp, Backbone, Marionette, $, _) ->

    # update the url display
    routing.showRoute = (args...) ->
        console.log "showRoute args", args || "" #######
        route = routePath args
        Backbone.history.navigate route, false
        # backbone api prefers `router.navigate route, false` or `router.navigate route, {trigger: false}`

    # creates route based routeParts
    # must be url-encoded FIX
    routePath = (routeParts) ->
        _.reduce routeParts, ((accum, part) -> "#{accum}/#{part}"), ""


    # mainApp default routes / and /home
    # apps handle their own routes

    # depends on router which doesn't exist yet
    #mainApp.Routing.bindRoute "home", "home", "homeapp:show"

    routing.Router = Backbone.Marionette.AppRouter.extend
        #appRoutes: # needs a controller
        appRoutes:
            "": "home"
            #"home": "home"
            "graph":  "showGraphApp" # remove when graphApp has a router

    # handlers for these routes are in the "controller"
    mainApp.addInitializer -> # mainApp.thingApp.addInitializer
        routing.router = new routing.Router
            #controller: mainApp.layout
            controller: mainApp.Routing
        #mainApp.Routing.bindRoute "home", "home", "homeapp:show"

        console.log "routing", routing
        console.log "mainApp.Routing", mainApp.Routing
        console.log "Backbone", Backbone

    routing.home = () ->
        mainApp.vent.trigger "homeapp:show" #
        console.log "Home"

    # actually show the route in the browser
    mainApp.vent.bind "homeapp:show", ->
        mainApp.Routing.showRoute ""




    routing.showGraphApp = () ->
        mainApp.vent.trigger "graphapp:show" #
        console.log "showGraphApp"
    mainApp.vent.bind "graphapp:show", ->
        mainApp.Routing.showRoute "graph"
