###
Backbone = require "backbone" # window
mainApp = require "mainapp" # window

template, uses dust
###

window.MainApp.module "graphApp", (graphApp, mainApp, Backbone, Marionette, $, _) ->

    # local
    graphApp.Graph = Backbone.Model.extend {}
    graphApp.GraphCollection = mainApp.Collection.extend
        url: "/graph"
        model: graphApp.Graph


    # full contents of the graph
    GraphView = Backbone.Marionette.ItemView.extend
        tagName: "div"
        className: "graph-view"
        template: ->  # "graph.view" # no template used for now
        #serializeData:
        #onRender: graphdemo

        #initialize: () ->
        #    this.setElement (d3.select($('.graph-view')[0]).append('svg')[0])
            # http://stackoverflow.com/questions/9651167/svg-not-rendering-properly-as-a-backbone-view

    GraphView.showGraph = (list) ->
        view = new GraphView {}
        view.on "render", () ->
            #console.log "the view was rendered, but then written over"
            #setTimeout graphdemo, 0
            setTimeout graphApp.graphDemo.demo, 0
            # http://stackoverflow.com/questions/10572906/acting-on-an-element-in-onrender-doesnt-work
        mainApp.layout.main.show view


    # listen for mainApp event
    mainApp.vent.bind "graphapp:show", ->
        graphApp.showGraph()

    # handler called by the router
    graphApp.showGraph = ->
        mainApp.vent.trigger "graph:show"

    # actually make a view and show it
    mainApp.vent.bind "graph:show", ->
        GraphView.showGraph()




    #graphApp.addInitializer ->
        #graphApp.itemList = new graphApp.GraphCollection()
        #graphApp.itemList.fetch()

