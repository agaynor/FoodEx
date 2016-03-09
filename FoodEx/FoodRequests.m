//
//  FoodRequests.m
//  FoodEx
//
//  Created by Adam Gaynor on 2/28/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "FoodRequests.h"


static NSString* const kBaseURL = @"http://ec2-54-92-150-113.compute-1.amazonaws.com:8000/";
static NSString* const kRequests = @"requests";
static NSString* const kMyOrders = @"myOrders";
static NSString* const kMyDeliveries = @"myDeliveries";
static NSString* const kDeliveryAccept = @"deliveryAccept";

@implementation FoodRequests

- (id)init
{
    self = [super init];
    if (self) {
        _requests = [NSMutableArray array];
    }
    return self;
}


- (void)parseAndAddLocations:(NSArray*)requests toArray:(NSMutableArray*)destinationArray
{
    for(NSDictionary *item in requests){
        FoodRequest *request = [[FoodRequest alloc] initWithDictionary:item];
        [destinationArray addObject:request];
    }
    
}

- (void)parseAndRemoveLocations:(FoodRequest *)removeRequest fromArray:(NSMutableArray*)destinationArray
{
    FoodRequest *requestToRemove = nil;
    for(FoodRequest *request in destinationArray)
    {
        if([request._id isEqualToString:removeRequest._id])
        {
            requestToRemove = request;
        }
    }
    
    if(requestToRemove)
    {
        [destinationArray removeObject:requestToRemove];
    }
}

-(void) addRequest:(FoodRequest *)request{
    [self.requests addObject:request];
}



-(void) importToTableView:(UITableView *)myTable {
    
    NSURL *url = [NSURL URLWithString:[kBaseURL stringByAppendingPathComponent:kRequests]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { //5
        if (error == nil) {
            NSArray* responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]; //6
            [self parseAndAddLocations:responseArray toArray:self.requests]; //7
            [myTable reloadData];
        }
    }];
    
    [dataTask resume];
    
}

-(void) importMyOrdersToTableView:(UITableView *)myTable {
    
    NSURL *url = [NSURL URLWithString:[[kBaseURL stringByAppendingPathComponent:kRequests] stringByAppendingPathComponent:kMyOrders]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { //5
        if (error == nil) {
            NSArray* responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]; //6
            [self.requests removeAllObjects];
            [self parseAndAddLocations:responseArray toArray:self.requests]; //7
            [myTable reloadData];
        }
    }];
    
    [dataTask resume];
    
}

-(void) importMyDeliveriesToTableView:(UITableView *)myTable {
    
    NSURL *url = [NSURL URLWithString:[[kBaseURL stringByAppendingPathComponent:kRequests] stringByAppendingPathComponent:kMyDeliveries]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { //5
        if (error == nil) {
            NSArray* responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]; //6
            [self.requests removeAllObjects];
            [self parseAndAddLocations:responseArray toArray:self.requests]; //7
            [myTable reloadData];
        }
    }];
    
    [dataTask resume];
    
}




-(void)deleteRequest:(FoodRequest *)foodRequest
{
    NSURL *url = [NSURL URLWithString:[[[kBaseURL stringByAppendingPathComponent:kRequests] stringByAppendingPathComponent:foodRequest._id] stringByAppendingPathComponent:foodRequest.buyer_id]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"DELETE";
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { //5
        if (error == nil) {
            NSArray* responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]; //6
            if([responseArray count] > 0){
                FoodRequest *requestToRemove = [[FoodRequest alloc] initWithDictionary:[responseArray objectAtIndex:0]];
                [self parseAndRemoveLocations:requestToRemove fromArray:self.requests]; //7
            }
            
        }
    }];
    
    [dataTask resume];
    
}

-(void) persist:(FoodRequest *)foodRequest {
    if(!foodRequest || foodRequest == nil){
        return;
    }
    
    
    NSString *requestString = [kBaseURL stringByAppendingPathComponent:kRequests];
    
    
    BOOL isExistingLocation = foodRequest._id != nil;
    
    requestString = isExistingLocation ? [requestString stringByAppendingPathComponent:foodRequest._id] : requestString;
    
    
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = isExistingLocation ? @"PUT" : @"POST";
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:[foodRequest toDictionary] options:0 error:NULL];
    
    request.HTTPBody = data;
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSArray* responseArray = @[[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]];
            [self parseAndAddLocations:responseArray toArray:self.requests];
        }
    }];
    [dataTask resume];
}


-(void) persist:(FoodRequest *)foodRequest withDeliveryAcceptTo:(FoodRequests *)myDeliveries{
    if(!foodRequest || foodRequest == nil){
        return;
    }
    
    
    NSString *requestString = [[[kBaseURL stringByAppendingPathComponent:kRequests] stringByAppendingPathComponent:foodRequest._id] stringByAppendingPathComponent:kDeliveryAccept];
    
    
  
    
    NSURL *url = [NSURL URLWithString:requestString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"PUT";
    
    NSData* data = [NSJSONSerialization dataWithJSONObject:[foodRequest toDictionary] options:0 error:NULL];
    
    request.HTTPBody = data;
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {
            NSArray* responseArray = @[[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]];
            
                FoodRequest *request = [[FoodRequest alloc] initWithDictionary:[responseArray objectAtIndex:0]];
                [self parseAndRemoveLocations:request fromArray:self.requests];
                [myDeliveries addRequest:request];
        }
    }];
    [dataTask resume];
}





-(void) runQuery:(NSString *)queryString toTableView:(UITableView *) myTable{
    NSString *urlStr = [[kBaseURL stringByAppendingPathComponent:kRequests] stringByAppendingString:queryString];
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error == nil) {
            [self.requests removeAllObjects];
            NSArray* responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            NSLog(@"received %lu items", (unsigned long)responseArray.count);
            [self parseAndAddLocations:responseArray toArray:self.requests];
            [myTable reloadData];
        }
    }];
    
    [dataTask resume];
}



-(void) queryUndeliveredRequestsToTableView:(UITableView *)myTable {
    NSString *queryParam = [NSString stringWithFormat:@"{\"$exists\":false}"];
    NSString *doesntExist = [NSString stringWithFormat:@"{\"deliverer_id\":%@}", queryParam];
    NSString* escQuery = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                             (CFStringRef) doesntExist,
                                                                                             NULL,
                                                                                             (CFStringRef) @"!*();':@&=+$,/?%#[]{}",
                                                                                             kCFStringEncodingUTF8));
    NSString *query = [NSString stringWithFormat:@"?query=%@", escQuery];
    [self runQuery:query toTableView: myTable];

}


/*
- (void) queryRegion:(MKCoordinateRegion)region
{
    CLLocationDegrees x0 = region.center.longitude - region.span.longitudeDelta;
    CLLocationDegrees x1 = region.center.longitude + region.span.longitudeDelta;
    CLLocationDegrees y0 = region.center.latitude - region.span.latitudeDelta;
    CLLocationDegrees y1 = region.center.latitude + region.span.latitudeDelta;
    
    //query format {"$geoWithin":{"$box": [[x1,y1], [x2,y2]]}}
    //specifying bounds for search
    NSString* boxQuery = [NSString stringWithFormat:@"{\"$geoWithin\":{\"$box\":[[%f,%f],[%f,%f]]}}",x0,y0,x1,y1];
    //specify field to search on
    NSString *locationInBox = [NSString stringWithFormat:@"{\"location\":%@}", boxQuery];
    //Escaping string for url encoding
    NSString* escBox = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                             (CFStringRef) locationInBox,
                                                                                             NULL,
                                                                                             (CFStringRef) @"!*();':@&=+$,/?%#[]{}",
                                                                                             kCFStringEncodingUTF8));
    NSString *query = [NSString stringWithFormat:@"?query=%@", escBox];
    [self runQuery:query];
}
 */

@end
