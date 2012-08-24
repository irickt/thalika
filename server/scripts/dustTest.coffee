

tags =
    title: "Reward tags"
    route: "#reward"
    standardTags: [
            tag: ""
            label: "Active"
        ,
            tag: "inactive"
            label: "Inactive"
        ,
            tag: "discard"
            label: "Discard"
        ]
    customTags: [
            tag: "vacation"
            label: "Vacation"
        ,
            tag: "food"
            label: "Food"
        ,
            tag: "outdoors"
            label: "Outdoors"
        ,
            tag: "entertainment"
            label: "Entertainment"
        ]

tmpl = """
<p>{title}</p>
<ul class='standardTags'>
    {#standardTags}
    <li>
        <a href="{route}/{tag}" data-tag="{tag}">{label}</a>
    </li>
    {/standardTags}
</ul>
<ul class='customTags'>
    {#customTags}
    <li>
        <a href="{route}/{tag}" data-tag="{tag}">{label}</a>
    </li>
    {/customTags}
</ul>
"""
#"

dust = require "dustjs-linkedin"

compiled = dust.compile tmpl, "tags"
console.log compiled

dust.loadSource compiled

dust.render "tags", tags, (err, out) ->
  console.log err, out



###
base = dust.makeBase
    route: "reward"
base = base.push tags
console.log base
###
