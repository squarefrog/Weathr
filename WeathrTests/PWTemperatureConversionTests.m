//
//  PWTemperatureConversionTests.m
//  Weathr
//
//  Created by Paul Williamson on 28/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PWTemperatureConversion.h"

@interface PWTemperatureConversionTests : XCTestCase

@end

@implementation PWTemperatureConversionTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testKelvinToCelsius
{
    float kelvin = 284.94f;
    float celsius = [PWTemperatureConversion kelvinToCelsius:kelvin];
    
    XCTAssertEqualWithAccuracy(celsius, 11.79f, 0.0001, @"Temperature should be converted from kelvin to celsius");
}

- (void)tesKelvinToMinusCelsius
{
    float kelvin = 233.15f;
    float celsius = [PWTemperatureConversion kelvinToCelsius:kelvin];
    XCTAssertEqualWithAccuracy(celsius, -40.0f, 0.0001, @"Temperature should be converted from kelvin to minus celsius");
}

- (void)testKelvinToFahrenheit
{
    float kelvin = 293.15f;
    float f = [PWTemperatureConversion kelvinToFahrenheit:kelvin];
    XCTAssertEqualWithAccuracy(f, 68.0f, 0.0001, @"Temperature should be converted from kelvin to fahrenheit");
}

- (void)testKelvinToMinusCelsius
{
    float kelvin = 233.15f;
    float f = [PWTemperatureConversion kelvinToFahrenheit:kelvin];
    
    XCTAssertEqualWithAccuracy(f, -40.0f, 0.0001, @"Temperature should be converted from kelvin to minus fahrenheit");
}

@end
