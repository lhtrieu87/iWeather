//
//  THClient.h
//  iWeather
//
//  Created by Trieu on 13/7/15.
//  Copyright (c) 2015 Trieu. All rights reserved.
//

@import Foundation;
@import CoreLocation;
#import <ReactiveCocoa.h>

@interface THClient : NSObject
- (RACSignal *)fetchJSONFromURL:(NSURL *)url;
- (RACSignal *)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate;
- (RACSignal *)fetchHourlyForecastForLocation:(CLLocationCoordinate2D)coordinate;
- (RACSignal *)fetchDailyForecastForLocation:(CLLocationCoordinate2D)coordinate;
@end
