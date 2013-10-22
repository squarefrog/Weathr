//
//  WeatherModelExtensions.m
//  Weathr
//
//  Created by Paul Williamson on 20/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import "WeatherModelExtensions.h"

@implementation WeatherModelExtensions

+ (NSBundle *)bundle
{
    return [NSBundle bundleForClass:[self class]];
}

+ (NSData *)loadJSONFromFile
{
    NSString *filePath = [[self bundle] pathForResource:@"example_response" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return data;
}

+ (NSDictionary *)loadPlistFromFile
{
    NSString *filePath = [[self bundle] pathForResource:@"example_response" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dict;
}

@end
