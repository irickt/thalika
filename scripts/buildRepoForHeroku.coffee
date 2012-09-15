
#add test/ for client and server

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

buildDeployRepo = (deployInfo) ->
    console.log "deployInfo", deployInfo
    deployRepoPath = path.resolve deployInfo.deployRepoPath
    console.log "deployRepoPath", deployRepoPath

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
    targetPath = path.join deployRepoPath, "client"
    copyItems items, sourcePath, targetPath

    items = """
        package.json
        node_modules/
        lib/js/
    """
    items = items.split "\n"
    sourcePath = path.join modulePath, "server"
    targetPath = path.join deployRepoPath, "server"
    copyItems items, sourcePath, targetPath



    source = """
        web: node lib/js/server.js
    """
    targetPath = path.join deployRepoPath, "Procfile"
    fs.writeFileSync targetPath, source

    source = """
        Generated files. Do not edit here.
    """
    targetPath = path.join deployRepoPath, "README.md"
    fs.writeFileSync targetPath, source



module.exports =
    buildDeployRepo: buildDeployRepo

if require.main == module
    buildDeployRepo
        description: "sample"
        deployRepoPath: "../deploy"

