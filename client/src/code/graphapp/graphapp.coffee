###
Backbone = require "backbone" # window
MainApp = require "mainapp" # window

template, uses dust
###

window.MainApp.module "graphApp", (graphApp, MainApp, Backbone, Marionette, $, _) ->

    # local
    graphApp.Graph = Backbone.Model.extend {}
    graphApp.GraphCollection = MainApp.Collection.extend
        url: "/graph"
        model: graphApp.Graph


    # handlers called by the router

    # show all items
    graphApp.showGraph = ->
        MainApp.vent.trigger "graph:show"


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
        MainApp.layout.main.show view

    # show all the items
    # triggered by app selection or route or initialization
    MainApp.vent.bind "graph:show", ->
        GraphView.showGraph() # actually make a view and show it




    #MainApp.addInitializer ->
        #graphApp.itemList = new graphApp.GraphCollection()
        #graphApp.itemList.fetch()

