var ObjectId = require('mongodb').ObjectID,
    bcrypt = require('bcrypt-nodejs'), 
    SALT_WORK_FACTOR = 10;

UserDriver = function(db) {
   this.db = db;
}

UserDriver.prototype.getCollection = function(collectionName, callback){
        this.db.collection(collectionName, function(error, the_collection){
                if(error) callback(error);
                else callback(null, the_collection);
        });
};

UserDriver.prototype.save = function(collectionName, user, callback) {
        this.getCollection(collectionName, function(error, the_collection) {
                if(error) callback(error);
                else{
			bcrypt.genSalt(SALT_WORK_FACTOR, function(err, salt){
				if(err) callback(err);
				else {
					bcrypt.hash(user.password, salt,null ,function(err, hash){
						if(err) callback(err);
						else{
							user.password = hash;
							the_collection.insert(user, function(){
								callback(null, user);
							});	
						}
					});
				}
			});

                }	
        });
};



UserDriver.prototype.loginUser = function(collectionName, user, callback) {
	this.getCollection(collectionName, function(error, the_collection) {
		if(error) callback(error);
		else{	
			the_collection.findOne({'username':user.username}, function(finderror, doc){
				if(error) callback(finderror);
				else if(!doc) callback("User Doesn't Exist", null);
				else {
					bcrypt.compare(user.password, doc.password, function(err, isMatch){
						if(err) callback(err);
						else if(isMatch) callback(null, doc);
						else callback("Incorrect Password!", null);	
					});
				}
			});
		}
	});
}

exports.UserDriver = UserDriver;
