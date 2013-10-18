//
//  WeatherModel.m
//  Weathr
//
//  Created by Paul Williamson on 17/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherModel

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

@end
