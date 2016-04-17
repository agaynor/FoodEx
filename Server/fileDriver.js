var ObjectID = require('mongodb').ObjectID, 
	fs = require('fs');

//Creates object to wrap database and handle file uploads
FileDriver = function(db) {
	this.db = db;
};

//Gets file collection from database
FileDriver.prototype.getCollection = function(callback) {
	this.db.collection('files', function(error, file_collection){
		if(error) callback(error);
		else callback(null, file_collection);
	});
};

//Gets the passed fileId from files collection
FileDriver.prototype.get = function(id, callback) {
	this.getCollection(function(error, file_collection){ 
		if(error) callback(error);
		else{
			//Checks to make sure the fileID is a valid mongodb id
			var checkForHexRegExp = new RegExp("^[0-9a-fA-F]{24}$");
			if(!checkForHexRegExp.test(id)) callback({error:"invalid id"});
			//Return the entry for the file
			else file_collection.findOne({'_id':ObjectID(id)}, function(error, doc) { 
				if(error) callback(error);
				else callback(null, doc);
			});
		}
	});
};

//Retrieves a file from passed fileid
FileDriver.prototype.handleGet = function(req, res) {
	//fileid from request
	var fileId = req.params.id;
	if(fileId){
		//attempt to get the fileid
		this.get(fileId, function(error, thisFile) {
			if(error) {res.send(400, error);}
			else{
				//if file is returned
				if(thisFile){
					//extract filename and type
					var filename = fileId + thisFile.ext;
					//All files kept in ./uploads
					var filePath = './uploads/' + filename;
					//send file in the response
					res.sendfile(filePath);
				}
				else res.send(404, 'file not found');
			}
		});
	}
};

//Helper method to save a file object to the db
FileDriver.prototype.save = function(obj, callback) {
	this.getCollection(function(error, the_collection) {
		if(error) callback(error);
		else{
			//Set file created at date
			obj.created_at = new Date();	
			the_collection.save(obj, function(){
				callback(null, obj);
			});
		}
	});
};

//Saves a new fileobject and returns the id
FileDriver.prototype.getNewFileId = function(newobj, callback) {
	//Uses helper method above to save fileobject
	this.save(newobj, function(err, obj){
		if(err) { callback(err); }
		else {
			//Passes id back in callback function 
			callback(null, obj._id); 
		}
	});
};

//Handles a fileupload from the server
FileDriver.prototype.handleUploadRequest = function(userid, req, res) {
	//Gets content-type of the file
	var ctype = req.get('content-type');
	//Get the extension of the file
	var ext = ctype.substr(ctype.indexOf('/')+1);
	if(ext) {ext = '.' + ext;} else{ext = '';}
	//Create a new file entry in the database with specified extension and content-type
	this.getNewFileId({'_id':ObjectID(userid), 'content-type':ctype, 'ext':ext}, function(err,id){
		if(err){res.send(400,err);}
		else{
			//Set filename to the fileid in the db and the extension appended
			var filename = id+ext;
			//Set the path to the file
			filePath = __dirname + '/uploads/' + filename;
			
			//Create a writestream to the path where file will be saved
			var writeable = fs.createWriteStream(filePath);
			//Pipe the file to the stream
			req.pipe(writeable);
			//Listen for end of pipe, send success with fileid
			req.on('end', function(){
				res.send(201, {'_id':id});
			});
			//Listen for stream error, send error response
			writeable.on('error', function(err) {
				res.send(500, err);
			});
		}
	});
};

//Exports the CollectionDriver so it can be used by main server code		
exports.FileDriver = FileDriver;
