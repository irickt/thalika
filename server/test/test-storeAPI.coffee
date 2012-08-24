_ = require 'underscore'

test = require "buster"
assert = test.assertions.assert
refute = test.assertions.refute

config = require( "../../config/config")

test.testCase "host configuration",
    setup:
        node_env = process.env.NODE_ENV

    teardown:
        process.env.NODE_ENV = node_env

    "development config without env on dev machine": ->
        delete process.env.NODE_ENV
        config = config
        if process.platform is 'darwin'
            refute.equals config.PORT, 80
        else
            assert true

