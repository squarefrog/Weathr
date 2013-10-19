//
//  OpenWeatherAPIManager.m
//  Weathr
//
//  Created by Paul Williamson on 18/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import "OpenWeatherAPIManager.h"

NSString * const OpenWeatherMapAPIUrl = @"http://api.openweathermap.org/data/2.5/weather?";

@implementation OpenWeatherAPIManager

+ (NSURL *)createAPIURLWithLocation:(CLLocation *)location;
{
    NSString *newUrl = [NSString stringWithFormat:@"%@lat=%f&lon=%f", OpenWeatherMapAPIUrl, location.coordinate.latitude, location.coordinate.longitude];
    return [NSURL URLWithString:newUrl];
}

@end
