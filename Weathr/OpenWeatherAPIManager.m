//
//  OpenWeatherAPIManager.m
//  Weathr
//
//  Created by Paul Williamson on 18/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import "OpenWeatherAPIManager.h"

NSString * const OpenWeatherMapAPIUrl = @"http://api.openweathermap.org/data/2.5/weather?";

@interface OpenWeatherAPIManager ()
@end

@implementation OpenWeatherAPIManager

- (void)updateURLWithLocation:(CLLocation *)location;
{
    NSString *newUrl = [NSString stringWithFormat:@"%@lat=%f&lon=%f", OpenWeatherMapAPIUrl, location.coordinate.latitude, location.coordinate.longitude];
    fetchingURL = [NSURL URLWithString:newUrl];
}

@end
