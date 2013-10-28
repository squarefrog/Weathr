//
//  WeatherDescriptionBuilder.m
//  Weathr
//
//  Created by Paul Williamson on 22/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import "WeatherDescriptionBuilder.h"

#import "PWTemperatureConversion.h"
#import "WeatherModel.h"

@implementation WeatherDescriptionBuilder

+ (NSMutableAttributedString *)detailedWeatherDescriptionFromModel:(WeatherModel *)model;
{
    if (model) {
        NSMutableAttributedString *weatherDescription = [[NSMutableAttributedString alloc] init];
        
        weatherDescription = [WeatherDescriptionBuilder updateString:weatherDescription withLocationNameFromModel:model];
        weatherDescription = [WeatherDescriptionBuilder updateString:weatherDescription withTemperatureFromModel:model];
        weatherDescription = [WeatherDescriptionBuilder updateString:weatherDescription withDescriptionFromModel:model];
        
        return weatherDescription;
    }
    return nil;
}

#pragma mark - Private methods
+ (NSMutableAttributedString *)updateString:(NSMutableAttributedString *)attributedString withLocationNameFromModel:(WeatherModel *)model
{
    if (model.locationName)
    {
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:model.locationName];

        [aString addAttribute:NSFontAttributeName
                        value:LOCATION_NAME_FONT
                        range:NSMakeRange(0, model.locationName.length)];
        
        [attributedString appendAttributedString:aString];
    }
    
    return attributedString;
}

+ (NSMutableAttributedString *)updateString:(NSMutableAttributedString *)attributedString withTemperatureFromModel:(WeatherModel *)model
{
    if (model.temperature)
    {
        float celsius = [PWTemperatureConversion kelvinToCelsius:[model.temperature floatValue]];
        
        NSString *temp = attributedString.length > 0 ? [NSString stringWithFormat:@" %.0fº", celsius] : [NSString stringWithFormat:@"%.0fº", celsius];
        
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:temp];
        [attributedString appendAttributedString:aString];
    }
    return attributedString;
}

+ (NSMutableAttributedString *)updateString:(NSMutableAttributedString *)attributedString withDescriptionFromModel:(WeatherModel *)model
{
    if (model.weatherDescription)
    {
        NSString *temp = attributedString.length > 0 ? [NSString stringWithFormat:@"\n%@", model.weatherDescription] : [NSString stringWithFormat:@"%@", model.weatherDescription];
        NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:temp];
        
        NSRange range = [temp rangeOfString:model.weatherDescription];
        [aString addAttribute:NSFontAttributeName
                        value:DESCRIPTION_FONT
                        range:range];
        
        [attributedString appendAttributedString:aString];
    }
    
    return attributedString;
}

@end
