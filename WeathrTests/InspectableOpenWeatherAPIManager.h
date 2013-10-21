//
//  InspectableOpenWeatherAPIManager.h
//  Weathr
//
//  Created by Paul Williamson on 19/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import "OpenWeatherAPIManager.h"

@interface InspectableOpenWeatherAPIManager : OpenWeatherAPIManager

- (NSURL *)URLToFetch;
- (void)setURLToFetch:(NSURL *)url;

@end
