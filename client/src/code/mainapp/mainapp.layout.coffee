###
used by views eg
    mainApp.layout.main.show view
    mainApp.layout.navigation.show view
used previously as controller for mainApp.router
emits layout:rendered to start history

config for the list of sub apps
mainApp.rewardApp
mainApp.accountApp
mainApp.graphApp
###



$ = require "jquery"
_ = require "underscore"
Backbone = require "backbone"

mainApp = require "mainapp/mainapp.js"
#mainApp.vent
#mainApp.layout instantiate itself here
#mainApp.content to install itself

# require template(s)


window.MainApp.module "Layout", (layout) ->

    Layout = Backbone.Marionette.Layout.extend
        template: "main.layout"
        #serializeData:

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
        # main makes the apps from configuration, API to modify any control references then
        # and have the template use a list instead of hard code, along with "Home"

        # show the correct app in the select popup.
        setSelection: (app) ->
            this.$("select").val app

        # set the select popup from the app eg a url
        setupAppSelectionEvents: ->
            that = this # doesn't bindAll do this?
            mainApp.vent.bind "reward:appshown", ->
                that.setSelection "rewards"
            mainApp.vent.bind "account:appshown", ->
                that.setSelection "account"
            mainApp.vent.bind "graph:appshown", ->
                that.setSelection "graph"

        # set the app from the select popup
        appChanged: (e) ->
            e.preventDefault()
            appName = $(e.currentTarget).val()
            if appName is "rewards"
                mainApp.vent.trigger "reward:appshow"
            if appName is "account"
                mainApp.vent.trigger "account:appshow"
            else if appName is "graph"
                mainApp.vent.trigger "graph:appshow"



    mainApp.addInitializer ->
        mainApp.layout = new Layout()

        # when the layout has been rendered, start the application ie Backbone.history.start()
        # this loads before Backbone? show should be after the promise resolves
        mainApp.layout.on "show", ->
            mainApp.vent.trigger "layout:rendered"

        # put the layout in the content region
        mainApp.content.show mainApp.layout


        console.log "layout", mainApp.layout






        # the controller for mainApp, delegated from the router

        # public methods called by router
        # *** just let the router send the events
        #showRewardApp: ->
        #    mainApp.vent.trigger "rewardapp:show"
        #showGraphApp: ->
        #    mainApp.vent.trigger "graphapp:show"


    # in the "view"
    # *** just have the app listen for its event, which it has installed in main
    # actually show the apps
    #mainApp.vent.bind "rewardapp:show", ->
    #    mainApp.rewardApp.showItemsList()
    #mainApp.vent.bind "graphapp:show", ->
    #    mainApp.graphApp.showGraph()


