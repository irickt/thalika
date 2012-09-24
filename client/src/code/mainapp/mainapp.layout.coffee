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
    appList: [
        name: "reward"
        label: "Rewards"
    ,
        name: "account"
        label: "Account"
    ,
        name: "graph"
        label: "Graph"
    ]
# add Home
# make the apps from configuration

Layout = Backbone.Marionette.Layout.extend
    template: "main.layout"

    regions:
        navigation: "#navigation" # used by tags, other app nav
        main: "#main" # used by each main app
        selector: "#app-selector" # used by app selector popup


SelectorView = Backbone.Marionette.ItemView.extend
    tagName: "div" # this is the default
    template: "app.selector"
    appList: appList
    serializeData: ->
        appList # this.appList

    events:
        "change #app-selector div select": "appChanged" # make navigation a separate region?

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
        if key in _.pluck this.appList.appList, "name"
             vent.trigger "#{key}:appshow"

    # show the correct app in the select popup.
    setSelection: (app) ->
        this.$("select").val app

    # three good js lessons here that could be clearer
    #   binding to this.appList in serializeData
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
        for key in  _.pluck this.appList.appList, "name"
            vent.bind "#{key}:appshown", (setSel key)

class MainViews
    constructor: ->
        this.layout = new Layout()
        this.selector = new SelectorView()

        this.layout.bind "show", ->
            # when layout has been rendered (promise resolved)
            vent.trigger "layout:rendered"
            # starts Backbone.history.start() and handles the first route

    start: ->
        # empty layout in the content region
        mainApp.content.show this.layout
        mainApp.layout.selector.show this.selector
        # start the default app


module.exports = MainViews




