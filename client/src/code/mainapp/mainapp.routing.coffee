###
Backbone = require "backbone"
###

window.MainApp.module "Routing", (Routing, MainApp, Backbone, Marionette, $, _) ->

    # updates the url's hash fragment route
    Routing.showRoute = (argmts...) ->
        console.log "showRoute args", argmts #######
        route = getRoutePath(argmts)
        Backbone.history.navigate route, false

    # creates route based routeParts
    getRoutePath = (routeParts) ->
        base = routeParts[0]
        length = routeParts.length
        route = base
        if length > 1
            i = 1

            while i < length
                arg = routeParts[i]
                route = route + "/" + arg  if arg
                i++
        route
