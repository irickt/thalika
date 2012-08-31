###
mainApp.vent
thingApp.Tags
thingApp.thingViews
parent mainApp

###

Backbone = require "backbone"


#thingCssName = "reward"
thingModuleName = "reward"
#thingPathName = "reward"
thingDataName = "reward"
thingEventName = "reward"

window.MainApp.module "accountApp", (accountApp, mainApp) ->

    accountApp.Thing = Backbone.Model.extend {}


    # listen for mainApp request to show the default view
    mainApp.router.bind "route:account", ->
        console.log "event", "route:account"
        mainApp.vent.trigger "accountapp:show"
    mainApp.vent.bind "accountapp:show", ->
        console.log "event", "accountapp:show"
        accountApp.showAccount()

    mainApp.router.bind "route:account:test", (test) ->
        console.log "event", "route:account:test", test

    mainApp.router.bind "route:account:new", ->
        console.log "event", "route:account:new"
        mainApp.vent.trigger "accountapp:new:show"
    mainApp.vent.bind "accountapp:new:show", ->
        console.log "event", "accountapp:new:show"
        accountApp.showAccountNew()

    # we're the current view, set up the navigation here (as main does too)
    mainApp.vent.bind "#{thingEventName}app:shown", ->
        accountApp.showNav()

    # the "controller" for the router
    # any app url must trigger navigation set up: showTagList and app selector control
    # in effect incoming urls must pass through app level controller

    # router handler: show all items
    accountApp.showAccount = ->
        mainApp.vent.trigger "account:show"
        mainApp.vent.trigger "accountapp:shown"

    accountApp.showNav = ->
        # compare to tags


    # bind show events to display actions
    # triggered by nav click or route or initialization

    mainApp.vent.bind "account:show", ->
        accountApp.accountViews.showAccount()

    mainApp.vent.bind "account:show:new", ->
        accountApp.accountViews.showAccountNew()


    # two-way "binding" to the browser's address bar
    mainApp.router.bindRoute "account", "account", "accountapp:shown"
    #mainApp.router.bindRoute "account/new", "account:new", "accountapp:new:shown"
    mainApp.router.bindRoute "account/:test", "account:test", "accountapp:test:shown"
