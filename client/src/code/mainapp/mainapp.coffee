###
Backbone = require "backbone"
$ = require "jquery"
dust = require "dustjs-linkedin"
###

nextTick = (f) ->
    setTimeout f, 0

MainApp = new Backbone.Marionette.Application()

MainApp.addRegions
    content: ".content"

MainApp.vent.on "layout:rendered", ->
    nextTick ->
        Backbone.history.start()
            #pushState: true

window.MainApp = MainApp


Backbone.Marionette.Renderer.render = (templateName, data) ->
    asyncRender = $.Deferred()
    window.dust.render templateName, data, (err, html) ->
        asyncRender.resolve html
    asyncRender.promise()


###


serializeData = ->
    data = undefined
    if @model
        data = @model.toJSON()
    else if @collection
        data = items: @collection.toJSON()
    @mixinTemplateHelpers(data)

mixinTemplateHelpers = (target) ->
    target = target or {}
    templateHelpers = @templateHelpers
    if _.isFunction(templateHelpers)
        templateHelpers = templateHelpers.call(this)
    _.extend target, templateHelpers



Async.Renderer = render: (template, data) ->
    asyncRender = $.Deferred()
    templateRetrieval = Marionette.TemplateCache.get(template)
    $.when(templateRetrieval).then (templateFunc) ->
        html = templateFunc(data)
        asyncRender.resolve html

    asyncRender.promise()


Backbone.Marionette.TemplateCache::loadTemplate = (templateId, callback) ->
    that = this
    tmpId = templateId.replace("#", "")
    url = "/templates/" + tmpId + ".html"
    promise = $.ajax(url)
    promise.done (templateHtml) ->
        $template = $(templateHtml)
        template = that.compileTemplate($template.html())
        callback template
###
