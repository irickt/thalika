###
Backbone = require "backbone"
$ = require "jquery"

template name, registered on dust

###


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



window.MainApp.module "#{thingModuleName}App.Tags", (tagsModule, mainApp, Backbone, Marionette, $, _) ->

    Tag = Backbone.Model.extend {}
    TagCollection = Backbone.Collection.extend
        url: "/data/#{thingDataName}tags"
        model: Tag

    serializeData = ->
        _.extend commonData,
            customTags: tagsModule.tagCollection.toJSON()
        # context is view

    # view for the list of tags. standard tags hard coded plus dynamic tags
    tagsModule.TagsView = Backbone.Marionette.ItemView.extend
        template: "thing.tags"  #  "#{thingCssName}.tags"
        serializeData: serializeData

        events:
            "click a": "tagClicked"

        tagClicked: (e) ->
            e.preventDefault()
            tag = $(e.currentTarget).data("tag")
            if tag
                mainApp.vent.trigger "#{thingEventName}:tag:show", tag
            else
                mainApp.vent.trigger "#{thingEventName}:show"


    # display the tags view
    tagsModule.showTagList = ->
        view = new tagsModule.TagsView
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
