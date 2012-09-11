path = require 'path'
packageData = require "./package.coffee"

config =
    base:
        TITLE: packageData.name
        DESCRIPTION: packageData.description
        VERSION: packageData.version
        FOR_APPLICATION: true

    host:
        development:
            PORT: 4005
            HOST: "local.host"
            STATICDIR: path.resolve process.cwd(), "./client/lib"
        production:
            PORT: 80
            HOST: "sevaa.atlantanodejs.org"
            STATICDIR: path.resolve process.cwd(), "public"




_ = require "underscore"

makeConfig = (config) ->
    result = {}

    _.extend result, config.base

    result


module.exports = makeConfig(config)
