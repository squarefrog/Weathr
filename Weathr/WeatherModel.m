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

- (NSNumber *)getTemperatureInCelsius
{
    return [WeatherModel convertKelvinToCelsius:self.temperature];
}

- (NSNumber *)getTemperatureInFahrenheit
{
    NSNumber *celsius = [WeatherModel convertKelvinToCelsius:self.temperature];
    return [WeatherModel convertCelsiusToFahrenheit:celsius];
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

#pragma mark - Parsing
+ (NSString *)parseDate: (NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    return [formatter stringFromDate: date];
}

+ (id)parseJSONData:(NSData *)data
{
    NSError *error;
    id parsedData = [NSJSONSerialization JSONObjectWithData:data
                                                    options:NSJSONReadingMutableContainers
                                                      error:&error];
    if (!error)
        return parsedData;
    return nil;
}

#pragma mark - Property updates
// This method is untested, but each individual call is tested
// in it's own test so we're covered.
- (void)updateWeatherModelFromDictionary:(NSDictionary *)dict
{
    [self updateWeatherModelFromDictionary:dict];
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
    self.weatherDescription = [dict objectForKey:@"name"];
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

@end
