var ObjectId = require('mongodb').ObjectID;

//Creates a new collectionDriver to manage database insertion, retrieval, and updates
CollectionDriver = function(db) {
   this.db = db;
}

//Function to verify existince and return collection from database
CollectionDriver.prototype.getCollection = function(collectionName, callback){
	//query db for collection
	this.db.collection(collectionName, function(error, the_collection){
		//If there is an error retrieving the collection, return it with the callback, otherwise return the collection
		if(error) callback(error);
		else callback(null, the_collection);
	});
};

//Function to find all elements within a given collection from the database
CollectionDriver.prototype.findAll = function(collectionName, callback){
	//Gets the desired collection
	this.getCollection(collectionName, function(error, the_collection) {
		if(error) callback(error);
		else{
			 //Return an array of retrieved elements in callback function
			 the_collection.find().toArray(function(error, results) {
                         	if(error) callback(error);
                                else callback(null, results);
                          });
		}
	});
};

//Gets an object with passed objectID from the database
CollectionDriver.prototype.get = function(collectionName, id, callback){
	this.getCollection(collectionName, function(error, the_collection) {
		if(error) callback(error);
		else{
			//RegEx to check to make sure passed objectID at least could be valid (so mongodb doesn't return error)
			var checkForHexRegExp = new RegExp("^[0-9a-fA-F]{24}$");
			if(!checkForHexRegExp.test(id)) callback({error: "invalid id"});
			//Finds the object with the given id, doc may be null if id doesn't exist
			else the_collection.findOne({'_id':ObjectId(id)}, function(error, doc) {
				if(error) callback(error);
				else callback(null, doc);
			});
		}
	});
};

//Saves an item to the given collection
CollectionDriver.prototype.save = function(collectionName, obj, callback) {
	this.getCollection(collectionName, function(error, the_collection) {
		if(error) callback(error);
		else{
			//Inserts created_at date before saving
			obj.created_at = new Date();
			the_collection.insert(obj, function(){
				//return object on success
				callback(null, obj);
			});
		}
	});
};


//Updates an existing item in collection with given object id and updated object
CollectionDriver.prototype.update = function(collectionName, obj, entityId, callback) {
	this.getCollection(collectionName, function(error, the_collection) {
		if(error) callback(error);
		else{
			//Set id of passed object to passed objectid
			obj._id = ObjectId(entityId);
			//Sets updated timestamp
			obj.updated_at = new Date();
			the_collection.save(obj, function(error,doc){
				if(error) callback(error);
				else callback(null, obj);
			});
		}
	});
};

//Deletes given objectId from the database
CollectionDriver.prototype.delete = function(collectionName, entityId, callback) {
	this.getCollection(collectionName, function(error, the_collection) {
		if(error) callback(error);
		else{
			//Removes object with given id parameter
			the_collection.findAndModify({"query":{"_id":ObjectId(entityId)}, "remove":true}, function(error,doc) {
				if(error) callback(error);
				else callback(null, doc);
			});
		}
	});
};

//Queries the database for all objects matching query
CollectionDriver.prototype.query = function(collectionName, query, callback){
	this.getCollection(collectionName, function(error, the_collection) {
		if(error) callback(error);
		else{
			//Query passed to find method, results returned in array passed to callback function
			the_collection.find(query).toArray(function(error,results){
				if(error) callback(error);
				else callback(null, results);
			});
		}
	});
};


//Exports the CollectionDriver so it can be used by main server code
exports.CollectionDriver = CollectionDriver;
