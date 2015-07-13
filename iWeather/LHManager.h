//
//  LHManager.h
//  iWeather
//
//  Created by Trieu on 13/7/15.
//  Copyright (c) 2015 Trieu. All rights reserved.
//

@import Foundation;
@import CoreLocation;
#import <ReactiveCocoa.h>
#import "LHCondition.h"

@interface LHManager : NSObject <CLLocationManagerDelegate>

+ (instancetype)sharedManager;

@property (nonatomic, strong, readonly) CLLocation *currentLocation;
@property (nonatomic, strong, readonly) LHCondition *currentCondition;
@property (nonatomic, strong, readonly) NSArray *hourlyForecast;
@property (nonatomic, strong, readonly) NSArray *dailyForecast;

- (void)findCurrentLocation;

@end
