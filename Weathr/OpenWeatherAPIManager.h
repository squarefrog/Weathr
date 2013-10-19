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

@interface OpenWeatherAPIManager : NSObject {
    @protected
    NSURL *fetchingURL;
    NSURLSession *session;
}

- (id)initWithLocation:(CLLocation *)location;
- (void)updateURLWithLocation:(CLLocation *)location;

@end

@interface OpenWeatherAPIManager (private) 

- (void)createSession;

@end
