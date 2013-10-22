//
//  WeatherModel.m
//  Weathr
//
//  Created by Paul Williamson on 17/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import "WeatherModel.h"
#import <CoreLocation/CoreLocation.h>

@implementation WeatherModel

#pragma mark - Property updates
- (void)updateWeatherModelFromNSData:(NSData *)data
{
    id json = [WeatherModel parseJSONData:data];
    if ([[json class] isSubclassOfClass:[NSMutableDictionary class]])
        [self updateWeatherModelFromDictionary:(NSDictionary *)json];
}

// This method is untested, but each call is tested individually
// so we're covered.
- (void)updateWeatherModelFromDictionary:(NSDictionary *)dict
{
    [self updateWeatherDescriptionFromDictionary:dict];
    [self updateTemperatureFromDictionary:dict];
    [self updateIconFromDictionary:dict];
    [self updateLocationNameFromDictionary:dict];
    [self updateLastUpdatedDateFromDictionary:dict];
    [self updateLocationFromDictionary:dict];
    
    if ([self.delegate respondsToSelector:@selector(weatherModelUpdated)])
        [self.delegate weatherModelUpdated];
}

- (void)updateWeatherDescriptionFromDictionary:(NSDictionary *)dict
{
    // Weather key actually returns an array of weather reports.
    // As we are only interested in the current weather, we just
    // pull in the first object.
    NSDictionary *weather = [dict objectForKey:@"weather"][0];
    self.weatherDescription = [weather objectForKey:@"description"];
}


- (void)updateTemperatureFromDictionary:(NSDictionary *)dict
{
    NSDictionary *main = [dict objectForKey:@"main"];
    self.temperature = [main objectForKey:@"temp"];
}

- (void)updateIconFromDictionary:(NSDictionary *)dict
{
    // Weather key actually returns an array of weather reports.
    // As we are only interested in the current weather, we just
    // pull in the first object.
    NSDictionary *weather = [dict objectForKey:@"weather"][0];
    self.icon = [weather objectForKey:@"icon"];
}

- (void)updateLocationNameFromDictionary:(NSDictionary *)dict
{
    self.locationName = [dict objectForKey:@"name"];
}

- (void)updateLastUpdatedDateFromDictionary:(NSDictionary *)dict
{
    NSNumber *unixTimestamp = [dict objectForKey:@"dt"];
    self.lastUpdated = [NSDate dateWithTimeIntervalSince1970:[unixTimestamp doubleValue]];
}

- (void)updateLocationFromDictionary:(NSDictionary *)dict
{
    NSDictionary *coord = [dict objectForKey:@"coord"];
    double lat = [[coord objectForKey:@"lat"] doubleValue];
    double lon = [[coord objectForKey:@"lon"] doubleValue];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat
                                                      longitude:lon];
    self.location = location;
}

#pragma mark - Parsing
+ (NSString *)parseDate: (NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    return [formatter stringFromDate: date];
}

+ (NSDictionary *)parseJSONData:(NSData *)data
{
    NSError *error = nil;
    NSDictionary *parsedData = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:&error];
    if (parsedData)
        return parsedData;
    else
        NSLog(@"JSON parse error %@", error);
    return nil;
}

#pragma mark - Temperature conversion
+ (NSNumber *)convertKelvinToCelsius: (NSNumber *)kelvin
{
    float k = [kelvin floatValue];
    float c = k - 273.15;
    return [NSNumber numberWithFloat:c];
}

+ (NSNumber *)convertCelsiusToFahrenheit: (NSNumber *)celsius
{
    float c = [celsius floatValue];
    float f = c * 9 / 5 + 32;
    return [NSNumber numberWithFloat:f];
}

#pragma mark - Getters
- (NSNumber *)getTemperatureInCelsius
{
    return [WeatherModel convertKelvinToCelsius:self.temperature];
}

- (NSNumber *)getTemperatureInFahrenheit
{
    NSNumber *celsius = [WeatherModel convertKelvinToCelsius:self.temperature];
    return [WeatherModel convertCelsiusToFahrenheit:celsius];
}

@end
