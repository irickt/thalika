ascript =  """
    tell application "iTerm"
        -- activate

        -- terminate the first session of the first terminal

        set myterm to (make new terminal)

        tell myterm
            set number of columns to 90
            set number of rows to 90

            set session0 to (launch session "Default Session")
            tell session0
                set name to "server"
                write text "cd thalika/server"
                write text "npm start"
            end tell

            set session1 to (launch session "Default Session")
            tell session1
                set name to "build"
                write text "cd thalika/client"
                write text "cake -w build"
            end tell

            set session2 to (launch session "Default Session")
            tell session2
                set name to "git"
                write text "cd thalika"
                write text "git st"
            end tell

        end tell

    end tell
"""

{exec} = require "child_process"

osascript = (ascript, options, cb) ->
    command = "osascript -ss "
    for line in ascript.split '\n'
        command += ' -e "' + line.replace(/\"/g, '\\"') + '"'
    #"
    exec command, options, (err, outbuf, errbuf) ->
        # console.debug "exec error", err
        if err then cb err else cb null, outbuf

do () ->
    osascript ascript, {}, (err, out) ->
