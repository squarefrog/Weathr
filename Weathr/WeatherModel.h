//
//  WeatherModel.h
//  Weathr
//
//  Created by Paul Williamson on 17/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLocation;

@protocol WeatherModelDelegate <NSObject>
- (void)weatherModelUpdated;
@end

@interface WeatherModel : NSObject

@property (nonatomic, weak)     id <WeatherModelDelegate> delegate;
@property (nonatomic, copy)     NSString *weatherDescription;
@property (nonatomic, strong)   NSNumber *temperature;
@property (nonatomic, copy)     NSString *icon;
@property (nonatomic, copy)     NSString *locationName;
@property (nonatomic, strong)   NSDate   *lastUpdated;
@property (nonatomic, strong)   CLLocation *location;

+ (NSNumber *)convertKelvinToCelsius: (NSNumber *)kelvin;
+ (NSNumber *)convertCelsiusToFahrenheit: (NSNumber *)celsius;
+ (NSString *)parseDate: (NSDate *)date;

- (void)updateWeatherModelFromNSData:(NSData *)data;
- (NSString *)getDetailedWeatherDescriptionString;
- (NSNumber *)getTemperatureInCelsius;

@end

@interface WeatherModel (private)

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
