# require instead  #!/usr/bin/env coffee

_ = require "underscore"
path = require "path"
fs = require "fs"
ncp = require('ncp').ncp
mkdirpSync = require("mkdirp").sync

modulePath = path.dirname path.dirname fs.realpathSync __filename # relative to this file

copyItems = (items, sourcePath, targetPath) ->
    console.log items
    console.log "sourcePath", sourcePath
    console.log "targetPath", targetPath
    options =
        filter: /.DS_Store/
    _.each items, (sourceItem) ->
        target = path.join targetPath, sourceItem
        targetDir = path.dirname target
        item = path.join sourcePath, sourceItem
        console.log item, target
        if !fs.existsSync targetDir
            console.log "mkdir", targetDir
            mkdirpSync targetDir
        ncp item, target, (err) ->
            console.log item, target
            if err then console.log err

module.exports =
    deploy: (deployName) ->
        console.log "deployName", deployName

        # nice to glob here
        items = """
            index.html
            bundle.js
            tmplBundle.js
            css/
            img/
            lib/
        """
        items = items.split "\n"
        sourcePath = path.join modulePath, "client/lib"
        targetPath = path.resolve "../deploy/lib/"
        copyItems items, sourcePath, targetPath

        items = """
            package.json
            node_modules/
            lib/js/
        """
        items = items.split "\n"
        sourcePath = path.join modulePath, "server"
        targetPath = path.resolve "../deploy/"
        copyItems items, sourcePath, targetPath

        # hack, each item needs its own targetPath
        # wait til async ops above
        #fs.renameSync (path.join targetPath, "lib/js"), path.join targetPath, "js"


###

client/
    lib/
        including top level files
        including css/ img/ lib/
        excluding js/  tmpl/
    test/

server/ (to top directory)
    package.json
    lib/
    node_modules/
    test/

from deploy script
    Procfile (generated)
    README.md ("Generated files. Don't edit here.")

deploy to external repo, not a submodule

###

