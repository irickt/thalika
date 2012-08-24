packageData = require "../package"

config =
    base:
        TITLE: packageData.name
        DESCRIPTION: packageData.description
        VERSION: packageData.version
        FOR_BROWSER: true

module.exports = config.base # in general, extend the result with all leaf kv's pace namespace collisions

