//
//  FoodRequest.m
//  FoodEx
//
//  Created by Adam Gaynor on 2/28/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "FoodRequest.h"

#define safeSet(d,k,v) if (v) d[k]=v;

@interface FoodRequest()

//Commented out for location services
//@property(nonatomic, retain) id location;

@end

@implementation FoodRequest


- (instancetype) init
{
    self = [super init];
    if (self) {
    }
    return self;
}

//Commented out until we have location services up and running
/*
#pragma mark - MKAnnotation
- (NSString *)title
{
    return self.name;
}

- (NSString *)subtitle
{
    return (self.details != nil && self.details.length > 0) ? self.details : self.placeName;
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationDegrees lat = [self.location[@"coordinates"][1] doubleValue];
    CLLocationDegrees lon = [self.location[@"coordinates"][0] doubleValue];
    CLLocationCoordinate2D c = CLLocationCoordinate2DMake(lat, lon);
    return c;
}
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    [self setLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
}
 
 #pragma mark - GeoJSON
 
 - (void) setLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude;
 {
    //make a geoJSON object e.g. { "type": "Point", "coordinates": [100.0, 0.0] }
    _location = @{@"type":@"Point", @"coordinates" : @[@(longitude), @(latitude)] };
 }
 
 - (void) setGeoJSON:(id)geoPoint
 {
    _location = geoPoint;
 }
 
*/


#pragma mark - JSON
-(instancetype) initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if(self)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
        
        __id = dictionary[@"_id"];
        _created_at = [dateFormat dateFromString:dictionary[@"created_at"]];
        _pickup_at = [dateFormat dateFromString:dictionary[@"pickup_at"]];
        _pickup_location = dictionary[@"pickup_location"];
        _buyer_id = dictionary[@"buyer_id"];
        _deliverer_id = dictionary[@"deliverer_id"];
        _buyer_name = dictionary[@"buyer_name"];
        _deliverer_name = dictionary[@"deliverer_name"];
        _order = [[Order alloc] initWithDictionary:dictionary[@"order"]];
        _pickup_point = CLLocationCoordinate2DMake([dictionary[@"pickup_point"][@"coordinates"][1] floatValue], [dictionary[@"pickup_point"][@"coordinates"][0] floatValue]);
        
    }
    return self;
}

-(NSDictionary*) toDictionary {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"];
    
    NSMutableDictionary *jsonable = [NSMutableDictionary dictionary];
    safeSet(jsonable, @"_id", self._id);
    safeSet(jsonable, @"created_at", [dateFormat stringFromDate:self.created_at]);
    safeSet(jsonable, @"pickup_at", [dateFormat stringFromDate:self.pickup_at]);
    safeSet(jsonable, @"pickup_location", self.pickup_location);
    safeSet(jsonable, @"buyer_id", self.buyer_id);
    safeSet(jsonable, @"deliverer_id", self.deliverer_id);
    safeSet(jsonable, @"buyer_name", self.buyer_name);
    safeSet(jsonable, @"deliverer_name", self.deliverer_name);
    safeSet(jsonable, @"order", [self.order toDictionary]);
    NSDictionary *loc = @{@"type":@"Point", @"coordinates" : @[@(self.pickup_point.longitude), @(self.pickup_point.latitude)] };
    
    safeSet(jsonable, @"pickup_point", loc);
    return jsonable;
}

@end
