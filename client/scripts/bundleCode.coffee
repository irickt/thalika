#!/usr/bin/env coffee

fs = require "fs"
path = require "path"
Glue = require "gluejs"

# modulePath  = process.cwd() # assumes shell pwd is client/ but also called by application
modulePath = path.dirname path.dirname fs.realpathSync __filename # module relative to this file
targetPath = path.join modulePath, "lib/bundle.js"
console.log "bundle target", targetPath

glue = new Glue()
glue
    .basepath("lib/js")
    .include("lib/js")
    .handler( new RegExp(".*.json$"), (opts, done) ->
        console.log opts
        out = "module.exports = " + fs.readFileSync opts.filename
        console.log out
        done opts.relative opts.filename, out
        )
    .exclude(/.*\/bundle.js/)
    .main("lib/js/mainapp/index.js")
    .export("StartApp")
    .replace
        jquery: "window.jQuery"
        underscore: "window._"
        backbone: "window.Backbone"
        d3: "window.d3"
        dust: "window.dust"
        async: "window.async"


#glue
#    .set('debug', true)
    # adds source file annotations to bundle. for browsing code in he console.
    # ugly. scripts eval'ed strings. impossible to read the actual bundle

#glue
    #.defaults
    #    reqpath: modulePath # lib relative to this script # same as the default


glue.render (err, txt) ->
    if err
        console.log err
    else
        fs.writeFileSync targetPath, txt


