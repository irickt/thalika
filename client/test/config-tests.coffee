module.exports =
    "browser tests":
        autorun: false
        environment: "browser"
        rootPath: "../",
        sources: [
            "lib/js/mainapp/start.js"
            ]
        tests: [
            "test/browser/test-*.js"
            ]
