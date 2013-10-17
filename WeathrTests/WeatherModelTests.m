//
//  WeatherModelTests.m
//  Weathr
//
//  Created by Paul Williamson on 17/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WeatherModel.h"

@interface WeatherModelTests : XCTestCase

@end

@implementation WeatherModelTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - Properties
- (void)testModelHasWeatherDescriptionProperty
{
    XCTAssertTrue([WeatherModel instancesRespondToSelector:@selector(weatherDescription)], @"weatherDescription property does not exist on weather model class");
}

- (void)testModelHasTemperatureProperty
{
    XCTAssertTrue([WeatherModel instancesRespondToSelector:@selector(temperature)], @"temperature property does not exist on weather model class");
}

- (void)testModelHasIconProperty
{
    XCTAssertTrue([WeatherModel instancesRespondToSelector:@selector(icon)], @"icon property does not exist on weather model class");
}

- (void)testModelHasLocationNameProperty
{
    XCTAssertTrue([WeatherModel instancesRespondToSelector:@selector(locationName)], @"locationName property does not exist on weather model class");
}

- (void)testModelHasLastUpdatedProperty
{
    XCTAssertTrue([WeatherModel instancesRespondToSelector:@selector(lastUpdated)], @"lastUpdated property does not exist on weather model class");
}

- (void)testModelHasLatitudeProperty
{
    XCTAssertTrue([WeatherModel instancesRespondToSelector:@selector(lat)], @"lat property does not exist on weather model class");
}

- (void)testModelHasLongitudeProperty
{
    XCTAssertTrue([WeatherModel instancesRespondToSelector:@selector(lon)], @"lon property does not exist on weather model class");
}

#pragma mark - Methods

- (void)testTemperatureConversion
{
    NSNumber *celsius = [NSNumber numberWithFloat:19.0];
    NSNumber *fahrenheit = [WeatherModel convertCelsiusToFahrenheit: celsius];
    XCTAssertEqual([fahrenheit floatValue], 66.2f, @"Temperature conversion should equal 68, got %f", [fahrenheit floatValue]);
}

@end
