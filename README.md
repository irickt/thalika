



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

Only edit coffeescript, not js or json. 
In particular, only edit package.coffee, not package.json (but keep package.json in the repo for initially installing the dev tools).  
Only edit less, not css.  

Install the testing utility globally. It's huge.   
npm install -g buster  

Symlink Cakefile, client/Cakefile and server/Cakefile. They should stay the same.  
Use forApplication, forBrowser and forServer flags for conditional build.  
Put any additional build scripts in scripts/, server/scripts/ and client/scripts/  

`cake` to see the build commands  
`cake build` does everything during local development
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




