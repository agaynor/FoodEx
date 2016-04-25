//
//  Item.h
//  FoodEx
//
//  Created by Adam Gaynor on 2/28/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuItem.h"
@interface Item : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *comment;
@property(nonatomic, copy) NSNumber *quantity;
@property(nonatomic, copy) NSNumber *unit_price;
@property(nonatomic, strong) MenuItem *menuItem;

#pragma mark - JSON conversion

-(instancetype) initWithDictionary:(NSDictionary *)dictionary;
-(NSDictionary *)toDictionary;


@end
