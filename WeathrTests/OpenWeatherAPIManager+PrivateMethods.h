//
//  OpenWeatherAPIManager+PrivateMethods.h
//  Weathr
//
//  Created by Paul Williamson on 22/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import "OpenWeatherAPIManager.h"

@interface OpenWeatherAPIManager (PrivateMethods)

- (void)tellDelegateDataTaskSucceededWithData:(NSData *)data;
- (void)tellDelegateDataTaskFailedWithHTTPURLResponse:(NSHTTPURLResponse *)response;
- (NSURLSessionTask *)createTaskWithURLRequest:(NSURLRequest *)request;

@end
