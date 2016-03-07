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


-(void) import;
-(void) persist:(FoodRequest *)foodRequest andIsDeliveryAccept:(BOOL)deliveryAccept;
-(void) addRequest:(FoodRequest *)request;
-(void) runQuery:(NSString *)queryString;
-(void) queryUndeliveredRequests;
-(void) importMyOrders;
-(void) importMyDeliveries;
- (void)parseAndAddLocations:(NSArray*)requests toArray:(NSMutableArray*)destinationArray;
-(void)deleteRequest:(FoodRequest *)foodRequest;

//Implement later with location services
//-(void) queryRegion:(MKCoordinateRegion)region;


@end
