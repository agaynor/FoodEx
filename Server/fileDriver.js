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


FileDriver.prototype.save = function(obj, callback) {
	this.getCollection(function(error, the_collection) {
		if(error) callback(error);
		else{
			obj.created_at = new Date();	
			the_collection.insert(obj, function(){
				callback(null, obj);
			});
		}
	});
};

FileDriver.prototype.getNewFileId = function(newobj, callback) {
	this.save(newobj, function(err, obj){
		if(err) { callback(err); }
		else { callback(null, obj._id); }
	});
};

FileDriver.prototype.handleUploadRequest = function(req, res) {
	var ctype = req.get('content-type');
	var ext = ctype.substr(ctype.indexOf('/')+1);
	if(ext) {ext = '.' + ext;} else{ext = '';}
	this.getNewFileId({'content-type':ctype, 'ext':ext}, function(err,id){
		if(err){res.send(400,err);}
		else{
			var filename = id+ext;
			filePath = __dirname + '/uploads/' + filename;
			
			var writeable = fs.createWriteStream(filePath);
			req.pipe(writeable);
			req.on('end', function(){
				res.send(201, {'_id':id});
			});
			writeable.on('error', function(err) {
				res.send(500, err);
			});
		}
	});
};

exports.FileDriver = FileDriver;
