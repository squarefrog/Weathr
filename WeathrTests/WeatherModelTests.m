//
//  WeatherModelTests.m
//  Weathr
//
//  Created by Paul Williamson on 17/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WeatherModel.h"
#import "WeatherModel+PrivateMethods.h"
#import "WeatherModelExtensions.h"
#import <CoreLocation/CoreLocation.h>

@interface WeatherModelTests : XCTestCase <WeatherModelDelegate>
{
    NSData *stubJSON;
    WeatherModel *model;
    NSDictionary *stubDictionary;
    BOOL callbackInvoked;
}

@end

@implementation WeatherModelTests

- (void)setUp
{
    [super setUp];
    
    model = [[WeatherModel alloc] init];
    stubJSON = [WeatherModelExtensions loadJSONFromFile];
    stubDictionary = [WeatherModelExtensions loadPlistFromFile];
    
    model.weatherDescription = @"Cloudy";
    model.locationName = @"London";
    model.temperature = [NSNumber numberWithFloat:284.94];
}

- (void)tearDown
{
    model = nil;
    stubJSON = nil;
    stubDictionary = nil;
    [super tearDown];
}

#pragma mark - Internal tests
- (void)testWeatherModelExtensionsLoadsJSON
{
    XCTAssertNotNil(stubJSON, @"JSON should have loaded from file");
}

- (void)testWeatherModelExtensionsLoadsPropertyList
{
    XCTAssertNotNil(stubDictionary, @"Dictionary stub should have loaded from file");
}

#pragma mark - Properties
// TODO: There must be a better way to do these checks
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

#pragma mark - Update properties
- (void)testWeatherDescriptionCanBeUpdatedFromParsedData
{
    [model updateWeatherDescriptionFromDictionary:stubDictionary];
    XCTAssertEqualObjects(model.weatherDescription, @"light rain", @"Weather description property should be set");
}

- (void)testTemperatureCanBeUpdatedFromParsedData
{
    [model updateTemperatureFromDictionary:stubDictionary];
    XCTAssertEqualObjects(model.temperature, @285.82999999999998, @"Temperature property should be set");
}

- (void)testIconStringCanBeUpdatedFromParsedData
{
    [model updateIconFromDictionary:stubDictionary];
    XCTAssertEqualObjects(model.icon, @"10n", @"Icon property should be set");
}

- (void)testLocationNameCanBeUpdatedFromParsedData
{
    [model updateLocationNameFromDictionary:stubDictionary];
    XCTAssertEqualObjects(model.locationName, @"East Ham", @"Location name property should be set");
}

- (void)testLastUpdatedDateCanBeUpdatedFromGivenDate
{
    NSDate *date = [NSDate date];
    [model updateLastUpdatedDate:date];
    XCTAssertEqualObjects(model.lastUpdated, date, @"Last updated date property should be set");
}

- (void)testLocationCanBeUpdatedFromParsedData
{
    // We only care about the location coordinates here
    double lat = 51.509999999999998;
    double lon = 0.13;
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(lat, lon);
    
    [model updateLocationFromDictionary:stubDictionary];
    XCTAssertEqual(model.location.coordinate, coords, @"Location property should be set");
}

#pragma mark - Parsing
// WARNING: Fragile test ahead!
// This is currently tied to UK number formatting set in
// Settings > General > International > Region Format
// TODO: Find a more robust way to test data parsing
- (void)testDateCanBeConvertedToNaturalLanguage
{
    // DATE (M/D/Y @ h:m:s): 09 / 01 / 2010 @ 16:37:42 GMT
    NSDate *testDate = [NSDate dateWithTimeIntervalSince1970:1283355462];
    NSString *testString = [WeatherModel parseDate:testDate];
    
    XCTAssertEqualObjects(testString, @"01/09/2010 16:37", @"NSDate parsed incorrectly");
}

- (void)testNSDataCanBeParsedToDictionary
{
    stubJSON = [WeatherModelExtensions loadJSONFromFile];
    id testData = [WeatherModel parseJSONData:stubJSON];
    XCTAssertEqualObjects(testData, stubDictionary, @"JSON data should be parsed to NSDictionary");
}

#pragma mark - Temperature conversion
- (void)testTemperatureConversionFromKelvin
{
    NSNumber *kelvin = [NSNumber numberWithFloat:284.94];
    NSNumber *celsius = [WeatherModel convertKelvinToCelsius: kelvin];
    
    XCTAssertEqualWithAccuracy([celsius floatValue], 11.79f, 0.00001, @"Temperature should be converted from kelvin to celsius");
}

- (void)testTemperatureConversionFromKelvinWithMinusResultExpected
{
    NSNumber *kelvin = [NSNumber numberWithFloat:268.15];
    NSNumber *celsius = [WeatherModel convertKelvinToCelsius: kelvin];
    
    XCTAssertEqualWithAccuracy([celsius floatValue], -5.0f, 0.00001, @"Temperature should be converted from kelvin to -celsius");
}

- (void)testTemperatureConversionFromFahrenheit
{
    NSNumber *celsius = [NSNumber numberWithFloat:19.0];
    NSNumber *fahrenheit = [WeatherModel convertCelsiusToFahrenheit: celsius];
    XCTAssertEqual([fahrenheit floatValue], 66.2f, @"Temperature should be converted from celsius to fahrenheit");
}

- (void)testTemperatureConversionFromFahrenheitWithMinusResultExpected
{
    NSNumber *celsius = [NSNumber numberWithFloat:-40];
    NSNumber *fahrenheit = [WeatherModel convertCelsiusToFahrenheit: celsius];
    XCTAssertEqual([fahrenheit floatValue], -40.0f, @"Temperature should be converted from celsius to -fahrenheit");
}

#pragma mark - Delegate
- (void)testDelegateCallback
{
    model.delegate = self;
    [model.delegate weatherModelUpdated];
    XCTAssertTrue(callbackInvoked, @"Delegate callback should be called");
    model.delegate = nil;
}

#pragma mark - Delegate helper methods
- (void)weatherModelUpdated
{
    callbackInvoked = YES;
}

@end
