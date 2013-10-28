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
#import "WeatherModelStubs.h"
#import <CoreLocation/CoreLocation.h>

@interface WeatherModelTests : XCTestCase <WeatherModelDelegate>
{
    NSData *stubJSON;
    NSDate *date;
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
    stubJSON = [WeatherModelStubs stubJSON];
    stubDictionary = [WeatherModelStubs stubDict];
    date = [NSDate date];
    
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
- (void)testWeatherDescriptionIsNotUpdatedWithMalformedData
{
    model.weatherDescription = nil;
    model.locationName = nil;
    model.temperature = nil;
    
    NSString *brokenJSONString = @"Not JSON";
    NSData *brokenJSON = [brokenJSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    [model updateWeatherModelFromNSData:brokenJSON];
    
    XCTAssertNil(model.weatherDescription, @"Model should not update description with broken data");
    XCTAssertNil(model.temperature, @"Model should not update temperature with broken data");
    XCTAssertNil(model.icon, @"Model should not update icon with broken data");
    XCTAssertNil(model.locationName, @"Model should not update location name with broken data");
    XCTAssertNil(model.lastUpdated, @"Model should not update last updated with broken data");
    XCTAssertNil(model.location, @"Model should not update location with broken data");
}

- (void)testWeatherDescriptionCanBeUpdatedFromParsedData
{
    [model updateWeatherModelFromNSData:stubJSON];
    XCTAssertEqualObjects(model.weatherDescription, @"light rain", @"Weather description property should be set");
}

- (void)testTemperatureCanBeUpdatedFromParsedData
{
    [model updateWeatherModelFromNSData:stubJSON];
    XCTAssertEqualObjects(model.temperature, @285.82999999999998, @"Temperature property should be set");
}

- (void)testIconStringCanBeUpdatedFromParsedData
{
    [model updateWeatherModelFromNSData:stubJSON];
    XCTAssertEqualObjects(model.icon, @"10n", @"Icon property should be set");
}

- (void)testLocationNameCanBeUpdatedFromParsedData
{
    [model updateWeatherModelFromNSData:stubJSON];
    XCTAssertEqualObjects(model.locationName, @"East Ham", @"Location name property should be set");
}

- (void)testLastUpdatedDateIsSet
{
    [model updateWeatherModelFromNSData:stubJSON];
    XCTAssertNotNil(model.lastUpdated, @"Last updated date property should be set");
}

- (void)testLocationCanBeUpdatedFromParsedData
{
    // We only care about the location coordinates here
    double lat = 51.509999999999998;
    double lon = 0.13;
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(lat, lon);
    
    [model updateWeatherModelFromDictionary:stubDictionary];
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
    id testData = [WeatherModel parseJSONData:stubJSON];
    XCTAssertEqualObjects(testData, stubDictionary, @"JSON data should be parsed to NSDictionary");
}

- (void)testNilDataParsingReturnsNil
{
    NSString *testString = @"Not JSON";
    NSData *testData = [testString dataUsingEncoding:NSUTF8StringEncoding];
    id testCase = [WeatherModel parseJSONData:testData];
    XCTAssertNil(testCase, @"Failed JSON parse should return nil");
}


#pragma mark - Delegate
- (void)testDelegateCallbackWhenModelUpdateFinishes
{
    model.delegate = self;
    [model updateWeatherModelFromDictionary:stubDictionary];
    XCTAssertTrue(callbackInvoked, @"Delegate callback should be called");
    model.delegate = nil;
}

#pragma mark - Delegate helper methods
- (void)weatherModelUpdated
{
    callbackInvoked = YES;
}

@end
