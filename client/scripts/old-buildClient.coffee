one = require 'one'

manifest = './package.json'
target   = './js/bundle.js'
options =
    debug: true

    tie: [
        module: "backbone" # includes marionette
        to: "window.Backbone"
    ,
        module: "underscore"
        to: "window._"
    ,
        module: "jquery"
        to: "window.jQuery"
    ,
        module: "d3"
        to: "window.d3"
    ]
    exclude: ["underscore", "backbone"] #, "d3", "jquery"]


one.build manifest, options, (error, bundle) ->
    if error then throw error
    one.save target, bundle, (error) ->
        if error then throw error
        console.log 'bundle.js saved'

#one.modules.filters.push (filename) ->
#    return filename.substring(0, 7) != 'lib/foo'


###
Options

noprocess: Do not include process module.

tie: Registers given object path as a package.
    Usage: tie: [{ 'module': 'pi', 'to': 'Math.PI' }, { 'module': 'json', 'to': 'JSON' }]

exclude: Exclude specified packages from build.
    Usage: exclude: ['underscore', 'request']

ignore: Modules to ignore. .npmignore will not be read if this option is provided.
    Usage: ignore: ['lib/foo.js', 'lib/path/to/a/directory']

sandboxConsole: Sandboxes console object. Disabled by default.

debug: Enables debug mode. Disables module cache and passes in build-time ENV variables.

###


