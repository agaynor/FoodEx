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
-(void) persist:(FoodRequest *)request;
-(void) addRequest:(FoodRequest *)request;
-(void) runQuery:(NSString *)queryString;

- (void)parseAndAddLocations:(NSArray*)requests toArray:(NSMutableArray*)destinationArray;

//Implement later with location services
//-(void) queryRegion:(MKCoordinateRegion)region;


@end
