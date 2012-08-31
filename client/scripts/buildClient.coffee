Glue = require "gluejs"
glue = new Glue()
glue
    .basepath("lib/js")
    .include("lib/js")
    #.exclude(/lib\/js\/lib\/*/)
    .main("lib/js/mainapp/index.js")
    .export("MainApp")
    .replace
        jquery: "window.jQuery"
        underscore: "window._"
        backbone: "window.Backbone"
        d3: "window.d3"
    .defaults
        reqpath: "../.." # lib relative to this script

glue.render (err, txt) ->
        console.log txt
