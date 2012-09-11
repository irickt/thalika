#!/usr/bin/env coffee

config = require "./config.json" # relative to server.js
sample = require "./sample"

_ = require "underscore"
connect = require "connect"

#path = require "path"
#fs = require "fs"


routes =
    "/data/reward": (req, res) ->
        res.json sample.rewards
    "/data/rewardtags": (req, res) ->
        res.json sample.rewardtags



oldroutes =
    "/email": (req, res) ->
        res.json sample.email
    "/categories": (req, res) ->
        res.json sample.categories
    "/contacts": (req, res) ->
        res.json sample.contacts
    "/": (req, res) ->
        if req.user
            res.html page_template
                text: authed_template
                    user: req.user
        else
            res.html page_template
                text: unauthed_template {}

    "/team": (req, res) ->
        get_team (team) ->
            res.html page_template
                text: team_template team

    "/account": (req, res, next) ->
        if !req.isAuthenticated()
            res.redirect "/login"
        res.html page_template
            text: account_template
                user: req.user

    "/error": (req, res) ->
        res.redirect "/"

    "/logout": (req, res) ->
        req.logout()
        res.redirect "/"

    '/about': (req, res) ->
        res.text "hello"
    '/atlantanodejs': (req, res) ->
        try
            res.html template
                text: 'hello world'
        catch error
            res.notFound('Not found')
    '/api/(\\w+)': (req, res, key) ->
        try
            res.json urlhash key
        catch error
            # res.json({})
            res.notFound('Not found')



connect = require 'connect'
quip = require 'quip'
dispatch = require 'dispatch'

app = connect.createServer()

app.use connect.logger {format: ':method :url :response-time :res[Content-Type]' }
# app.use connect.logger "short"
#app.use connect.logger {format: ':url :remote-addr :referrer :req'}
#app.use connect.dump()

# error handling based on NODE_ENV
app.use connect.errorHandler
    showStack: true
    dumpExceptions: true
    showMessage: true

app.use connect.cookieParser()
app.use connect.bodyParser()
app.use connect.query()
app.use connect.methodOverride()
app.use connect.session secret: config.SESSION_SECRET

app.use quip()
app.use dispatch routes

#app.use connect.favicon __dirname + '/public/favicon.ico'
#app.use connect.static __dirname + "/public"
app.use connect.static config.STATICDIR

app.listen config.PORT

# console.log config # contains secrets
console.log config.MSG ? ""


