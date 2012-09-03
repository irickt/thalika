###
used by views eg
    mainApp.layout.main.show view
    mainApp.layout.navigation.show view
emits layout:rendered to start history

config for the list of sub apps
mainApp.rewardApp
mainApp.accountApp
mainApp.graphApp
###


$ = require "jquery"
_ = require "underscore"
Backbone = require "backbone"

{vent} = require "mainapp/mainapp.js"
mainApp = require "mainapp/mainapp.js"
#mainApp.layout instantiate itself here
#mainApp.content to install itself

# require template(s)

appList =
    reward: "Rewards"
    account: "Account"
    graph: "Graph"
# add Home
# make the apps from configuration

window.MainApp.module "Layout", (layout) ->

    Layout = Backbone.Marionette.Layout.extend
        appList: appList

        template: "main.layout"
        #serializeData: # pass appList to template

        regions:
            navigation: "#navigation"
            main: "#main"

        events:
            "change #app-selector select": "appChanged" # make navigation a separate region?

        initialize: ->
            # `setSelection` always runs with this view as context
            _.bindAll this, "setSelection"

            # bind show events to change controls in the top level layout
            this.setupAppSelectionEvents()


        # the two-way "binding" to the app select popup

        # set the app from the select popup
        appChanged: (e) ->
            e.preventDefault()
            key = $(e.currentTarget).val()
            if key in _.keys this.appList
                 vent.trigger "#{key}:appshow"

        # show the correct app in the select popup.
        setSelection: (app) ->
            this.$("select").val app

        # two good js lessons here that could be clearer
        #   binding to this (the view)
        #       that = this below is necessary but bindAll above isn't
        #       consider =>
        #   closure on values of key in the loop
        #       http://james.padolsey.com/javascript/closures-in-javascript/

        # set the select popup from the app eg a url
        setupAppSelectionEvents: ->
            that = this
            setSel = (key) ->
                -> that.setSelection key
            for key in _.keys this.appList
                vent.bind "#{key}:appshown", (setSel key)



    mainApp.addInitializer ->
        mainApp.layout = new Layout()

        # when the layout has been rendered, start the application ie Backbone.history.start()
        # this loads before Backbone? show should be after the promise resolves
        mainApp.layout.on "show", ->
            vent.trigger "layout:rendered"

        # put the layout in the content region
        mainApp.content.show mainApp.layout


        console.log "layout", mainApp.layout





