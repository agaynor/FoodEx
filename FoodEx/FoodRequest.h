//
//  FoodRequest.h
//  FoodEx
//
//  Created by Adam Gaynor on 2/28/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "Order.h"

//Commented out code to make location services work
@interface FoodRequest : NSObject //<MKAnnotation>

@property(nonatomic, copy) NSString *_id;
@property(nonatomic, copy) NSDate *created_at;
@property(nonatomic, copy) NSDate *pickup_at;
@property(nonatomic, copy) NSString *pickup_location;
@property(nonatomic, copy) NSString *buyer_id;
@property(nonatomic, copy) NSString *deliverer_id;
@property(nonatomic, copy) NSString *buyer_name;
@property(nonatomic, copy) NSString *deliverer_name;
@property(nonatomic) CLLocationCoordinate2D pickup_point;
@property(nonatomic) NSString *image_id;
@property(nonatomic, retain) Order *order;

#pragma mark - JSON conversion

-(instancetype) initWithDictionary:(NSDictionary *)dictionary;
-(NSDictionary *)toDictionary;



//Location stuff commented out for later
/*
#pragma mark - Location

- (void) setLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;
- (void) setGeoJSON:(id)geoPoint;
- (void) setCoordinate:(CLLocationCoordinate2D)newCoordinate;
*/


@end
