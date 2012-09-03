###
tagsModule.tagsView
parent thingApp
###

_ = require "underscore"
Backbone = require "backbone"
$ = require "jquery"

mainApp = require "mainapp/mainapp.js"
vent = mainApp.vent
#mainApp.layout

# require template(s)

thingCssName = "reward"
thingModuleName = "reward"
thingDataName = "reward"
#thingPathName = "reward"
thingEventName = "reward"

commonData =
    title: "Reward tags"
    route: "#reward"
    standardTags: [
            tag: ""
            label: "Active"
        ,
            tag: "inactive"
            label: "Inactive"
        ,
            tag: "discard"
            label: "Discard"
        ]


window.MainApp.module "#{thingModuleName}App.Tags", (tagsModule) ->

    Tag = Backbone.Model.extend {}
    TagCollection = Backbone.Collection.extend
        url: "/data/#{thingDataName}tags"
        model: Tag

    serializeData = ->
        _.extend commonData,
            customTags: tagsModule.tagCollection.toJSON()
        # context is view

    # view for the list of tags. standard tags hard coded plus dynamic tags
    tagsModule.tagsView = Backbone.Marionette.ItemView.extend
        template: "thing.tags"  #  "#{thingCssName}.tags"
        serializeData: serializeData

        events:
            "click a": "tagClicked"

        tagClicked: (e) ->
            e.preventDefault()
            tag = $(e.currentTarget).data("tag")
            if tag
                vent.trigger "#{thingEventName}:tag:show", tag
                vent.trigger "#{thingEventName}:appshown", "tag", tag # set url
            else
                vent.trigger "#{thingEventName}:appshown" # set url


    # display the tags view
    tagsModule.showTagList = ->
        view = new tagsModule.tagsView
            collection: tagsModule.tagCollection
        mainApp.layout.navigation.show view


    # load the dynamic tags and make the collection for the view
    tagsModule.addInitializer ->
        tagsModule.tagCollection = new TagCollection()
        promise = tagsModule.tagCollection.fetch() # returns jqXHR promise
        # initializer is implemented as a deferred, but doesn't wait on deferreds.

        #test
        promise.done ->
            tagsModule.serializeData = serializeData()

    console.log "tagsModule", this


###
xdata =
    title: "Reward tags"
    route: "#reward"
    standardTags: [
            tag: ""
            label: "Active"
        ,
            tag: "inactive"
            label: "Inactive"
        ,
            tag: "discard"
            label: "Discard"
        ]
    customTags: [
            tag: "vacation"
            label: "Vacation"
        ,
            tag: "food"
            label: "Food"
        ,
            tag: "outdoors"
            label: "Outdoors"
        ,
            tag: "entertainment"
            label: "Entertainment"
        ]
###
