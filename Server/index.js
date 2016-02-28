//1
var http = require('http'),
    express = require('express'),
    path = require('path')
    MongoClient = require('mongodb').MongoClient,
    Server = require('mongodb').Server,
    CollectionDriver = require('./collectionDriver').CollectionDriver,
    FileDriver = require('./fileDriver').FileDriver;
    UserDriver = require('./userDriver').UserDriver;

//2
var app = express();
app.set('port', process.env.PORT || 8000);
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

var mongoHost = 'localhost';
var mongoPort = 27017;
var fileDriver;
var collectionDriver;
var userDriver;

var mongoClient = new MongoClient(new Server(mongoHost, mongoPort));
mongoClient.open(function(err, mongoClient) {
	if(!mongoClient){
		console.error("Error! Exiting... Must start MongoDB first");
		process.exit(1);
	}
	var db = mongoClient.db("MyDatabase");
	fileDriver = new FileDriver(db);
	collectionDriver = new CollectionDriver(db);
	userDriver = new UserDriver(db);
	userDriver.loginUser('users', {'username':'adam', 'password':'adampass'}, function(error, obj){
		if(error) console.log(error);
		else console.log(obj);
	});
});


app.use(express.bodyParser());

app.use(express.static(path.join(__dirname, 'public')));

app.post('/files', function(req,res) { fileDriver.handleUploadRequest(req, res);});
app.get('/files/:id', function(req, res) { fileDriver.handleGet(req,res);});


app.get('/:collection', function(req, res, next) {
	var params = req.params;
	var query = req.query.query;
	if(query) {
		query = JSON.parse(query);
		collectionDriver.query(req.params.collection, query, returnCollectionResults(req,res));
	}
	else{
		collectionDriver.findAll(req.params.collection, returnCollectionResults(req,res));
	}
});

function returnCollectionResults(req, res){
	return function(error, objs) {
		if(error) {res.send(400, error);}
		else {
			//returns html table of collection if browser, otherwise json for iphone etc...
			if(req.accepts('html')){
				res.render('data', {objects: objs, collection: req.params.collection});
			}
			else{
				res.set('Content-Type', 'application/json');
				res.send(200, objs);
			}
		}
	};
};

app.get('/:collection/:entity', function(req, res){
	var params = req.params;
	var entity = params.entity;
	var collection = params.collection;
	if(entity){
		collectionDriver.get(collection, entity, function(error, objs) {
			if(error) { res.send(400, error); }
			else { res.send(200, objs); }
		});
	}
	else {
		res.send(400, {error: 'bad url', url: req.url});
	}
});



app.post('/:collection', function(req, res) {
	var object = req.body;
	var collection = req.params.collection;
	collectionDriver.save(collection, object, function(err, docs) {
		if(err){res.send(400, err);}
		else { res.send(201, docs); } 
	});
});


app.put('/:collection/:entity', function(req, res) {
	var params = req.params;
	var entity = params.entity;
	var collection = params.collection;
	if(entity){
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

app.delete('/:collection/:entity', function(req, res) {
	var params = req.params;
	var entity = params.entity;
	var collection = params.collection;
	if(entity){
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


//app.use serves as catch-all after routes
app.use(function(req,res) {
   res.render('404', {url:req.url});
});
 
http.createServer(app).listen(app.get('port'), function(){
   console.log('express server listening on port ' + app.get('port'))
});
