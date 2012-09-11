path = require 'path'
packageData = require "./package.coffee"

config =
    base:
        TITLE: packageData.name
        DESCRIPTION: packageData.description
        VERSION: packageData.version
        FOR_SERVER: true

    host:
        development:
            PORT: 4005
            HOST: "local.host"
            STATICDIR: path.resolve process.cwd(), "../client/lib"
        production:
            PORT: 80
            HOST: "sevaa.atlantanodejs.org"
            STATICDIR: path.resolve process.cwd(), "public"

    misc:
        SESSION_SECRET: "x"
        GITHUB_TEAM_ID: "x"
    creds:
        development:
            MEETUP_CLIENT_ID: "dev"
            MEETUP_CLIENT_SECRET: "x"
            GITHUB_CLIENT_ID: "x"
            GITHUB_CLIENT_SECRET: "x"
            GITHUB_ADMIN_TOKEN: "x"
        production:
            MEETUP_CLIENT_ID: "prod"
            MEETUP_CLIENT_SECRET: "x"
            GITHUB_CLIENT_ID: "x"
            GITHUB_CLIENT_SECRET: "x"
            GITHUB_ADMIN_TOKEN: "x"



# move this to cakefile
_ = require "underscore"

makeConfig = (config) ->
    result = {}

    _.extend result, config.base, config.misc

    env = process.env.NODE_ENV ?= (if process.platform is 'darwin' then 'development' else 'production')
    host = if env is "development" then config.host.development else config.host.production
    _.extend result, host

    #creds = if env is "development" then config.creds.development else config.creds.production
    #_.extend result, creds

    str = "http://{{ HOST }}:{{ PORT }}/"
    _.extend result, {BASEURL: _.template str, result }

    str = "\n{{ TITLE }} \n listening on {{ BASEURL }} \n serving from {{ STATICDIR }} \n"
    _.extend result, {MSG: _.template str, result}

    result


module.exports = makeConfig(config)
