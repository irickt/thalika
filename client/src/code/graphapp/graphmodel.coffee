
global._ = _ = require "underscore"
global.Backbone = Backbone = require "Backbone"
Supermodel = require "./node_modules/supermodel/supermodel.js"
#Supermodel = require "supermodel" # added main: in package.json
Supermodel = Supermodel.Supermodel

# only works at top scope?
log = (str) ->
    console.log str, " --> ", eval str

#console.log _
#console.log Backbone
#console.log Supermodel

###
An Accord represents a directed relation between two Services.
A Service can have many of these relations, thus many Accords.
An Accord has exactly one whyService and one howService.
(The "why" service is a customer - a reason for this service. The "how" service is a provider - a means for this service. This is a mnemonic to make the code more intuitive, but this module is a simple directed graph so it can be used for any similar structure.)


module.exports = Service

API design
    Service::makeAccordWith ... isWhyFor, isHowFor, relate services, making accord
    Service::breakAccordWith ...
    ... also get the attributes of the accord
    Service::whyServices
    Service::howServices
    ... also expose the service collection, no need to duplicate it

private
    Accord::accordServices -> [whyService, howService]



`Model.create` (instead of `new`)
    class has a collection of instances
    checks if an object is a model (by cid and object identity)
    check if object is is collection (by id)
    parses the object to install any relations

associations are made in One::replace
    which triggers associate: to the related model


Overall, compared to a simple DAG this seems like too much machinery. But it includes the essential techniques if efficiency is important.

###


Service = Supermodel.Model.extend
    #constructor: () ->
        #this.id = _.uniqueId "service_"

    makeAccordWith: (otherService, otherDirection, label) ->
        [whyService, howService] = if otherDirection is "why" then [otherService, this] else [this, otherService]
        accord = Accord.create
            id: _.uniqueId "accord_"
            label: label
            whyService_id: whyService.id
            howService_id: howService.id

    breakAccordWith: (otherService, otherDirection) ->
        # there may one accord per direction between two services. first, know which one.
        [whyService, howService] = if otherDirection is "why" then [otherService, this] else [this, otherService]
        accord = _.intersection whyService.howAccords().models, howService.whyAccords().models
        if accord[0] then accord[0].destroy()

        # delete this accord and both services dissociate. verify

    isWhyFor: (howService, label) ->
        accord = Accord.create
            id: _.uniqueId "accord_"
            label: label
            whyService_id: this.id
            howService_id: howService.id

    isHowFor: (whyService, label) ->
        accord = Accord.create
            id: _.uniqueId "accord_"
            label: label
            whyService_id: whyService.id
            howService_id: this.id


Services = Backbone.Collection.extend
    model: (attrs, options) ->
        Service.create attrs, options


Accord = Supermodel.Model.extend
    #constructor: () ->
        #this.id = _.uniqueId "accord_"
    sync: -> # no sync so destroy works without server

    accordServices: () ->
        [this.whyService(), this.howService()]

Accords = Backbone.Collection.extend
    model: (attrs, options) ->
        Accord.create attrs, options

# these add super models, return the model (chainable)
Accord.has().one "howService",
    model: Service
    inverse: "whyAccords"
Service.has().many "whyAccords",
    collection: Accords
    inverse: "howService"

Accord.has().one "whyService",
    model: Service
    inverse: "howAccords"
Service.has().many "howAccords",
    collection: Accords
    inverse: "whyService"

Service.has().many "whyServices",
    collection: Services
    source: "whyService"
    through: "whyAccords"

Service.has().many "howServices",
    collection: Services
    source: "howService"
    through: "howAccords"


#tests
#for other tests, see file://localhost/Users/rick/_engine/service_visualization/client/out/service-accord.coffee

serviceX = Service.create
    id: _.uniqueId "service_"
    label: "serviceX"

serviceY = Service.create
    id: _.uniqueId "service_"
    label: "serviceY"

serviceZ = Service.create
    id: _.uniqueId "service_"
    label: "serviceZ"

serviceV = Service.create
    id: _.uniqueId "service_"
    label: "serviceV"

accordM = serviceZ.makeAccordWith serviceX, "why", "accordM"
accordL = serviceZ.breakAccordWith serviceX, "why"
#log "accordM == accordL"

accordN = serviceZ.isWhyFor serviceV, "accordN"

accordA = Accord.create
    id: _.uniqueId "accord_"
    label: "accordA"
    whyService_id: serviceX.id
    howService_id: serviceY.id

accordB = Accord.create
    id: _.uniqueId "accord_"
    label: "accordB"
    whyService_id: serviceY.id
    howService_id: serviceZ.id


#log "service0"
#log "service0.id"
#log "accordA"


log "accordA.whyService() == serviceX"
log "accordA.howService() == serviceY"
log "accordB.whyService() == serviceY"
log "accordB.howService() == serviceZ"
log "serviceX.howAccords().contains(accordA)"
log "serviceX.whyAccords().models.length"
log "serviceX.howAccords().models.length"
log "serviceY.whyAccords().models.length"
log "serviceY.howAccords().models.length"
log "serviceZ.whyAccords().models.length"
log "serviceZ.howAccords().models.length"

log "serviceY.howServices().contains(serviceZ)"
log "serviceY.whyServices().contains(serviceX)"

#log "serviceX.whyServices().contains(serviceY)"
log "serviceX.howServices().contains(serviceY)"

#log "serviceZ.howServices().contains(serviceY)"
log "serviceZ.whyServices().contains(serviceY)"

log "serviceX.whyServices().toJSON()"
log "serviceX.howServices().toJSON()"
log "serviceY.whyServices().toJSON()"
log "serviceY.howServices().toJSON()"
log "serviceZ.whyServices().toJSON()"
log "serviceZ.howServices().toJSON()"

accords = serviceZ.whyAccords()
for accord in accords.models
    console.log accord.get("label")

services = Service.all().models
sl = services[0].label
console.log sl
#accords = Accords.all().models

###


serviceX.makeAccordWith serviceY, "how", "0:why 1:how"
serviceX.makeAccordWith serviceZ, "why", "0:how 2:why"

other = service0.servicesInAccord "why"

console.log "service0", service0.toJSON()
console.log "other", service0.toJSON()

accord = service0.accords().at(0)

joins = accord.joins()

services = accord.accordServices()


console.log "accord", accord.toJSON()
console.log "joins", joins.toJSON()
###
