###
Backbone = require "backbone"

templates, registered on dust

###

thingCssName = "reward"
thingModuleName = "reward"
#thingPathName = "rewards"
thingEventName = "reward"
#thingDataName = "reward"

MainApp.module "#{thingModuleName}App.thingViews", (thingViews, mainApp, Backbone, Marionette, $, _) ->

    serializeDataDetail = ->

    serializeDataPreview = ->

    # full contents of the thing
    ItemDetailView = Backbone.Marionette.ItemView.extend
        tagName: "ul"
        className: "#{thingCssName}-list #{thingCssName}-view"
        template: "thing.detail" #  "#{thingCssName}.detail"
        #serializeData: serializeDataDetail

    # preview of the thing in the list. click to show its full contents.
    ItemInListView = Backbone.Marionette.ItemView.extend
        tagName: "li"
        template: "thing.preview" # "#{thingCssName}.preview"
        #serializeData: serializeDataPreview
        events:
            click: "showItemDetail"
        showItemDetail: (e) ->
            mainApp.vent.trigger "#{thingEventName}:item:show", this.model.id # trigger on thingApp

    # thing list view, renders the individual thing previews
    ListView = Backbone.Marionette.CollectionView.extend
        tagName: "ul"
        className: "#{thingCssName}-list"
        itemView: ItemInListView


    # public methods called by "controller" ie thingApp
    # display a specific item
    thingViews.showItem = (item) ->
        view = new ItemDetailView
            model: item
        mainApp.layout.main.show view

    # display a list of items
    thingViews.showList = (list) ->
        view = new ListView
            collection: list
        mainApp.layout.main.show view


    console.log "thingViews", this

