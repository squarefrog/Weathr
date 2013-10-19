//
//  OpenWeatherAPIManager.h
//  Weathr
//
//  Created by Paul Williamson on 18/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

extern NSString * const OpenWeatherMapAPIUrl;
extern NSString * const OpenWeatherAPIManagerTaskFinishedWithSuccess;
extern NSString * const OpenWeatherAPIManagerTaskFinishedWithFailure;

@interface OpenWeatherAPIManager : NSObject {
    @protected
    NSURL *fetchingURL;
}

- (id)initWithLocation:(CLLocation *)location;
- (void)updateURLWithLocation:(CLLocation *)location;
- (void)fetchWeatherData;

@end

@interface OpenWeatherAPIManager (private) 

- (void)postNotification:(NSNotification *)notification;
- (void)postSuccessNotificationWithResponse:(NSURLResponse *)response;
- (void)postFailureNotificationWithResponse:(NSURLResponse *)response;

@end
