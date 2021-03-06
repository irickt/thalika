# note: ship with package.json to allow initial install of dev dependencies

module.exports =
    name: "thalika-server"
    description: "serve sample data and static files"
    version: "0.0.1"
    author: "Rick Thomas"
    repository:
        type: "git"
        url: "https://github.com/irickt/sample-server.git"
    licenses: [
        type: "MIT"
        url: "https://github.com/atlantanodejs/site-app/raw/master/LICENSE"
    ]
    private: true
    main: "lib/js/server.js"
    directories:
        lib: "lib"
    scripts:
        start: "node lib/js/server.js"
    dependencies:
        underscore: ">=1.3.3"
        connect: "1.8.x"
        dispatch: "*"
        quip: "*"
        shred: "*"
    devDependencies:
        #buster: "*" # use the global install
        icing: "git://github.com/irickt/icing.git#HEAD"
        'coffee-script': "*"
        mkdirp: ""

    engines:
        node: "0.8.x"
