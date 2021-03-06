# note: ship with package.json to allow initial install of dev dependencies

module.exports =
    name: "thalika-client"
    description: "modular web client based on backbone marionette views"
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
    main: "lib/js/start.js"
    dependencies:
        # dependencies included in script tags, but are accessed by `require`. see buildClient.coffee
        underscore: ">=1.3.3"
        backbone: "0.9.2"
        async: "*"
        # jQuery: "*" # in npm it's wrapped for node. does it work for the browser too?
        # d3: "*" # in npm it's for node, depending on jsdom and sizzle.
        # "dustjs-linkedin": "" # the runtime only

    devDependencies:
        #buster: "*" # use the global install
        gluejs: "*"
        icing: "git://github.com/irickt/icing.git#HEAD" # 7f74f22
        'coffee-script': "*"
        "dustjs-linkedin": ""
        mkdirp: ""

    scripts:
        test: "cake test_browser"

    engines:
        node: "0.8.x"




