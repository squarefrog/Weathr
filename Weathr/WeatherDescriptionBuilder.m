//
//  WeatherDescriptionBuilder.m
//  Weathr
//
//  Created by Paul Williamson on 22/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import "WeatherDescriptionBuilder.h"
#import "WeatherModel.h"

@implementation WeatherDescriptionBuilder

+ (NSMutableAttributedString *)detailedWeatherDescriptionFromModel:(WeatherModel *)model;
{
    NSNumber *celsius = [WeatherModel convertKelvinToCelsius:model.temperature];
    NSString *plain = [NSString stringWithFormat:@"%@ %.0fº\n%@", model.locationName, [celsius floatValue], model.weatherDescription];
    
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:plain];
    [string beginEditing];
    
    
    NSRange descriptionRange = [plain rangeOfString:model.weatherDescription];
    
    NSRange locationNameRange = NSMakeRange(0, model.locationName.length);
    [string addAttribute:NSFontAttributeName
                   value:[UIFont boldSystemFontOfSize:24]
                   range:locationNameRange];
    
    [string addAttribute:NSFontAttributeName
                   value:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]
                   range:descriptionRange];
    
    [string endEditing];
    
    return string;
}

+ (NSMutableAttributedString *)locationNameAttributeStringFromModel:(WeatherModel *)model
{
    if (model.locationName) {
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:model.locationName];

        [aString addAttribute:NSFontAttributeName
                        value:LOCATION_NAME_FONT
                        range:NSMakeRange(0, model.locationName.length)];

        return aString;
    }
    
    return nil;
}

@end
