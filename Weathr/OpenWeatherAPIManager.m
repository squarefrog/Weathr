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

#pragma mark - Data transfer
// I'm not entirely sure the best way to test this at the moment.
// I think it could possibly be tested using a mock NSURLSession
// and NSURLSessionTask
// TODO: Create mock object to test this
- (void)fetchWeatherData
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *request = [NSURLRequest requestWithURL:fetchingURL];
    __weak OpenWeatherAPIManager *weakself = self;
    NSURLSessionTask *task = [session dataTaskWithRequest:request
                                        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                            NSHTTPURLResponse *r = (NSHTTPURLResponse*)response;
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                if (r.statusCode == 200)
                                                    [weakself tellDelegateDataTaskSucceededWithData:data];
                                                else
                                                    [weakself tellDelegateDataTaskFailedWithHTTPURLResponse:r];
                                            });
                                        }];
    [task resume];
}

#pragma mark - Delegation
- (void)tellDelegateDataTaskSucceededWithData:(NSData *)data
{
    [self.delegate dataTaskSuccessWithData:data];
}
- (void)tellDelegateDataTaskFailedWithHTTPURLResponse:(NSHTTPURLResponse *)response
{
    [self.delegate dataTaskFailWithHTTPURLResponse:response];
}

@end
