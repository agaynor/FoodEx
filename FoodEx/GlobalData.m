//
//  GlobalData.m
//  FoodEx
//
//  Created by Adam Gaynor on 3/3/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "GlobalData.h"

@implementation GlobalData


+(id)sharedInstance
{
    static GlobalData *sharedData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedData = [[self alloc] init];
    });
    return sharedData;
}

-(id) init {
    if((self) = [super init])
    {
        self.currentFoodRequest = [[FoodRequest alloc] init];
        self.myOrders = [[FoodRequests alloc] init];
        self.myDeliveries = [[FoodRequests alloc] init];
        self.unclaimedDeliveries = [[FoodRequests alloc] init];
        self.myUser = [[User alloc] init];
    }
    return self;
}


@end
