var http = require('http'),
    express = require('express'),
    path = require('path')
    MongoClient = require('mongodb').MongoClient,
    Server = require('mongodb').Server,
    CollectionDriver = require('./collectionDriver').CollectionDriver,
    FileDriver = require('./fileDriver').FileDriver,
    UserDriver = require('./userDriver').UserDriver;


//Start running express
var app = express();
//Server listens on port 8000
app.set('port', process.env.PORT || 8000);
//Creates viewengine so we can visually see database information in browser
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

//Set up mongo details
var mongoHost = 'localhost';
var mongoPort = 27017;

//Drivers for database interaction
var fileDriver;
var collectionDriver;
var userDriver;

//Create and open connection to mongodb
var mongoClient = new MongoClient(new Server(mongoHost, mongoPort));
mongoClient.open(function(err, mongoClient) {
	if(!mongoClient){
		console.error("Error! Exiting... Must start MongoDB first");
		process.exit(1);
	}
	//Connect to MyDatabase
	var db = mongoClient.db("MyDatabase");

	//Pass the database to fileDriver, collectionDriver, userDriver
	fileDriver = new FileDriver(db);
	collectionDriver = new CollectionDriver(db);
	userDriver = new UserDriver(db);

	//TEST CODE FOR USER LOGIN
	userDriver.loginUser('users', {'username':'adam', 'password':'adampass'}, function(error, obj){
		if(error) console.log(error);
		else console.log(obj);
	});
});



//Use bodyparser to get post requests and parse the json into objects
app.use(express.bodyParser());

//Allows our site to serve up files in public directory if necessary
app.use(express.static(path.join(__dirname, 'public')));

//If post request is received with files extension
app.post('/files', function(req,res) { 
	//Pass the body of the request to the fileDriver to handle the upload
	fileDriver.handleUploadRequest(req, res);
});

//If get request is received for a fileid
app.get('/files/:id', function(req, res) { 
	//Pass the request to the fileDriver to handle the download
	fileDriver.handleGet(req,res);
});


//Route for recieving a GET request for any collection (other than files since those were received above)
app.get('/:collection', function(req, res, next) {
	//The request parameters
	var params = req.params;
	//The query attached to the request
	var query = req.query.query;

	//If a db query was attached to the request
	if(query) {
		//Parse the query into JSON
		query = JSON.parse(query);
		//Use collectionDriver to query the collection using specified query and handle result in returnCollectionResults
		collectionDriver.query(req.params.collection, query, returnCollectionResults(req,res));
	}
	//If no query was passed
	else{
		//Use collectionDriver to find all elements in collection and handle result in returnCollectionResults
		collectionDriver.findAll(req.params.collection, returnCollectionResults(req,res));
	}
});


//Helper Function to return results from collection route GET request
function returnCollectionResults(req, res){
	return function(error, objs) {
		if(error) {res.send(400, error);}
		else {
			//returns html table of collection if browser, otherwise json for iphone etc...
			if(req.accepts('html')){
				res.render('data', {objects: objs, collection: req.params.collection});
			}
			//Pass back received objects as json type
			else{
				res.set('Content-Type', 'application/json');
				res.send(200, objs);
			}
		}
	};
};


//Route to get a specific object from a collection
app.get('/:collection/:entity', function(req, res){
	//The request parameters (collection and entity)
	var params = req.params;
	var entity = params.entity;
	var collection = params.collection;

	//If an object is passed
	if(entity){
		//Get the entity from the passed collection
		collectionDriver.get(collection, entity, function(error, objs) {
			if(error) { res.send(400, error); }
			else { res.send(200, objs); }
		});
	}
	else {
		res.send(400, {error: 'bad url', url: req.url});
	}
});



//Route to POST a new object and save into collection
app.post('/:collection', function(req, res) {
	//Get the body of the request and collection to be saved into
	var object = req.body;
	var collection = req.params.collection;
	//Save the object to the collection and send the doc back when completed
	collectionDriver.save(collection, object, function(err, docs) {
		if(err){res.send(400, err);}
		else { res.send(201, docs); } 
	});
});

//Route to REPLACE (PUT) an object with a given id in a collection
app.put('/:collection/:entity', function(req, res) {
	//Parameters of request (objectid to update and collection)
	var params = req.params;
	var entity = params.entity;
	var collection = params.collection;
	if(entity){
		//Update the collection with the request body for the entity objectid
		collectionDriver.update(collection, req.body, entity, function(error, objs) {
			if(error) { res.send(400, error); }
			else { res.send(200, objs); }
		});
	}
	else {
		var error = { "message" : "Cannot PUT a whole collection" };
		res.send(400, error);
	}
});

//Route to DELETE an object with a given id from a collection
app.delete('/:collection/:entity', function(req, res) {
	//Gets the parameters from the request (objectid to delete and collection)
	var params = req.params;
	var entity = params.entity;
	var collection = params.collection;
	if(entity){
		//Calls collectionDriver's delete function and sends response with deleted object
		collectionDriver.delete(collection, entity, function(error, objs) {
			if(error) { res.send(400, error); }
			else{ res.send(200, objs); }
		});
	}
	else {
		var error = {"message":"cannot DELETE a whole collection"};
		res.send(400, error);
	}
});


//app.use serves as catch-all for all routes not specified above
app.use(function(req,res) {
   res.render('404', {url:req.url});
});
 
//Create express server and listen for incoming requests
http.createServer(app).listen(app.get('port'), function(){
   console.log('express server listening on port ' + app.get('port'))
});
