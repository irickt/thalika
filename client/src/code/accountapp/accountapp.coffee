
Backbone = require "backbone"
{vent, router} = require "mainapp/mainapp.js"

AccountViews = require "accountapp/accountapp.views.js"


Account = Backbone.Model.extend {}

#window.MainApp.module "accountApp", (accountApp) ->
class AccountApp
    constructor: () ->
        # two-way "binding" to the browser's address bar
        router.bindRoutes "account"

        # triggered by router or by internal navigation
        vent.bind "account:appshow", (args...) =>
            vent.trigger "account:appshown", args...
            this.showAccount()
        # any app url will trigger navigation set up
        vent.bind "account:appshown", (args...) =>
            this.showNav()

        this.accountViews = new AccountViews()

        vent.bind "account:views:show", =>
            this.accountViews.showAccount()


    showAccount: ->
        # set up the data for the view
        vent.trigger "account:views:show" # data
        #  decouple with event, or just call it since we own it

    showNav: ->
        # as for thing tags
        # send event/call



module.exports = AccountApp
