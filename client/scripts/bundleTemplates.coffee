#!/usr/bin/env coffee

fs = require "fs"
path = require "path"

# modulePath  = process.cwd() # assumes shell pwd is client/
modulePath = path.dirname path.dirname fs.realpathSync __filename # relative to this file


sourcePath = path.join modulePath, "lib/tmpl/"
targetPath = path.join modulePath, "lib/tmplBundle.js"

console.log "template bundle source", sourcePath
console.log "template bundle target", targetPath

files = fs.readdirSync(sourcePath)
console.log "template bundle file", files

for file in files
    if file.indexOf("dust.js") == -1 then continue
    str = fs.readFileSync path.join sourcePath, file
    fs.appendFileSync targetPath, (str + "\r")
