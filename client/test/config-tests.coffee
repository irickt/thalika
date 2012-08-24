module.exports =
    "browser tests":
        environment: "browser"
        rootPath: "../",
        sources: [
            "public/js/index.js"
            ]
        tests: [
            "test/browser/test-*.js"
            ]
