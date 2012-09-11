#!/usr/bin/env coffee


_ = require "underscore"





 # test case
componentPaths = (components, paths) ->
    cPaths = {}
    _.forEach components, (component) ->
        cPaths[component] = _.filter paths, (path) -> path.indexOf(component) == 0
    cPaths[""] = _.filter paths, (path) -> _.all components, (component) -> path.indexOf(component) == -1
    cPaths

components = ["client/", "server/"]
paths = [
    "p.js"
    "c.js"
    "server/p.js"
    "client/m.js"
    "server/q.js"
    ]

console.log componentPaths components, paths











###
console.log _.map [], ->


a0 = []
a2 = ["x", 2]
mk = (s, a) ->
    a.unshift s
    console.log a
    console.log a.join "/"

mk "r", a0
mk "s", a2


a = 5
for i in [0..(a-1)]
    console.log i


sub = (pattern, args...) ->
    # map positional args to keys
    params = {}
    keys = pattern.match /:([a-z_]+)/g
    for key, i in keys
        key = key.slice 1
        params[key] = args[i]

    # replace in pattern by key
    pattern.replace /:([a-z_]+)/g, (m, capture) -> return params[capture]

sub = (pattern, args...) ->
    keys = pattern.match /:([a-z_]+)/g
    for key, i in keys
        pattern = pattern.replace key, args[i]
    pattern


vals = [1, "c"]

console.log sub "/post/:id/:title", vals...
###
