//
//  THClient.m
//  iWeather
//
//  Created by Trieu on 13/7/15.
//  Copyright (c) 2015 Trieu. All rights reserved.
//

#import "THClient.h"
#import "LHCondition.h"
#import "LHDailyForecast.h"

@interface THClient ()
@property (nonatomic, strong) NSURLSession *session;
@end

@implementation THClient
- (id)init {
    if (self = [super init]) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    
    return self;
}

- (RACSignal *)fetchJSONFromURL:(NSURL *)url {
    NSLog(@"Fetching: %@", url.absoluteString);
    
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (!error) {
                NSError *jsonError = nil;
                id json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
                if (!jsonError) {
                    [subscriber sendNext:json];
                } else {
                    [subscriber sendError:error];
                }
            } else {
                [subscriber sendError:error];
            }
        }];
        
        [dataTask resume];
        
        return [RACDisposable disposableWithBlock:^{
            [dataTask cancel];
        }];
    }] doError:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (RACSignal *)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate {
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=imperial", coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return [[self fetchJSONFromURL:url] map:^id(NSDictionary *json) {
        return [MTLJSONAdapter modelOfClass:[LHCondition class] fromJSONDictionary:json error:nil];
    }];
}

- (RACSignal *)fetchHourlyForecastForLocation:(CLLocationCoordinate2D)coordinate {
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast?lat=%f&lon=%f&units=imperial&cnt=12", coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return [[self fetchJSONFromURL:url] map:^id(NSDictionary *json) {
        RACSequence *list = [json[@"list"] rac_sequence];
        return [[list map:^id(NSDictionary *item) {
            return [MTLJSONAdapter modelOfClass:[LHCondition class] fromJSONDictionary:item error:nil];
        }] array];
    }];
}

- (RACSignal *)fetchDailyForecastForLocation:(CLLocationCoordinate2D)coordinate {
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/forecast/daily?lat=%f&lon=%f&units=imperial&cnt=7", coordinate.latitude, coordinate.longitude];
    NSURL *url = [NSURL URLWithString:urlString];
    
    return [[self fetchJSONFromURL:url] map:^id(NSDictionary *json) {
        RACSequence *list = [json[@"list"] rac_sequence];
        return [[list map:^id(id item) {
            return [MTLJSONAdapter modelOfClass:[LHDailyForecast class] fromJSONDictionary:item error:nil];
        }] array];
    }];
}

@end
