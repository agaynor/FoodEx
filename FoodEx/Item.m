//
//  Item.m
//  FoodEx
//
//  Created by Adam Gaynor on 2/28/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "Item.h"

#define safeSet(d,k,v) if (v) d[k]=v;

@implementation Item


#pragma mark - JSON
-(instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self)
    {
        _name = dictionary[@"name"];
        _comment = dictionary[@"comment"];
        _quantity = dictionary[@"quantity"];
        _unit_price = dictionary[@"unit_price"];
    }
    return self;
}

-(NSDictionary*) toDictionary {
    
    NSMutableDictionary *jsonable = [NSMutableDictionary dictionary];
    safeSet(jsonable, @"name", self.name);
    safeSet(jsonable, @"comment", self.comment);
    safeSet(jsonable, @"quantity", self.quantity);
    safeSet(jsonable, @"unit_price", self.unit_price);
    
    return jsonable;
}



@end
