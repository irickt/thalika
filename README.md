


### To run the demo client with a sample server:

Install these development utilities globally:  
`npm install -g coffee-script`  
`npm install -g dustjs-linkedin`  
`npm install -g less`  

Go to the client directory, install dependencies, and build  
`cd <top>/client`  
`npm install`  
`cake build`

Go into the server directory, install dependencies, and build  
`cd <top>/server`  
`npm install`  
`cake build`  

Run the server  
`node lib/js/server.js`  

Browse to  
http://localhost:4005  



### Developing

Only edit coffeescript, not js or json. 
In particular, only edit package.coffee, not package.json (but keep package.json in the repo for initially installing the dev tools).  
Only edit less, not css.  

Install the testing utility globally. It's huge.   
`npm install -g buster`  

Link Cakefile, client/Cakefile and server/Cakefile. They should stay the same.  
`ln Cakefile client/Cakefile`  
`ln Cakefile server/Cakefile`  

Use forApplication, forBrowser and forServer flags for conditional build.  
Put any additional build scripts in scripts/, server/scripts/ and client/scripts/  

`cake` to see the build commands  
`cake build` does everything during local development
`cake -w build` to watch and build on changes  



### Deploying (WIP)
`cake --target heroku deploy` to deploy (WIP)

