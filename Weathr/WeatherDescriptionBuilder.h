//
//  WeatherDescriptionBuilder.h
//  Weathr
//
//  Created by Paul Williamson on 22/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WeatherModel;

#define LOCATION_NAME_FONT [UIFont boldSystemFontOfSize:24]
#define DESCRIPTION_FONT [UIFont fontWithName:@"HelveticaNeue-Light" size:20]

@interface WeatherDescriptionBuilder : NSObject

+ (NSMutableAttributedString *)detailedWeatherDescriptionFromModel:(WeatherModel *)model;

@end
