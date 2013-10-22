//
//  WeatherDescriptionBuilder+PrivateMethods.h
//  Weathr
//
//  Created by Paul Williamson on 22/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import "WeatherDescriptionBuilder.h"
@class WeatherModel;

@interface WeatherDescriptionBuilder (PrivateMethods)

+ (NSMutableAttributedString *)updateString:(NSMutableAttributedString *)attributedString withLocationNameFromModel:(WeatherModel *)model;
+ (NSMutableAttributedString *)updateString:(NSMutableAttributedString *)attributedString withTemperatureFromModel:(WeatherModel *)model;
+ (NSMutableAttributedString *)updateString:(NSMutableAttributedString *)attributedString withDescriptionFromModel:(WeatherModel *)model;

@end
