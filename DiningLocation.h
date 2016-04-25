//
//  DiningLocation.h
//  FoodEx
//
//  Created by Adam Gaynor on 4/20/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiningLocation : NSObject

@property(nonatomic, copy) NSString *locationName;
@property(nonatomic, copy) NSMutableArray *menuItems;

-(instancetype) initWithDictionary:(NSDictionary *)dictionary;

@end
