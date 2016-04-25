//
//  Order.h
//  FoodEx
//
//  Created by Adam Gaynor on 2/28/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Item.h"

@interface Order : NSObject

@property(nonatomic, copy) NSString *dining_location;
@property(nonatomic, copy) NSMutableArray *items;
@property(nonatomic, copy) NSNumber *price_total;
@property(nonatomic, copy) NSMutableArray *otherLocations;

-(void)addItem:(Item *)item;
-(NSDictionary *)toDictionary;
-(instancetype) initWithDictionary:(NSDictionary *)dictionary;
@end
