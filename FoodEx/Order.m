//
//  Order.m
//  FoodEx
//
//  Created by Adam Gaynor on 2/28/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "Order.h"

#define safeSet(d,k,v) if (v) d[k]=v;

@implementation Order

- (instancetype) init
{
    self = [super init];
    if (self) {
        _items = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void)addItem:(Item *)item{
    [_items addObject:item];
}


-(instancetype) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self)
    {
        _dining_location = dictionary[@"dining_location"];
        _items = [[NSMutableArray alloc] init];
        NSMutableArray *itemArray = dictionary[@"items"];
        for(NSMutableDictionary *item in itemArray)
        {
            [self addItem:[[Item alloc] initWithDictionary:item]];
        }
        
        _price_total = dictionary[@"price_total"];
    }
    return self;
}

-(NSDictionary *)toDictionary {
    
    NSMutableDictionary *jsonable = [NSMutableDictionary dictionary];
    safeSet(jsonable, @"dining_location", self.dining_location);
    
    NSMutableArray *itemArray = [[NSMutableArray alloc] init];
    for(Item *item in _items)
    {
        [itemArray addObject:[item toDictionary]];
    }
    
    safeSet(jsonable, @"items", itemArray);
    safeSet(jsonable, @"price_total", _price_total);
    
    return jsonable;

}


@end
