###
Backbone = require "backbone"
###


window.MainApp.module "Routing", (routing, mainApp, Backbone, Marionette, $, _) ->

    # updates the url's hash fragment route
    routing.showRoute = (argmts...) ->
        console.log "showRoute args", argmts #######
        route = routePath argmts
        Backbone.history.navigate route, false

    # creates route based routeParts
    routePath = (routeParts) ->
        _.reduce routeParts, ((accum, part) -> "#{accum}/#{part}"), ""


    routing.Router = Backbone.Marionette.AppRouter.extend
        appRoutes:
            "": "showRewardApp"
            "reward": "showRewardApp"
            "account": "showAccountApp"
            "graph": "showGraphApp"

    # handlers for these routes are in the "controller"
    mainApp.addInitializer -> # mainApp.thingApp.addInitializer
        routing.router = new routing.Router
            controller: mainApp.layout



    # actually show the route in the browser
    mainApp.vent.bind "rewardapp:show", ->
        mainApp.Routing.showRoute "reward"
    mainApp.vent.bind "accountapp:show", ->
        mainApp.Routing.showRoute "account"
    mainApp.vent.bind "graphapp:show", ->
        mainApp.Routing.showRoute "graph"
