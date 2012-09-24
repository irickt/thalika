Thalika is a collection of software parts useful for experiments in UI and supporting architectures. The goal is quick, interesting demos with simple attractive visual design. In concept it is inspired by http://bl.ocks.org/mbostock where many d3 demos are hosted. While Mike's demos primarily serve to exercise and extend d3 they also suggest many new UI designs worth exploring.

Themes for experiments
* UI with usefully moving elements, fewer fixed forms.
* Interaction with text and relations
* Visualizing and using accumulated links and archives
* Distributed application models
* Visualization of running software
* Dynamic fabrication of apps
* New interaction devices eg Leap Motion
* Demos of promising modules


Why a new "framework", light though it is?
A more comprehensive framework presumes a certain kind of application. (eg Ember, Meteor) Features it never considered are hard to add on. Also, there is value in building out features as an exercise. Knowing a simpler code base allows support for experiments to be built quicker when needed. It favors a simple core and powerful components (even if lightly used). It is biased against pre-integration. In other words, choose the best framework for the purpose and the purpose here is prototyping and discovery.


Consider a live reload utility. We don't need a lot of fancy features and the essential features for reload already exist in the environment:

* Config files and utility scripts instead of a web UI.
* Watch files, as already used to build dependencies and restart server.
* Serve static files including the reload script.
* Invalidate caches when new assets are available, as for updating production resources.
* Communicate a change to the browser, as for pushing model state sync. 
* Trigger the actual reload by rewriting the resource tag using client-side templates.

The goal is to use separate modules for these features, improving them if needed, to implement auto-reload as a simple add-on feature. This should lead to a more flexible and easier to understand designs. (As with testing, any additional use of a module "proves" its interfaces. 367) By integrating anew, though not yielding as fine a tool, the functions are surfaced and may be combined in additional ways.



A blank page for a code sketch, it provides a number of simple features and development tools for convenience.
* Build and reload
* Simple MVC conventions based on the Backbone ecosystem.
* Modularity, introspection, configuration, registry.
* Single page web apps with client and server code sharing.
* Several p2p protocols: SSE, pub/sub, websockets.


Module nursery (by analogy with stellar nursery a gaseous region where stars form)
Demos are modules but probably not to be published in the npm registry.
Features are modules and might be published.


Architecture
* Browser and Node are peers. 
* Configure multiple clients and servers in sets. (Currently there is one client with a few demos and one basic server.)
* Use HTML5 and related features. Target recent browsers or even a single browser that has a feature on the vanguard. Chrome is the default. No browser extensions except developer tools.


Good practices
* Prefer Coffeescript. Javascript contributions may be forked for code sharing.
* Prefer big screens not little pinchy screens.
* Document design decisions. 
* Prefer lesser known modules when there is a choice.
* Easy deployment of demos, but production is a lesser goal.
* Collect tests, browser stats, and feedback from visitors.



