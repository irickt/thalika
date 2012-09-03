

Backbone = require "backbone"
FilteredCollection = require "mainapp/mainapp.collection.js"
mainApp = require "mainapp/mainapp.js"
router = mainApp.router
vent = mainApp.vent
#layout = mainApp.layout
# require template(s)


window.MainApp.module "graphApp", (graphApp) ->

    # local
    graphApp.Graph = Backbone.Model.extend {}
    graphApp.GraphCollection = FilteredCollection.extend
        url: "/graph"
        model: graphApp.Graph


    # full contents of the graph
    GraphView = Backbone.Marionette.ItemView.extend
        tagName: "div"
        className: "graph-view"
        template: ->  # "graph.view" # no template used for now
        #serializeData:
        #initialize: () ->
        #    this.setElement (d3.select($('.graph-view')[0]).append('svg')[0])
        # http://stackoverflow.com/questions/9651167/svg-not-rendering-properly-as-a-backbone-view

    GraphView.showGraph = (list) ->
        view = new GraphView {}
        view.on "render", () ->
            setTimeout graphApp.graphDemo.demo, 0
            #console.log "the view was rendered, but then written over"
            # http://stackoverflow.com/questions/10572906/acting-on-an-element-in-onrender-doesnt-work
        mainApp.layout.main.show view


    # two-way "binding" to the browser's address bar
    router.bindRoutes "graph"

    # listen for mainApp event
    vent.bind "graph:appshow", ->
        vent.trigger "graph:appshown"
        graphApp.showGraph()

    graphApp.showGraph = ->
        vent.trigger "graph:show"


    # actually make a view and show it
    vent.bind "graph:show", ->
        GraphView.showGraph()

