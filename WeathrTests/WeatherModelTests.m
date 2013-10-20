//
//  WeatherModelTests.m
//  Weathr
//
//  Created by Paul Williamson on 17/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WeatherModel.h"
#import "WeatherModelExtensions.h"

@interface WeatherModelTests : XCTestCase <WeatherModelDelegate> {
    NSData *data;
    WeatherModel *model;
    NSDictionary *parsedData;
    BOOL callbackInvoked;
}

@end

@implementation WeatherModelTests

- (void)setUp
{
    [super setUp];
    data = [WeatherModelExtensions loadJSONFromFile];
    model = [[WeatherModel alloc] init];
    parsedData = (NSDictionary *)[WeatherModel parseJSONData:data];
}

- (void)tearDown
{
    data = nil;
    model = nil;
    parsedData = nil;
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

- (void)testModelHasLocationProperty
{
    XCTAssertTrue([WeatherModel instancesRespondToSelector:@selector(location)], @"Location property does not exist on weather model class");
}


#pragma mark - Temperature

- (void)testTemperatureConversionKelvin
{
    NSNumber *kelvin = [NSNumber numberWithFloat:284.94];
    NSNumber *celsius = [WeatherModel convertKelvinToCelsius: kelvin];
    NSNumber *expected = [NSNumber numberWithFloat:11.79];
    XCTAssertEqualWithAccuracy([celsius floatValue], [expected floatValue], 0.00001, @"Kelvin conversion should equal %f, got %f", [expected floatValue], [celsius floatValue]);
}


- (void)testTemperatureConversionFahrenheit
{
    NSNumber *celsius = [NSNumber numberWithFloat:19.0];
    NSNumber *fahrenheit = [WeatherModel convertCelsiusToFahrenheit: celsius];
    XCTAssertEqual([fahrenheit floatValue], 66.2f, @"Fahrenheit conversion should equal 68, got %f", [fahrenheit floatValue]);
}

#pragma mark - Parsing

- (void)testDateCanBeConvertedToNaturalLanguage
{
    NSDate *testDate = [NSDate date];
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateStyle:NSDateFormatterShortStyle];
    [f setTimeStyle:NSDateFormatterShortStyle];
    
    NSString *testString = [WeatherModel parseDate:testDate];
    XCTAssertEqualObjects(testString, [f stringFromDate:testDate], @"NSDate parsed incorrectly");
}

- (void)testJSONDatafileCanBeLoaded
{
    data = [WeatherModelExtensions loadJSONFromFile];
    XCTAssertNotNil(data, @"Example response should be loaded from file");
}

- (void)testNSDataCanBeParsedToDictionary
{
    data = [WeatherModelExtensions loadJSONFromFile];
    id testData = [WeatherModel parseJSONData:data];
    XCTAssertTrue([[testData class] isSubclassOfClass: [NSMutableDictionary class]], @"Data should be NSMutableDictionary format");
}

#pragma mark - Update properties
- (void)testWeatherDescriptionCanBeUpdatedFromParsedData
{
    [model updateWeatherDescriptionFromDictionary:parsedData];
    
    XCTAssertNotNil(model.weatherDescription, @"Weather description property should be set");
}

- (void)testTemperatureCanBeUpdatedFromParsedData
{
    [model updateTemperatureFromDictionary:parsedData];
    
    XCTAssertNotNil(model.temperature, @"Temperature property should be set");
}

- (void)testIconStringCanBeUpdatedFromParsedData
{
    [model updateIconFromDictionary:parsedData];
    
    XCTAssertNotNil(model.icon, @"Icon property should be set");
}

- (void)testLocationNameCanBeUpdatedFromParsedData
{
    [model updateLocationNameFromDictionary:parsedData];
    
    XCTAssertNotNil(model.locationName, @"Location name property should be set");
}

- (void)testLastUpdatedDateCanBeUpdatedFromParsedData
{
    [model updateLastUpdatedDateFromDictionary:parsedData];
    
    XCTAssertNotNil(model.lastUpdated, @"Last updated date property should be set");
}

- (void)testLocationCanBeUpdatedFromParsedData
{
    [model updateLocationFromDictionary:parsedData];
    
    XCTAssertNotNil(model.location, @"Location property should be set");
}

#pragma mark - Get values
- (void)testGetTemperatureInCelsius
{
    model.temperature = [NSNumber numberWithFloat:284.94];
    NSNumber *expected = [NSNumber numberWithFloat:11.79];
    XCTAssertEqualWithAccuracy([[model getTemperatureInCelsius] floatValue], [expected floatValue], 0.00001, @"Model should return temperature in celsius");
}
- (void)testGetTemperatureInFahrenheit
{
    model.temperature = [NSNumber numberWithFloat:284.94];
    NSNumber *expected = [NSNumber numberWithFloat:53.222];
    XCTAssertEqualWithAccuracy([[model getTemperatureInFahrenheit] floatValue], [expected floatValue], 0.00001, @"Model should return temperature in fahrenheit");
}

- (void)testModelReturnsDetailedWeatherDescriptionString
{
    model.temperature = [NSNumber numberWithFloat:284.94];
    model.weatherDescription = @"Cloudy";
    model.locationName = @"London";
    NSString *expectedAnswer = @"London 11.79º\nCloudy";
    XCTAssertEqualObjects([model getDetailedWeatherDescriptionString], expectedAnswer, @"Model should return a detailed weather description string");
}

#pragma mark - Delegate
- (void)testDelegateCallback
{
    model.delegate = self;
    [model.delegate weatherModelUpdated];
    XCTAssertTrue(callbackInvoked, @"Delegate callback should be called");
    model.delegate = nil;
}

- (void)weatherModelUpdated
{
    callbackInvoked = YES;
}

@end
