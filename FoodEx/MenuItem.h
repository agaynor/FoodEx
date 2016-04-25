//
//  MenuItem.h
//  FoodEx
//
//  Created by Adam Gaynor on 4/20/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSNumber *price;
@property(nonatomic, copy) NSArray *otherLocations;

-(instancetype) initWithDictionary:(NSDictionary *)dictionary;

@end
