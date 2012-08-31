###

mainApp.vent
mainApp.layout

parent thingApp

templates, registered on dust

###

Backbone = require "backbone"

thingCssName = "reward"
thingModuleName = "reward"
#thingPathName = "rewards"
thingEventName = "reward"
#thingDataName = "reward"

MainApp.module "accountApp.accountViews", (accountViews, mainApp) -> #, Backbone, Marionette, $, _

    serializeDataDetail = ->

    serializeDataPreview = ->

    # contents of the account
    AccountView = Backbone.Marionette.ItemView.extend
        tagName: "div"
        #className: "#{thingCssName}-list #{thingCssName}-view"
        template: "account" #
        #serializeData: serializeDataDetail

    # form for account data
    AccountFormView = Backbone.Marionette.ItemView.extend
        tagName: "div"
        template: "account.new"
        #serializeData: serializeDataPreview
        events:
            click: "showItemDetail"
        showItemDetail: (e) ->
            mainApp.vent.trigger "account:detail:show", this.model.id # trigger on thingApp


    # public methods called by "controller" ie accountApp

    accountViews.showAccount = () ->
        view = new AccountView()
        mainApp.layout.main.show view

    accountViews.showAccountNew = () ->
        view = new AccountFormView()
        mainApp.layout.main.show view


    console.log "accountViews", this

