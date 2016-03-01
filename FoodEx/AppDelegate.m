//
//  AppDelegate.m
//  FoodEx
//
//  Created by Adam Gaynor on 2/28/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "AppDelegate.h"
#import "FoodRequest.h"
#import "FoodRequests.h"
#import "Order.h"
#import "Item.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    FoodRequest *request = [[FoodRequest alloc] init];
    [request setCreated_at:[NSDate date]];
    [request setPickup_at:[NSDate date]];
    [request setPickup_location:@"Olin Library"];
    [request setBuyer_id:@"Adam"];
   // [request setDeliverer_id:@"Julie"];
    
    Order *order = [[Order alloc] init];
    [order setDining_location:@"Starbucks"];
    
    Item *item = [[Item alloc] init];
    [item setName:@"Vanilla Latte"];
    [item setComment:@"HOT"];
    [item setQuantity:@1];
    [item setUnit_price:[NSNumber numberWithFloat:3.5f]];
    
    Item *item2 = [[Item alloc] init];
    [item2 setName:@"Banana Bread"];
    [item2 setComment:@"None"];
    [item2 setQuantity:@1];
    [item2 setUnit_price:[NSNumber numberWithFloat:2.99f]];
    
    [order addItem:item];
    [order addItem:item2];
    
    [request setOrder:order];
   
    
    FoodRequests *requests = [[FoodRequests alloc] init];
    [requests queryUndeliveredRequests];
    
  
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
