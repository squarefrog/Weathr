//
//  InspectableOpenWeatherAPIManager.m
//  Weathr
//
//  Created by Paul Williamson on 19/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import "InspectableOpenWeatherAPIManager.h"

@implementation InspectableOpenWeatherAPIManager

- (NSURL *)URLToFetch
{
    return fetchingURL;
}

@end
