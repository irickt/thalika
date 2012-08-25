
window.MainApp.module "graphApp.graphDemo", (graphDemo, MainApp, Backbone, Marionette, $, _) ->

    graphDemo.demo = () ->
    # http://bl.ocks.org/1377729

        nodes = []
        links = []
        labelAnchors = []
        labelAnchorLinks = []

        for i in [0..29]
            node = label: "node " + i
            nodes.push node
            labelAnchors.push node: node
            labelAnchors.push node: node

        for i in [0..(nodes.length - 1)]
            labelAnchorLinks.push # link between node and label
                source: i * 2 # the node
                target: i * 2 + 1 # the label
                weight: 1

            for j in [0..(i-1)]
                if Math.random() > .93
                    links.push # link between two nodes
                        source: i
                        target: j
                        weight: (0.2 + (1 - 2 * 0.2) * Math.random())




        w = 960
        h = 500
        labelDistance = 0
        vis = d3.select(".graph-view").append("svg:svg").attr("width", w).attr("height", h)

        force = d3.layout.force()
            .size([w, h])
            .nodes(nodes)
            .links(links)
            .gravity(1)
            .linkDistance(50)
            .charge(-3000)
            .linkStrength (x) ->
                x.weight * 10
        force.start()

        force2 = d3.layout.force()
            .size([w, h])
            .nodes(labelAnchors)
            .links(labelAnchorLinks)
            .gravity(0)
            .linkDistance(0)
            .charge(-100)
            .linkStrength(8)
        force2.start()

        link = vis.selectAll("line.link")
            .data(links)
            .enter()
            .append("svg:line")
            .attr("class", "link")
            .style("stroke", "#CCC")

        node = vis.selectAll("g.node")
            .data(force.nodes())
            .enter()
            .append("svg:g")
            .attr("class", "node")

        node.append("svg:circle")
            .attr("r", 5)
            .style("fill", "#585")
            .style("stroke", "#FFF")
            .style "stroke-width", 1

        node.call force.drag

        anchorLink = vis.selectAll("line.anchorLink")
            .data(labelAnchorLinks)
            #.enter().append("svg:line").attr("class", "anchorLink").style("stroke", "#999");

        anchorNode = vis.selectAll("g.anchorNode")
            .data(force2.nodes())
            .enter()
            .append("svg:g")
            .attr("class", "anchorNode")

        anchorNode.append("svg:circle")
            .attr("r", 0)
            .style "fill", "#FFF"

        anchorNode.append("svg:text")
            .text (d, i) ->
                (if i % 2 is 0 then "" else d.node.label)
            .style("fill", "#585")
            .style("font-family", "Arial")
            .style "font-size", 12

        updateLink = ->
            this.attr "x1", (d) ->
                d.source.x
            .attr "y1", (d) ->
                d.source.y
            .attr "x2", (d) ->
                d.target.x
            .attr "y2", (d) ->
                d.target.y

        updateNode = ->
            this.attr "transform", (d) ->
                "translate( #{ d.x }, #{ d.y } )"

        force.on "tick", ->
            force2.start()

            node.call updateNode

            anchorNode.each (d, i) ->
                if i % 2 is 0
                    d.x = d.node.x # fix the anchornode to the node
                    d.y = d.node.y
                else
                    b = this.childNodes[1].getBBox() # box around the svg:text
                    diffX = d.x - d.node.x
                    diffY = d.y - d.node.y
                    dist = Math.sqrt(diffX * diffX + diffY * diffY) #
                    shiftX = b.width * (diffX - dist) / (dist * 2)
                    shiftX = Math.max(-b.width, Math.min(0, shiftX))
                    shiftY = 5
                    this.childNodes[1].setAttribute "transform", "translate( #{ shiftX }, #{ shiftY } )"

            anchorNode.call updateNode
            link.call updateLink
            anchorLink.call updateLink
