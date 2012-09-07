#parent thingApp

Backbone = require "backbone"

{vent} = require "mainapp/mainapp.js"
mainApp = require "mainapp/mainapp.js"
#mainApp.layout

# require template(s)

thingCssName = "reward"
thingModuleName = "reward"
#thingPathName = "rewards"
thingEventName = "reward"
#thingDataName = "reward"


#serializeDataDetail = ->
#serializeDataPreview = ->

# full contents of the thing
ItemDetailView = Backbone.Marionette.ItemView.extend
    # in the region, make this tag (default is div, or pass in `el:`) with these classes, puts the template in it
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
        vent.trigger "#{thingEventName}:item:show", this.model.id # trigger on thingApp
        vent.trigger "#{thingEventName}:appshown", this.model.id # set url

# thing list view, renders the individual thing previews
ListView = Backbone.Marionette.CollectionView.extend
    # in the region, make this tag with these classes, puts a list of these views in it
    tagName: "ul"
    className: "#{thingCssName}-list"
    itemView: ItemInListView


MainApp.module "#{thingModuleName}App.thingViews", (thingViews) ->

    # public methods called by thingApp
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

