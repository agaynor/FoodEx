var ObjectId = require('mongodb').ObjectID,
    bcrypt = require('bcrypt-nodejs'), 
    SALT_WORK_FACTOR = 10;

//Creates a new UserDriver to manage database user insertion and retrieval
UserDriver = function(db) {
   this.db = db;
}

//Function to verify existince and return collection from database
UserDriver.prototype.getCollection = function(collectionName, callback){
        this.db.collection(collectionName, function(error, the_collection){
        	//If there is an error retrieving the collection, return it with the callback, otherwise return the collection
                if(error) callback(error);
                else callback(null, the_collection);
        });
};

//Function to save a user to a given collection
UserDriver.prototype.save = function(collectionName, user, callback) {
		//get user collection
        this.getCollection(collectionName, function(error, the_collection) {
                if(error) callback(error);
                else{
           			//see if user already exists
                	the_collection.find({"user":user.username}).toArray(function(error, results) {
                         	if(error) callback(error);
                            else
                            {	
                            	//If user doesn't exist
                            	if(results.length == 0)
                            	{
                            		//generate salt
                            		bcrypt.genSalt(SALT_WORK_FACTOR, function(err, salt){
                            			if(err) callback(err);
                            			else{
                            				//hash password
                            				bcrypt.hash(user.password, salt, null, function(err, hash){
                            					if(err) callback(err);
                            					else{
                            						//set password to hash
                            						user.password = hash;
                            						//insert the user
                            						the_collection.insert(user, function(){
                            							callback(null, user);
                            						});
                            					}
                            				});
                            			}
                            		});
                            	}
                            	else{
                            		callback("Username Taken", null);
                            	}
                            	
                            }

                          });
                }
            });
}
               
//Function to authenticate user
UserDriver.prototype.loginUser = function(collectionName, user, callback) {
	this.getCollection(collectionName, function(error, the_collection) {
		if(error) callback(error);
		else{	
			//find user in database
			the_collection.findOne({'username':user.username}, function(finderror, doc){
				if(error) callback(finderror);
				//if user doesn't exist in database, return message
				else if(!doc) callback("User Doesn't Exist", null);
				else {
					//if user exists, use bcrypt to check pass against hashed password
					bcrypt.compare(user.password, doc.password, function(err, isMatch){
						if(err) callback(err);
						//if password matches, return no error and user doc
						else if(isMatch) callback(null, doc);
						//if password doesn't match, return message
						else callback("Incorrect Password!", null);	
					});
				}
			});
		}
	});
}

//Exports the UserDriver so it can be used by main server code	
exports.UserDriver = UserDriver;
