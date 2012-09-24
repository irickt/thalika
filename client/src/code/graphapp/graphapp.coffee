
Backbone = require "backbone"
FilteredCollection = require "mainapp/mainapp.collection.js"
{vent, router} = require "mainapp/mainapp.js"
mainApp = require "mainapp/mainapp.js"
#layout = mainApp.layout
# require template(s)

GraphDemo = require "graphapp/graphdemo.js"
console.log GraphDemo

nextTick = (f) -> setTimeout f, 0

# full contents of the graph
class GraphView extends Backbone.Marionette.ItemView
    tagName: "div"
    className: "graph-view"
    #template: "graph.view"
    #serializeData:

    initialize: ->
        this.graphDemo = new GraphDemo()
        console.log this.graphDemo
        #
        # http://stackoverflow.com/questions/9651167/svg-not-rendering-properly-as-a-backbone-view
        # in backbone, make = (tagName, attributes, content) ->
        #    el = document.createElementNS("http://www.w3.org/2000/svg", tagName)
        #   $(el).attr attributes  if attributes
        #    $(el).html content  if content
        #    el
        #
        # this.setElement (d3.select($('.graph-view')[0]).append('svg')[0])
        #
        # in graphDemo, d3.select(".graph-view").append("svg:svg")

    onRender: =>
        nextTick nextTick this.graphDemo.demo
        # return a deferred to cause `render` event to wait on this
        #
        #this.graphDemo.demo()
        #
        # http://stackoverflow.com/questions/10572906/acting-on-an-element-in-onrender-doesnt-work
        #
        # Async.ItemView render calls these in sequence, waiting on each
        #    beforeRender
        #    serializeData
        #    render
        #    $el.html and onRender
        # the dom change from $el.html happens after onRender, replacing the svg
        # instead put this in beforeRender, then target the html at another el
        #
        # the additional nextTick allows the demo to be ready ???



Graph = Backbone.Model.extend {}
GraphCollection = FilteredCollection.extend
    url: "/graph"
    model: Graph


#window.MainApp.module "graphApp", (graphApp) ->
class GraphApp
    constructor: ->

        # two-way "binding" to the browser's address bar
        router.bindRoutes "graph"

        # listen for mainApp event
        vent.bind "graph:appshow", =>
            vent.trigger "graph:appshown"
            this.showGraph()

        # actually make a view and show it
        #vent.bind "graph:show", ->
        #    this.showGraph()
        #showGraph: ->
        #    vent.trigger "graph:show"

        this.graphView = new GraphView()


    showGraph: () ->
        console.log "showGraph", this
        mainApp.layout.main.show this.graphView # returns deferred

module.exports = GraphApp
