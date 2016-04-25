//
//  MenuItem.m
//  FoodEx
//
//  Created by Adam Gaynor on 4/20/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

- (instancetype) init
{
    self = [super init];
    if (self) {
        _otherLocations = [[NSArray alloc] init];
    }
    return self;
}




-(instancetype) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self)
    {
        _name = dictionary[@"name"];
        _price = dictionary[@"price"];
        _otherLocations = dictionary[@"otherLocations"];
    }
    return self;
}
@end
