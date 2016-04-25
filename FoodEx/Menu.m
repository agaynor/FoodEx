//
//  Menu.m
//  FoodEx
//
//  Created by Adam Gaynor on 4/20/16.
//  Copyright © 2016 FoodEx. All rights reserved.
//

#import "Menu.h"
#import "DiningLocation.h"


static NSString* const kBaseURL = @"http://ec2-54-92-150-113.compute-1.amazonaws.com:8000/";
static NSString* const kMenu = @"menus";

@implementation Menu

- (instancetype) init
{
    self = [super init];
    if (self) {
        _menu = [[NSMutableArray alloc] init];
    }
    return self;
}


-(void)addItem:(DiningLocation *)item{
    [_menu addObject:item];
}

-(void)parseAndAddMenu:(NSArray *)fromArray toArray:(NSMutableArray *)requestArray{
    for(NSDictionary *diningLocation in fromArray){
        DiningLocation *loc = [[DiningLocation alloc] initWithDictionary:diningLocation];
        NSLog(@"%@", loc.locationName);
        [requestArray addObject:loc];
    }
}

-(void)loadMenu{
    NSURL *url = [NSURL URLWithString:[kBaseURL stringByAppendingPathComponent:kMenu]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    
    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) { //5
        if (error == nil) {
            
            NSArray* responseArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]; //6
            [self parseAndAddMenu:responseArray toArray:self.menu]; //7

        }
    }];
    
    [dataTask resume];
}


@end
