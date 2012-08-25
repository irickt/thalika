###
Backbone = require "backbone" # window
###


#thingCssName = "reward"
thingModuleName = "reward"
thingPathName = "reward"
thingEventName = "reward"
#thingDataName = "reward"

window.MainApp.module "Routing.#{thingModuleName}Routing", (thingRouting, MainApp, Backbone, Marionette, $, _) ->

    # handle incoming routes when the url hash is changed
    routes = {}
    routes[""] = "showItemsList"
    routes["#{thingPathName}"] = "showItemsList"
    routes["#{thingPathName}/tag/:tag"] = "showItemsByTag"
    routes["#{thingPathName}/:id"] = "showItemDetail"

    thingRouting.Router = Backbone.Marionette.AppRouter.extend
        appRoutes: routes
            #"": "showItemsList"
            #"#{thingPathName}": "showItemsList"
            #"#{thingPathName}/tag/:tag": "showItemsByTag"
            #"#{thingPathName}/:id": "showItemDetail"

    # handlers for these routes are in the "controller"
    MainApp.addInitializer ->
        thingRouting.router = new thingRouting.Router
            controller: MainApp["#{thingModuleName}App"]


    # send sub-app routing events to main app
    MainApp.vent.bind "#{thingEventName}:show", ->
        MainApp.Routing.showRoute "#{thingPathName}"
    MainApp.vent.bind "#{thingEventName}:item:show", (item) ->
        MainApp.Routing.showRoute "#{thingPathName}", item.id
    MainApp.vent.bind "#{thingEventName}:tag:show", (tag) ->
        MainApp.Routing.showRoute "#{thingPathName}", "tag", tag
