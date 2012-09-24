#!/usr/bin/env coffee

_ = require "underscore"
_.templateSettings =
    interpolate : /\{\{(.+?)\}\}/g

templateString = """
        tell application 'iTerm'
            -- activate

            -- terminate the first session of the first terminal

            set myterm to (make new terminal)

            tell myterm
                set number of columns to 90
                set number of rows to 90

                set session0 to (launch session 'Default Session')
                tell session0
                    set name to 'server'
                    write text 'cd {{ applicationPath }}/server'
                    write text 'npm start'
                end tell

                set session1 to (launch session 'Default Session')
                tell session1
                    set name to 'build'
                    write text 'cd {{ applicationPath }}/client'
                    write text 'cake -w build'
                end tell

                set session2 to (launch session 'Default Session')
                tell session2
                    set name to 'git'
                    write text 'cd {{ applicationPath }}'
                    write text 'git st'
                end tell

            end tell

        end tell
    """
scriptTemplate = _.template templateString.replace /'/g, '"'   #" applescript requires double quotes


# tiny osascript module
{exec} = require "child_process"

osascript = (ascript, options, cb) ->
    command = "osascript -ss "
    for line in ascript.split '\n'
        command += ' -e "' + line.replace(/\"/g, '\\"') + '"'
    #"
    exec command, options, (err, outbuf, errbuf) ->
        # console.debug "exec error", err
        if err then cb err else cb null, outbuf



setUpEnv = (appPath) ->
    script = scriptTemplate
        applicationPath: appPath
    osascript script, {}, (err, out) ->


module.exports =
    setUpEnv: setUpEnv

if require.main == module
    path = require "path"

    cli = require "cli"
    cli.parse
        appPath: ['p', 'Application path', 'string', '']
    #cli.enable "glob"

    cli.main (args, options) ->
        appPath = args[1] or options.appPath
        appPath = path.resolve appPath
        if not appPath
            cli.error "devenv.coffee did nothing. Application path required."
            process.exit 1
        else
            setUpEnv appPath
