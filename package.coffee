# note: ship with package.json to allow initial install of dev dependencies

module.exports =
    name: "thalika-application"
    description: "Project template using Node.js Backbone.js Marionette Dustjs D3"
    version: "0.0.1"
    author: "Rick Thomas"
    repository:
        type: "git"
        url: "https://github.com/irickt/thalika.git"
    licenses: [
        type: "MIT"
        url: "https://github.com/atlantanodejs/site-app/raw/master/LICENSE"
    ]
    private: true

    scripts:
        start: "node server/lib/js/server.js"
    dependencies:
        underscore: ">=1.3.3"
        icing: "git://github.com/irickt/icing.git#HEAD"
        'coffee-script': "*"
        "fs-extra": ""
        ncp: ""
        mkdirp: ""
        # these are dependencies as they are needed for its intended purpose

    #devDependencies:
        #buster: "*" # use the global install

    engines:
        node: "0.8.x"
