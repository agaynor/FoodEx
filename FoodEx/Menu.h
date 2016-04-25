//
//  Menu.h
//  FoodEx
//
//  Created by Adam Gaynor on 4/20/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Menu : NSObject

@property(nonatomic, copy) NSMutableArray *menu;

-(void)loadMenu;
@end
