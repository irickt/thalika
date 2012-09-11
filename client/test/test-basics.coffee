test = window.buster # require "buster"

test.testCase "A module",
    "states browser obvious": ->
        assert true
    "fails browser obvious": ->
        assert false
    "// deferred browser obvious": ->
        assert true
