###
Backbone = require "backbone"
$ = require "jquery"
_ = require "underscore"

inject these from config
require rewardApp
require accountApp
require graphApp

template, registered on dust
###

window.MainApp.module "Layout", (layout, mainApp, Backbone, Marionette, $, _) ->

    Layout = Backbone.Marionette.Layout.extend
        template: "main.layout"
        #serializeData:

        regions:
            navigation: "#navigation"
            main: "#main"

        events:
            "change #app-selector select": "appChanged"

        initialize: ->
            # `setSelection` always runs with this view as context
            _.bindAll this, "setSelection"

            # bind show events to change controls in the top level layout
            this.setupAppSelectionEvents()

        # show the correct app in the select popup.
        setSelection: (app) ->
            this.$("select").val app

        # set the select popup from the app eg a url
        setupAppSelectionEvents: ->
            that = this # doesn't bindAll do this?
            mainApp.vent.bind "rewardapp:show", ->
                that.setSelection "rewards"
            mainApp.vent.bind "accountapp:show", ->
                that.setSelection "account"
            mainApp.vent.bind "graphapp:show", ->
                that.setSelection "graph"

        # set the app from the select popup
        appChanged: (e) ->
            e.preventDefault()
            appName = $(e.currentTarget).val()
            if appName is "rewards"
                mainApp.vent.trigger "rewardapp:show"
            else if appName is "account"
                mainApp.vent.trigger "accountapp:show"
            else if appName is "graph"
                mainApp.vent.trigger "graphapp:show"


        # the controller for mainApp

        # public methods called by router
        showRewardApp: ->
            mainApp.vent.trigger "rewardapp:show" # mainApp.rewardApp.showItemsList()
        showAccountApp: ->
            mainApp.vent.trigger "accountapp:show" # mainApp.AccountApp.showAccount()
        showGraphApp: ->
            mainApp.vent.trigger "graphapp:show" # mainApp.graphApp.showGraph()


    # in the "view"
    # actually show the apps
    mainApp.vent.bind "rewardapp:show", ->
        mainApp.rewardApp.showItemsList()
    mainApp.vent.bind "accountapp:show", ->
        mainApp.AccountApp.showAccount()
    mainApp.vent.bind "graphapp:show", ->
        mainApp.graphApp.showGraph()



    mainApp.addInitializer ->
        mainApp.layout = new Layout()

        # when the layout has been rendered, start the application ie Backbone.history.start()
        # this loads before Backbone? show should be after the promise resolves
        mainApp.layout.on "show", ->
            mainApp.vent.trigger "layout:rendered"

        # put the layout in the content region
        mainApp.content.show mainApp.layout


        console.log "layout", mainApp.layout
