###
Cakefile for top-level application and its clients and servers
See template_notes.txt for general design and project layout

select on config markers eg config.FOR_SERVER
uses subproject scripts to specialize the build




FIX
fix for https://github.com/jashkenas/coffee-script/pull/2373

icing this.exec does shell commands sequentially.
also need an internal synchronous calls.
use async and exec/spawn so they can be mixed

###


# examples of added options
# option '-o', '--output [DIR]', 'directory for compiled code'
# option '-t','--tap','Run tests with tap output'
#option '-t', '--target [TARGET]', 'Deploy to target host platform'
# options.verbose applied to tests



config = require("./config.coffee")
#console.log "config", config
forApplication = config.FOR_APPLICATION
forServer = config.FOR_SERVER
forBrowser = config.FOR_BROWSER
if forApplication then console.log "APPLICATION"
if forServer then console.log "SERVER"
if forBrowser then console.log "BROWSER"


_ = require 'underscore'
_.templateSettings = { interpolate: /\{\{(.+?)\}\}/g }

require 'icing'
path = require 'path'
fs   = require 'fs'
{exec} = require 'child_process'

modulePath  = path.dirname fs.realpathSync __filename # is the location of the Cakefile
# process.cwd() is pwd of the shell where the Cakefile is (must be) run. so, same as modulePath.


###
iterate over an array of source files: `sources`
use regex to get the compiled output file name: `ofile`
call the compiler using a template. (better, pipe to the output file so the cmd format is consistent.)

this is typically used twice for each task:
  once to list all the possible output files
  once to compile the actually changed files

FIX patch icing to add `settings` to the recipe. add settings to context for recipe and outputs.
    then settings.regexes can be used in both.
    see runRecipeContext and ruleGraph.rule, respectively
    currently, both are passed the options array containing command-line options
FIX add a third regex for name if needed
    tname = infile.replace regexes[0], regexes[2]
###
targetedFiles = (task, sourceFiles, regexes, compiler) ->
    cmdTemplate =
        coffee: "cat {{ data.infile }} | coffee -sc > {{ data.outfile }}"
        lessc: "lessc {{ data.infile }} {{ data.outfile }}"
        dustc: "dustc --name={{data.tname}} {{ data.infile }} {{ data.outfile }}"
    for infile in sourceFiles
        outfile = infile.replace regexes[0], regexes[1]
        tname = if infile.indexOf('.dust.html') > 0 then path.basename(infile, ".dust.html") else ""  # ugly special case

        if compiler
            tmpl = _.template cmdTemplate[compiler], null, {variable: 'data'} # 'data' is an efficiency tweak
            console.log task.target, compiler, infile, outfile
            # add the output directory if missing
            if !fs.exists path.dirname outfile
                mkdirp = require "mkdirp"
                mkdirp.sync path.dirname outfile
            task.exec [ tmpl {infile: infile, tname: tname, outfile: outfile} ] # does the cmds sequentially
            continue # no return value needed for compile phase
        outfile # returns [ofile1, ...] # a coffeescript trick



task 'version', 'Version number Use cake -v version for more info. ', (options) ->
    packageData = require "./package.coffee"
    if options.verbose
        console.log "version: ", packageData.version
        console.log "name: ", packageData.name
        console.log "description: ", packageData.description
    else
        console.log packageData.version


task 'dev', 'Open shells. Mac and iTerm2 specific.', (options) ->
    target = path.join modulePath, "scripts/develop.coffee"
    if fs.existsSync target
        exec "coffee " + target


task 'compile:config', 'Convert package.coffee to package.json',
    ['package.coffee', 'config.coffee'],
        outputs: ->
            ['package.json', 'config.json']
            # config.json depends on package.json. always runs both.
        recipe: ->
            data = require "./package.coffee"
            fs.writeFileSync (path.join modulePath, 'package.json'), (JSON.stringify data, null, 4)
           # compare dependencies and prompt "Dependencies were changed. Do npm install."
            data = require "./config.coffee"
            fs.writeFileSync (path.join modulePath, 'config.json'), (JSON.stringify data, null, 4)
            this.finished()



task 'compile:coffee', 'Compile from coffeescript in src to js in lib.',
    ['**/src/code/**/*.coffee'],
        outputs: ->
            console.log "outputs", this.filePrereqs
            regexes = [ /(.*)src\/code\/(.*).coffee/,"$1lib/js/$2.js" ]
            targetedFiles this, this.filePrereqs, regexes
        recipe: ->
            console.log "recipe", this.modifiedPrereqs
            regexes = [ /(.*)src\/code\/(.*).coffee/,"$1lib/js/$2.js" ]
            targetedFiles this, this.modifiedPrereqs, regexes, "coffee"
            this.finished()

task 'compile:templates', 'Compile templates from dust to js',
    ['**/src/tmpl/*.dust.html'],
        outputs: ->
            regexes = [ /(.*)src\/tmpl\/(.*).dust.html/ , "$1lib/tmpl/$2.dust.js" ]
            targetedFiles this, this.filePrereqs, regexes
        recipe: ->
            regexes = [ /(.*)src\/tmpl\/(.*).dust.html/ , "$1lib/tmpl/$2.dust.js" ]
            targetedFiles this, this.modifiedPrereqs, regexes, "dustc"
            this.finished()

task 'compile:style', 'Compile less to css',
    ['**/src/style/*.less'],
        outputs: (options) ->
            regexes = [ /(.*)src\/style\/(.*).less/, "$1lib/css/$2.css" ]
            targetedFiles this, this.filePrereqs, regexes
        recipe: ->
            regexes = [ /(.*)src\/style\/(.*).less/, "$1lib/css/$2.css" ]
            targetedFiles this, this.modifiedPrereqs, regexes, "lessc"
            this.finished()

task 'compile:tests', 'Compile tests from cs to js',
    ['**/test/*.coffee'],
        outputs: (options) ->
            regexes = [ /(.*)test\/(.*).coffee/,"$1test/js/$2.js" ]
            targetedFiles this, this.filePrereqs, regexes
        recipe: ->
            regexes = [ /(.*)test\/(.*).coffee/,"$1test/js/$2.js" ]
            targetedFiles this, this.modifiedPrereqs, regexes, "coffee"
            this.finished()

task 'compile:source', 'Compile code, templates, styles, and tests',
    [
        'task(compile:coffee)'
        'task(compile:templates)'
        'task(compile:style)'
        'task(compile:tests)'
    ],
        outputs: ->
            []
        recipe: ->
            this.finished()

#task 'build:browser', 'Build client bundle.js and copy resources to image',

#task 'build:server', 'Build server code and copy deploy image',


task 'build', 'Build client or server. This does all the above.',
    [
        'task(compile:config)'
        'task(compile:source)'
    ],
        outputs: ->
            [] # public/ ...
        recipe: (options) ->
            if forBrowser
                # build the client bundles with source js and template js.
                # delete templates.dust.js
                target = path.join modulePath, 'lib/tmpl/templates.dust.js'
                if fs.existsSync target
                    fs.unlinkSync target
                # append all outputs to templates.dust.js

            #else if forServer

            # for dev also copy to server/public/
            # if fs.existsSync path.join modulePath, "build/"
            #
            #    this.exec [
            #        "cp lib/js/*.js build/js/"
            #    ]
            # build server ie copy lib/server.js to bin/server.js
            #if fs.existsSync path.join modulePath, "bin/"
            #    this.exec [
            #        "cp lib/js/*.js bin/"
            #    ]
            this.finished()

task 'test', 'Run tests',
    ['task(build)'], (options) -> # equivalent to {recipe: (options) -> ..., outputs: []}
        command = "./node_modules/.bin/buster-test --config test/js/config-tests.js"
        # depends on npm link. or use other project or env alias, or for global install ...
        #command = "/usr/local/lib/node_modules/buster/bin/buster-test --config test/config-tests.js -e browser"
        this.exec [
            command
            ]

task 'deploy', 'Deploy to host',
    [], (options) ->
        console.log options





###
snippets

see jeremyruppel/frosting

# use spawn to exec in a subdirectory
deploySh = spawn "sh", ["some cmd"],
    cwd: process.env.HOME + "/subproject"
    env: _.extend process.env,
        PATH: "full path to ./node_modules/.bin" + ":" + process.env.PATH



exec "coffee -o config/js/ -c config/package.coffee", (error) =>
    packageData = require "./config/js/package.js" # the complied file
    packageJsonPath = path.join modulePath, 'package.json'
    try
        fs.writeFileSync packageJsonPath, (JSON.stringify packageData, null, 4)
        fs.unlinkSync path.join modulePath, 'config/js/package.js'
        this.finished()
    catch error
        this.failed error

###
