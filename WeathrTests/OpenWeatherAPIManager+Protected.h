//
//  OpenWeatherAPIManager+Protected.h
//  Weathr
//
//  Created by Paul Williamson on 19/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import "OpenWeatherAPIManager.h"

@interface OpenWeatherAPIManager (Protected)

+ (NSURL *)createAPIURLWithLocation:(CLLocation *)location;

@end
