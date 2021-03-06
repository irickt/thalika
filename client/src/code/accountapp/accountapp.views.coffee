
Backbone = require "backbone"
$ = require "jquery"

{vent} = require "mainapp/mainapp.js"
mainApp = require "mainapp/mainapp.js"
# mainApp.layout

# require template(s)


thingCssName = "reward"
thingModuleName = "reward"
#thingPathName = "rewards"
thingEventName = "reward"
#thingDataName = "reward"



sampleData = ->
    dogs = new Backbone.Collection(model: Backbone.Model)
    dogs.add
        id: 1
        name: "Andy"
        collar: "yellow"
    dogs.add
        id: 2
        name: "Biff"
        collar: "red"
    dogs.add
        id: 3
        name: "Candy"
        collar: "green"

    phoneConverter = (direction, value) ->
        if direction is Backbone.ModelBinder.Constants.ModelToView
            fP = "" # formattedPhone
            if value
                fP = value.replace(/[^0-9]/g, "")
                if fP.length is 7
                    fP = fP.substring(0, 3) + "-" + fP.substring(3, 7)
                else if fP.length is 10
                    fP = "(" + fP.substring(0, 3) + ") " + fP.substring(3, 6) + "-" + fP.substring(6, 10)
                else if fP.length is 11 and fP[0] is "1"
                    fP = "1 (" + fP.substring(1, 4) + ") " + fP.substring(4, 7) + "-" + fP.substring(7, 11)
            fP
        else
            value.replace /[^0-9]/g, ""

    person = new Backbone.Model
        firstName: "Bob"
        graduated: "maybe"
        phone: "1234567"

    return [dogs, phoneConverter, person]
[dogs, phoneConverter, person] = sampleData()

formBindings =
    firstName: "[name=firstName]"
    lastName: "[name=lastName]"
    driversLicense: "[name=driversLicense]"
    motorcycle_license: "[name=motorcycleLicense]"
    #graduated: "[name=graduated]"
    #eyeColor: "[name=eyeColor]"
    graduated: [
        selector: "[name=graduated]"
    ,
        selector: "[name=driversLicense],[name=motorcycleLicense]"
        elAttribute: "enabled"
        converter: (direction, value) ->
            value is "yes"
    ]
    eyeColor: [
        selector: "[name=eyeColor]"
    ,
        selector: "span.label"
        elAttribute: "style"
        converter: (direction, value) ->
            "color:" + value
    ]
    phone:
        selector: "[name=phone]"
        converter: phoneConverter
    dog:
        selector: "[name=dog]"
        converter: (new Backbone.ModelBinder.CollectionConverter(dogs)).convert
    bigText: "[name=bigText]"


# contents of the account
AccountView = Backbone.Marionette.ItemView.extend
    tagName: "div"
    #className: "#{thingCssName}-list #{thingCssName}-view"
    template: "account" #
    #serializeData: serializeDataDetail

    model: person
    _modelBinder: `undefined`
    initialize: ->
        this._modelBinder = new Backbone.ModelBinder()
    onRender: ->
        this._modelBinder.bind this.model, this.$el, formBindings

# form for account data
AccountFormView = Backbone.Marionette.ItemView.extend
    tagName: "div"
    template: "account.new"
    #serializeData: serializeDataPreview
    events:
        click: "showItemDetail"
    showItemDetail: (e) ->
        vent.trigger "account:detail:show", this.model.id # trigger on thingApp



#MainApp.module "accountApp.accountViews", (accountViews) ->
class AccountViews
    #constructor: () ->

    # public methods called by "controller" ie accountApp
    showAccount: () ->
        view = new AccountView()
        console.log "new AccountView", view
        mainApp.layout.main.show view

    showAccountNew: () ->
        view = new AccountFormView()
        mainApp.layout.main.show view


module.exports = AccountViews
