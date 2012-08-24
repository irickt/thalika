path = require 'path'
packageData = require "./package"

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


_ = require "underscore"

# move this to scripts if it varies by component
makeConfig = (config) ->
    result = {}

    _.extend result, config.base, config.misc

    _.extend result,
        FOR_SERVER: config.base.FOR_SERVER? or false
        FOR_BROWSER: config.base.FOR_BROWSER? or false

    env = process.env.NODE_ENV ?= (if process.platform is 'darwin' then 'development' else 'production')
    host = if env is "development" then config.host.development else config.host.production
    creds = if env is "development" then config.creds.development else config.creds.production
    _.extend result, host, creds

    str = "http://<%=HOST%>:<%=PORT%>/"
    _.extend result, {BASEURL: _.template str, result }

    str = "\n<%=TITLE%> \n listening on <%=BASEURL%> \n serving from <%=STATICDIR%> \n"
    _.extend result, {MSG: _.template str, result}

    result


module.exports = makeConfig(config)
