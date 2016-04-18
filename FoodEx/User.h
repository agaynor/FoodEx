//
//  User.h
//  FoodEx
//
//  Created by Adam Gaynor on 2/28/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, copy) NSString *email;


@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString* imageId;



- (instancetype) initWithDictionary:(NSDictionary*)dictionary;
- (NSDictionary*) toDictionary;

@end
