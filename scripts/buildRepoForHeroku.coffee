
#add test/ for client and server

_ = require "underscore"
path = require "path"
fs = require "fs"
ncp = require('ncp').ncp
mkdirpSync = require("mkdirp").sync
async = require "async"

modulePath = path.dirname path.dirname fs.realpathSync __filename # relative to this file

makeDirIfNeededSync = (targetDir) ->
    if !fs.existsSync targetDir
        console.log "mkdir", targetDir
        mkdirpSync targetDir

makeFileSync = (targetPath, name, text) ->
    targetPath = path.join targetPath, name
    fs.writeFileSync targetPath, text

dryRun = true
copyOneItem = (item, cb) ->
    source = path.join item[0], item[2]
    target = path.join item[1], item[2]
    console.log source
    console.log "    -->  ", target
    if dryRun
        cb null, target
        return
    makeDirIfNeededSync item[1]
    ncp source, target, (err) ->
        cb err, target

copyItems = (items, cb) ->
    async.mapSeries items, copyOneItem, (err, results) ->
        cb err, results

buildDeployRepo = (deployInfo, callback) ->
    console.log "deployInfo", deployInfo
    deployRepoPath = path.resolve deployInfo.deployRepoPath
    console.log "deployRepoPath", deployRepoPath

    # generate files
    tmpPath = path.join modulePath, "tmp"
    makeDirIfNeededSync tmpPath

    makeFileSync tmpPath, "Procfile", """
            web: node lib/js/server.js
        """
    makeFileSync tmpPath, "README.md", """
            Generated files. Do not edit here.
        """

    # make an array of [sourceItem, targetDir]
    copiesToDo = []

    items = """
        index.html
        bundle.js
        tmplBundle.js
        css/
        img/
        lib/
    """
    items = items.split "\n"
    copiesToDo.push ["client/lib", "client", item] for item in items

    items = """
        server/package.json
        server/node_modules/
        server/lib/js/
    """
    items = items.split "\n"
    copiesToDo.push ["server", "server", item] for item in items

    items = """
        Procfile
        README.md
    """
    items = items.split "\n"
    dir = ""
    copiesToDo.push ["tmp/", "", item] for item in items


    copiesWithPaths = []
    copiesWithPaths.push [
        (path.join modulePath, item[0])
        (path.join deployRepoPath, item[1])
        item[2]
    ] for item in copiesToDo
    

    copyItems copiesWithPaths, (callback or ->)







module.exports =
    buildDeployRepo: buildDeployRepo

if require.main == module
    buildDeployRepo
        description: "sample"
        deployRepoPath: "../deploy"

