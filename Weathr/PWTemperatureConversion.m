//
//  PWTemperatureConversion.m
//  Weathr
//
//  Created by Paul Williamson on 28/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import "PWTemperatureConversion.h"

@implementation PWTemperatureConversion

+ (float)kelvinToCelsius:(float)kelvin
{
    return kelvin - 273.15;
}

+ (float)kelvinToFahrenheit:(float)kelvin
{
    return 1.8 * (kelvin - 273.15) + 32;
}

@end
