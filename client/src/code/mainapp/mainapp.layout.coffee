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
            @setupAppSelectionEvents()

        # show the correct app in the select box.
        setSelection: (app) ->
            @$("select").val app

        setupAppSelectionEvents: ->
            that = this
            MainApp.vent.bind "reward:show", ->
                that.setSelection "rewards"
            MainApp.vent.bind "account:show", ->
                that.setSelection "account"
            MainApp.vent.bind "graph:show", ->
                that.setSelection "graph"

        # Figure out which app is being selected and call the correct object's `show` method.
        appChanged: (e) ->
            e.preventDefault()
            appName = $(e.currentTarget).val()
            if appName is "rewards"
                MainApp.rewardApp.showItemsList()
            else if appName is "account"
                MainApp.AccountApp.showAccount()
            else if appName is "graph"
                MainApp.GraphApp.showGraph()




    MainApp.addInitializer ->
        MainApp.layout = new Layout()

        # when the layout has been rendered, start the application ie Backbone.history.start()
        # this loads before Backbone? show should be after the promise resolves
        MainApp.layout.on "show", ->
            MainApp.vent.trigger "layout:rendered"

        # put the layout in the content region
        MainApp.content.show MainApp.layout
