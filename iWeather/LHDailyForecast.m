//
//  LHDailyForecast.m
//  iWeather
//
//  Created by Trieu on 13/7/15.
//  Copyright (c) 2015 Trieu. All rights reserved.
//

#import "LHDailyForecast.h"

@implementation LHDailyForecast
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *paths = [[super JSONKeyPathsByPropertyKey] mutableCopy];
    paths[@"tempHigh"] = @"temp.max";
    paths[@"tempLow"] = @"temp.min";
    return paths;
}
@end
