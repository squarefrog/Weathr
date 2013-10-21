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

- (id)init
{
    self = [super init];
    if (self) {
        self.session = [NSURLSession sharedSession];
    }
    return self;
}

#pragma mark - URL creation
- (void)updateURLWithLocation:(CLLocation *)location;
{
    if (location) {
        NSString *newUrl = [NSString stringWithFormat:@"%@lat=%g&lon=%g", OpenWeatherMapAPIUrl, location.coordinate.latitude, location.coordinate.longitude];
        fetchingURL = [NSURL URLWithString:newUrl];
    }
}

#pragma mark - Data transfer
- (void)fetchWeatherData
{
    NSURLRequest *request = [NSURLRequest requestWithURL:fetchingURL];
    [[self createTaskWithURLRequest:request] resume];
}

- (NSURLSessionTask *)createTaskWithURLRequest:(NSURLRequest *)request
{
    if (request) {
        __weak OpenWeatherAPIManager *weakself = self;
        NSURLSessionTask *task = [_session dataTaskWithRequest:request
                                             completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                 NSHTTPURLResponse *r = (NSHTTPURLResponse*)response;
                                                 dispatch_async(dispatch_get_main_queue(), ^{
                                                     if (r.statusCode == 200)
                                                         [weakself tellDelegateDataTaskSucceededWithData:data];
                                                     else
                                                         [weakself tellDelegateDataTaskFailedWithHTTPURLResponse:r];
                                                 });
                                             }];
        return task;
    }
    return nil;
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
