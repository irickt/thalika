_ = require 'underscore'

test = require "buster"
assert = test.assertions.assert
refute = test.assertions.refute

config = require( "../../lib/js/config.json") # from test/js/ to lib/js/

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

    "production config without env on production machine": ->
        delete process.env.NODE_ENV
        config = config
        if process.platform isnt 'darwin'
            assert.equals config.PORT, 80
        else
            assert true

    "development config with env = dev": ->
        process.env.NODE_ENV = "development"
        config = config
        refute.equals config.PORT, 80

    "production config with env = zzz": ->
        process.env.NODE_ENV = "zzz"
        config = config
        assert.equals config.PORT, 80

