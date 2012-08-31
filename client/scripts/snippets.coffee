a = 5
for i in [0..(a-1)]
    console.log i


sub = (pattern, args...) ->
    # map positional args to keys
    params = {}
    keys = pattern.match /:([a-z_]+)/g
    for key, i in keys
        key = key.slice 1
        params[key] = args[i]

    # replace in pattern by key
    pattern.replace /:([a-z_]+)/g, (m, capture) -> return params[capture]

sub = (pattern, args...) ->
    keys = pattern.match /:([a-z_]+)/g
    for key, i in keys
        pattern = pattern.replace key, args[i]
    pattern


vals = [1, "c"]

console.log sub "/post/:id/:title", vals...
