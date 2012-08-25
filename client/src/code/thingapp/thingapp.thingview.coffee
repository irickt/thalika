###
Backbone = require "backbone"

templates, registered on dust

###

thingCssName = "reward"
thingModuleName = "reward"
#thingPathName = "rewards"
thingEventName = "reward"
#thingDataName = "reward"

MainApp.module "#{thingModuleName}App.thingViews", (thingViews, MainApp, Backbone, Marionette, $, _) ->

    serializeDataDetail = ->

    serializeDataPreview = ->

    # full contents of the thing
    ItemDetailView = Backbone.Marionette.ItemView.extend
        tagName: "ul"
        className: "#{thingCssName}-list #{thingCssName}-view"
        #template: "##{thingCssName}-view-template"
        template: "thing.detail" #  "#{thingCssName}.detail"
        #serializeData: serializeDataDetail

    # preview of the thing in the list. click to show its full contents.
    ItemInListView = Backbone.Marionette.ItemView.extend
        tagName: "li"
        #template: "##{thingCssName}-preview-template"
        template: "thing.preview" # "#{thingCssName}.preview"
        #serializeData: serializeDataPreview
        events:
            click: "showItemDetail"
        showItemDetail: (e) ->
            MainApp.vent.trigger "#{thingEventName}:item:show", @model

    # thing list view, renders the individual thing previews
    ListView = Backbone.Marionette.CollectionView.extend
        tagName: "ul"
        className: "#{thingCssName}-list"
        itemView: ItemInListView


    # display a specific item
    thingViews.showItem = (item) ->
        view = new ItemDetailView
            model: item
        MainApp.layout.main.show view

    # display a list of items
    thingViews.showList = (list) ->
        view = new ListView
            collection: list
        MainApp.layout.main.show view


    # display selected item in the main area, triggered by showItem click, above
    MainApp.vent.bind "#{thingEventName}:item:show", (item) ->
        thingViews.showItem item



    console.log "thingViews", this

