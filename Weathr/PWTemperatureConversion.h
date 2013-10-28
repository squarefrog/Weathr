//
//  PWTemperatureConversion.h
//  Weathr
//
//  Created by Paul Williamson on 28/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PWTemperatureConversion : NSObject

+ (float)kelvinToCelsius:(float)kelvin;
+ (float)kelvinToFahrenheit:(float)kelvin;

@end
