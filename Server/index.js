var http = require('http'),
    express = require('express'),
    path = require('path')
    MongoClient = require('mongodb').MongoClient,
    Server = require('mongodb').Server,
    CollectionDriver = require('./collectionDriver').CollectionDriver,
    FileDriver = require('./fileDriver').FileDriver,
    UserDriver = require('./userDriver').UserDriver,
    session = require('client-sessions');


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

});



//Use bodyparser to get post requests and parse the json into objects
app.use(express.bodyParser());

//session handler with basic configurations
app.use(session({
	cookieName:'session',
	secret: 'idofjwerj0932j90jiapoaodaoijw0r93j289',
	duration: 30*60*1000,
	activeDuration: 5*60*1000,
}));

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

//If login comes with post request
app.post('/login', function(req, res)
{
	//Pass userDriver username/login combo to verify login
	userDriver.loginUser('users', req.body, function(error, obj){
		if(error) {
			//Error could be username taken, incorrect password, or db errors
			res.send(401, error);
		}
		else {
			//Set the session user to the returned object and send a success back to client
			req.session.user = obj;
			res.send(200, "Login Success");
		}
	});
});

app.post('/register', function(req, res){

	userDriver.save('users', req.body, function(error, obj)
	{
		if(error)
		{
			res.send(409, error);
		}
		else{
			req.session.user = obj;
			res.send(200, "Register Success");
		}
	});
});

//Tests whether user is logged in, only used for testing
app.get('/isLoggedIn', function(req, res)
{
	//If session and session user are not null, user is logged in
	if(req.session && req.session.user)
	{
		res.send(200, "logged in");
	}
	else{
		res.send(200, "not logged in");
	}
});

//Get route to logout currently logged in user
app.get('/logout', function(req, res)
{
	//Resets the request's session and responds with logout message
	req.session.reset();
	res.send(200, "logged out");
});


app.get('/:collection/myOrders', function(req, res, next){
	//The request parameters
	var params = req.params;
	var query = req.query.query;

	if(req.session && req.session.user){
		collectionDriver.query(req.params.collection, query , returnCollectionResults(req,res));

	}

});

app.get('/:collection/myDeliveries', function(req, res, next){
	//The request parameters
	var params = req.params;
	var query = req.query.query;
	if(req.session && req.session.user){
		collectionDriver.query(req.params.collection, {$and : [{"deliverer_id": req.session.user._id }, query]}, returnCollectionResults(req,res));

	}

});
//Route for recieving a GET request for any collection (other than files since those were recved above)
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

	if(req.session && req.session.user)
	{
		object.buyer_id = req.session.user._id;
		object.buyer_name = req.session.user.username;
		//Save the object to the collection and send the doc back when completed
		collectionDriver.save(collection, object, function(err, docs) {
			if(err){res.send(400, err);}
			else { res.send(201, docs); } 
		});
	}
	
});


app.put('/:collection/:entity/deliveryAccept', function(req, res) {
	//Parameters of request (objectid to update and collection)
	var params = req.params;
	var entity = params.entity;
	var collection = params.collection;
	var object = req.body;
	if(entity){
		//Update the collection with the request body for the entity objectid
		if(req.session && req.session.user)
		{
			object.deliverer_id = req.session.user._id;
			object.deliverer_name = req.session.user.username;
			collectionDriver.update(collection, object, entity, function(error, objs) {
			if(error) { res.send(400, error); }
			else { res.send(200, objs); }
			});
		}
		
	}
	else {
		var error = { "message" : "Cannot PUT a whole collection" };
		res.send(400, error);
	}
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


//Route to DELETE an object with a given id from a collection
app.delete('/:collection/:entity/:deleteID', function(req, res) {
	//Gets the parameters from the request (objectid to delete and collection)
	var params = req.params;
	var entity = params.entity;
	var collection = params.collection;
	var deleteOrdererId = params.deleteID;

	if(entity && req.session && req.session.user && deleteOrdererId == req.session.user._id){
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
