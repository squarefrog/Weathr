//
//  OpenWeatherAPIManager.m
//  Weathr
//
//  Created by Paul Williamson on 18/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import "OpenWeatherAPIManager.h"

NSString * const OpenWeatherMapAPIUrl = @"http://api.openweathermap.org/data/2.5/weather?";
NSString * const OpenWeatherAPIManagerTaskFinishedWithSuccess = @"OpenWeatherAPIManagerTaskFinishedWithSuccess";
NSString * const OpenWeatherAPIManagerTaskFinishedWithFailure = @"OpenWeatherAPIManagerTaskFinishedWithFailure";

@interface OpenWeatherAPIManager ()
@end

@implementation OpenWeatherAPIManager

- (id)initWithLocation:(CLLocation *)location
{
    self = [super init];
    if (self) {
        [self updateURLWithLocation:location];
    }
    return self;
}

- (void)updateURLWithLocation:(CLLocation *)location;
{
    NSString *newUrl = [NSString stringWithFormat:@"%@lat=%f&lon=%f", OpenWeatherMapAPIUrl, location.coordinate.latitude, location.coordinate.longitude];
    fetchingURL = [NSURL URLWithString:newUrl];
}

- (void)postNotification:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] postNotification:notification];
}

- (void)postSuccessNotificationWithResponse:(NSURLResponse *)response
{
    NSNotification *notification = [NSNotification notificationWithName:OpenWeatherAPIManagerTaskFinishedWithSuccess
                                                                 object:response];
    [self postNotification:notification];
}

- (void)postFailureNotificationWithResponse:(NSURLResponse *)response
{
    NSNotification *notification = [NSNotification notificationWithName:OpenWeatherAPIManagerTaskFinishedWithFailure
                                                                 object:response];
    [self postNotification:notification];
}

@end
