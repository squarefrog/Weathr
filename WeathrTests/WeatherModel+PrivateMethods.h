//
//  WeatherModel+PrivateMethods.h
//  Weathr
//
//  Created by Paul Williamson on 22/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import "WeatherModel.h"

@interface WeatherModel (PrivateMethods)

+ (id)parseJSONData:(NSData *)data;
- (void)updateWeatherModelFromDictionary:(NSDictionary *)dict;
- (void)updateWeatherDescriptionFromDictionary:(NSDictionary *)dict;
- (void)updateTemperatureFromDictionary:(NSDictionary *)dict;
- (void)updateIconFromDictionary:(NSDictionary *)dict;
- (void)updateLocationNameFromDictionary:(NSDictionary *)dict;
- (void)updateLastUpdatedDateFromDictionary:(NSDictionary *)dict;
- (void)updateLocationFromDictionary:(NSDictionary *)dict;

- (NSNumber *)getTemperatureInFahrenheit;

@end
