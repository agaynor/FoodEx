//
//  DiningLocation.m
//  FoodEx
//
//  Created by Adam Gaynor on 4/20/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "DiningLocation.h"
#import "MenuItem.h"

@implementation DiningLocation

- (instancetype) init
{
    self = [super init];
    if (self) {
        _menuItems = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void)addItem:(MenuItem *)item{
    [_menuItems addObject:item];
}


-(instancetype) initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self)
    {
        _locationName = dictionary[@"location"];
        _menuItems = [[NSMutableArray alloc] init];
        NSArray *itemArray = dictionary[@"items"];
        for(NSMutableDictionary *item in itemArray)
        {
            [self addItem:[[MenuItem alloc] initWithDictionary:item]];
        }
    }
    return self;
}
@end
