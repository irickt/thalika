
_ = require "underscore"
Backbone = require "backbone"
$ = require "jquery"
#async = require "async"

{vent} = require "mainapp/mainapp.js"
mainApp = require "mainapp/mainapp.js"
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



Tag = Backbone.Model.extend {}

TagCollection = Backbone.Collection.extend
    url: "/data/#{thingDataName}tags" # pass to constructor?
    model: Tag



class TagsModule
    constructor: ->
        this.tagCollection = new TagCollection()
        this.tagsView = new TagsView
            collection: this.tagCollection

    # called by thingApp
    # display the tags view
    showTagList: ->
        tagApp = this
        fetch = undefined
        if this.tagCollection.length == 0
            fetch = this.tagCollection.fetch()  # returns promise. render waits.
        show = () -> mainApp.layout.navigation.show tagApp.tagsView # returns promise
        $.when(fetch).then show
        # use an async template, so the standard tags are rendered first


# view for the list of tags. standard tags hard coded plus dynamic tags
class TagsView extends Backbone.Marionette.ItemView
    template: "thing.tags"  #  "#{thingCssName}.tags"
    serializeData: ->
        _.extend commonData,
            customTags: this.collection.toJSON()
        # could return promise

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
        # this navigates by data, not url link (shown writes the link, not the direct click)
        # even so it can fail if the clicked url is different (sequence changed?)


module.exports = TagsModule


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
