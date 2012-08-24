


## Thalika
Thalika is the Parrot in the Burmese style of marionette puppetry, Yoke thé.
http://en.wikipedia.org/wiki/Yoke_th%C3%A9


### Features of this boilerplate  

* Client boilerplate using Backbone and Marionette
* Basic server for static files and sample data json for demo and testing.
* All Coffeescript: server and client code and tests, config.coffee, package.coffee (allows comments!)
* Cakefile build scripts for coffee, less, and dust template files. 
* WIP: D3-Backbone integration
* WIP: testing is only stubbed in.
* (TBD Build for client-side require.)
* (TBD live reload for convenient client development.)



### To run the demo client with a sample server:

Go to the client directory, install dependencies, and build  
`cd <top>/client`  
`npm install`  
`cake build`

Go into the server directory, install dependencies, and build  
`cd <top>/server`  
`npm install`  
`cake build`  

Run the server  
`node lib/server.js`  

Browse to  
http://localhost:4005  



### Developing

ONLY edit coffeescript, not js.  
ONLY edit package.coffee, NOT package.json (but keep package.json in the repo for booting the dev tools).  
ONLY edit less, not css.  

Install the testing utility globally. It's huge.   
npm install -g buster  

LINK client/Cakefile and server/Cakefile. They should stay the same.  
Use forBrowser and forServer flags for conditional build.  
Put any additional build scripts in server/scripts/ and client/scripts/  

`cake` to see the build commands  
`cake build` does everything  
`cake -w build` to watch and build on changes  



### Deploying (WIP)
`cake --target heroku deploy` to deploy (WIP)

heroku/ contains a git submodule that is a heroku instance. it exists to push the server image to heroku. there is no need to init it after cloning this repo because its contents are generated during build and deploy.  
http://longair.net/blog/2010/06/02/git-submodules-explained/  

#### add the heroku instance to the repo as `heroku`  
git submodule add git@heroku.com:frozen-gorge-3482.git heroku  
git add .  
git ci -m'heroku submodule'  

#### get the submodule after cloning the repo (not needed)  
git submodule update --init  




