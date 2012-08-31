###
Backbone = require "backbone" # window
mainApp.vent
mainApp.Routing
mainApp.addInitializer # should be thingRouting.addInitializer
mainApp.thingApp
parent Routing

###


#thingCssName = "reward"
thingModuleName = "reward"
thingPathName = "reward"
thingEventName = "reward"
#thingDataName = "reward"

window.MainApp.module "Routing.#{thingModuleName}Routing", (thingRouting, mainApp, Backbone, Marionette, $, _) ->

    # instead of defining on Routing and looking up thingApp, define on thingApp and look up Routing


    # two-way "binding" to the browser's address bar

    # handle incoming routes when the url hash is changed
    routes = {}
    routes["#{thingPathName}"] = "showItemsList"
    routes["#{thingPathName}/tag/:tag"] = "showItemsByTag"
    routes["#{thingPathName}/:id"] = "showItemDetail"

    thingRouting.Router = Backbone.Marionette.AppRouter.extend
        appRoutes: routes
            #"#{thingPathName}": "showItemsList"
            #"#{thingPathName}/tag/:tag": "showItemsByTag"
            #"#{thingPathName}/:id": "showItemDetail"

    # actually show the route in the browser
    mainApp.vent.bind "#{thingEventName}:show", ->
        mainApp.Routing.showRoute "#{thingPathName}"
    mainApp.vent.bind "#{thingEventName}:item:show", (itemid) ->
        mainApp.Routing.showRoute "#{thingPathName}", itemid
    mainApp.vent.bind "#{thingEventName}:tag:show", (tag) ->
        mainApp.Routing.showRoute "#{thingPathName}", "tag", tag


    # handlers for these routes are in the "controller"
    mainApp.addInitializer -> # mainApp.thingApp.addInitializer
        thingRouting.router = new thingRouting.Router
            controller: mainApp["#{thingModuleName}App"] # look up thingApp



