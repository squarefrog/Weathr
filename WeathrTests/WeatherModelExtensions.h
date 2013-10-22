//
//  WeatherModelExtensions.h
//  Weathr
//
//  Created by Paul Williamson on 20/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import "WeatherModel.h"

@interface WeatherModelExtensions : WeatherModel

+ (NSData *)loadJSONFromFile;
+ (NSDictionary *)loadPlistFromFile;

@end
