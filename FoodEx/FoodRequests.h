//
//  FoodRequests.h
//  FoodEx
//
//  Created by Adam Gaynor on 2/28/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FoodRequest.h"
@interface FoodRequests : NSObject

@property (nonatomic, strong) NSMutableArray* requests;


-(void) import:(void (^)(BOOL completion))completionBlock;
-(void) persist:(FoodRequest *)foodRequest withDeliveryAcceptTo:(FoodRequests *)myDeliveries andCompletion:(void (^)(BOOL completion))completionBlock;
-(void) persist:(FoodRequest *)foodRequest andCompletion:(void (^)(BOOL completion))completionBlock;
-(void) addRequest:(FoodRequest *)request;
-(void) runQuery:(NSString *)queryString andCompletion:(void (^)(BOOL completion))completionBlock;
-(void) queryUndeliveredRequestsWithTime:(NSDate *)date andCompletion:(void (^)(BOOL completion))completionBlock;

-(void) importMyOrders:(BOOL)future andCompletion: (void (^)(BOOL completion))completionBlock;
-(void) importMyDeliveries:(BOOL)future andCompletion: (void (^)(BOOL completion))completionBlock;
- (void)parseAndAddLocations:(NSArray*)requests toArray:(NSMutableArray*)destinationArray;
-(void)deleteRequest:(FoodRequest *)foodRequest andCompletion: (void (^)(BOOL completion))completionBlock;

//Implement later with location services
//-(void) queryRegion:(MKCoordinateRegion)region;


@end
