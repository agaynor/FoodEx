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


-(void) importToTableView:(UITableView *)myTable;
-(void) persist:(FoodRequest *)foodRequest withDeliveryAcceptTo:(FoodRequests *)myDeliveries;
-(void) persist:(FoodRequest *)foodRequest;
-(void) addRequest:(FoodRequest *)request;
-(void) runQuery:(NSString *)queryString toTableView:(UITableView *)myTable;
-(void) queryUndeliveredRequestsToTableView:(UITableView *)myTable;
-(void) importMyOrdersToTableView:(UITableView *)myTable;
-(void) importMyDeliveriesToTableView:(UITableView *)myTable;
- (void)parseAndAddLocations:(NSArray*)requests toArray:(NSMutableArray*)destinationArray;
-(void)deleteRequest:(FoodRequest *)foodRequest;

//Implement later with location services
//-(void) queryRegion:(MKCoordinateRegion)region;


@end
