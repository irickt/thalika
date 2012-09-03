###
# parent mainApp
accountApp.Nav
accountApp.accountViews
###

Backbone = require "backbone"
{vent, router} = require "mainapp/mainapp.js"


window.MainApp.module "accountApp", (accountApp) ->

    accountApp.Account = Backbone.Model.extend {}

    # two-way "binding" to the browser's address bar
    router.bindRoutes "account"

    # triggered by router or by internal navigation
    vent.bind "account:appshow", (args...) ->
        vent.trigger "account:appshown", args...
        accountApp.showAccount()

    accountApp.showAccount = ->
        vent.trigger "account:views:show"
    # just call it since we own it, or decouple with event
    vent.bind "account:views:show", ->
        accountApp.accountViews.showAccount()

    # any app url will trigger navigation set up
    vent.bind "account:appshown", (args...) ->
        accountApp.showNav()

    accountApp.showNav = ->
        # as for thing tags
        # send event/call



