//
//  OpenWeatherAPIManager.h
//  Weathr
//
//  Created by Paul Williamson on 18/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

// Callbacks
@protocol OpenWeatherAPIManagerDelegate <NSObject>
@required
- (void)dataTaskSuccessWithData:(NSData *)data;
- (void)dataTaskFailWithHTTPURLResponse:(NSHTTPURLResponse *)response;
@end

@interface OpenWeatherAPIManager : NSObject {
    @protected
    NSURL *fetchingURL;
}

@property (nonatomic, weak) id <OpenWeatherAPIManagerDelegate> delegate;
@property (nonatomic, strong) NSURLSession *session;

- (void)updateURLWithLocation:(CLLocation *)location;
- (void)fetchWeatherData;

@end
