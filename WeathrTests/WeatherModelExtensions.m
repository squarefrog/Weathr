//
//  WeatherModelExtensions.m
//  Weathr
//
//  Created by Paul Williamson on 20/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import "WeatherModelExtensions.h"

@implementation WeatherModelExtensions

+ (NSData *)loadJSONFromFile
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *filePath = [bundle pathForResource:@"example_response" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return data;
}

@end
