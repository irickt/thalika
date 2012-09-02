# note: ship with package.json to allow initial install of dev dependencies

module.exports =
    name: "tahlika-application"
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

    devDependencies:
        underscore: ">=1.3.3"
        #buster: "*" # use the global install
        icing: "git://github.com/irickt/icing.git"
        'coffee-script': "*"
        mkdirp: ""

    engines:
        node: "0.8.x"
