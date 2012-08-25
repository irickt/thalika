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

window.MainApp.module "Layout", (Layout, MainApp, Backbone, Marionette, $, _) ->

    Layout = Backbone.Marionette.Layout.extend
        #template: "#layout-template"
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
            MainApp.vent.bind "reward:show", ->
                that.setSelection "rewards"
            MainApp.vent.bind "account:show", ->
                that.setSelection "account"
            MainApp.vent.bind "graph:show", ->
                that.setSelection "graph"

        # set the app from the select popup
        appChanged: (e) ->
            e.preventDefault()
            appName = $(e.currentTarget).val()
            if appName is "rewards"
                MainApp.rewardApp.showItemsList()
            else if appName is "account"
                MainApp.AccountApp.showAccount()
            else if appName is "graph"
                MainApp.graphApp.showGraph()




    MainApp.addInitializer ->
        MainApp.layout = new Layout()

        # when the layout has been rendered, start the application ie Backbone.history.start()
        # this loads before Backbone? show should be after the promise resolves
        MainApp.layout.on "show", ->
            MainApp.vent.trigger "layout:rendered"

        # put the layout in the content region
        MainApp.content.show MainApp.layout
