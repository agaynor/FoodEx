//
//  User.m
//  FoodEx
//
//  Created by Adam Gaynor on 2/28/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "User.h"


#define safeSet(d,k,v) if (v) d[k] = v;

@implementation User

- (instancetype) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if (self) {
        self.username = dictionary[@"username"];
        self.firstName = dictionary[@"first_name"];
        self.lastName = dictionary[@"last_name"];
        self.email = dictionary[@"email"];
        self.imageId = dictionary[@"imageId"];
    }
    return self;
}

- (NSDictionary*) toDictionary
{
    NSMutableDictionary* jsonable = [NSMutableDictionary dictionary];
    safeSet(jsonable, @"username", self.username);
    safeSet(jsonable, @"first_name", self.firstName);
    safeSet(jsonable, @"last_name", self.lastName);
    safeSet(jsonable, @"email", self.email);
    safeSet(jsonable, @"imageId", self.imageId);
    return jsonable;
}


@end
