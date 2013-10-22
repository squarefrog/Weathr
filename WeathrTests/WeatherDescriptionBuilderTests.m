//
//  WeatherDescriptionBuilderTests.m
//  Weathr
//
//  Created by Paul Williamson on 22/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WeatherDescriptionBuilder.h"
#import "WeatherDescriptionBuilder+PrivateMethods.h"
#import "WeatherModel.h"

@interface WeatherDescriptionBuilderTests : XCTestCase {
    WeatherModel *model;
    NSMutableAttributedString *testCase;
    NSMutableAttributedString *locationNameWithAttributes;
    NSMutableAttributedString *emptyString;
    NSMutableAttributedString *locationAndTemperature;
}

@end

@implementation WeatherDescriptionBuilderTests

- (void)setUp
{
    [super setUp];
    
    model = [[WeatherModel alloc] init];
    
    model.weatherDescription = @"Cloudy";
    model.locationName = @"London";
    model.temperature = [NSNumber numberWithFloat:284.94];
    
    emptyString = [[NSMutableAttributedString alloc] init];
    
    locationNameWithAttributes = [[NSMutableAttributedString alloc] initWithString:model.locationName attributes:@{NSFontAttributeName: LOCATION_NAME_FONT}];
    
    locationAndTemperature = [[NSMutableAttributedString alloc] initWithString:@"London 12º"];
}

- (void)tearDown
{
    model = nil;
    testCase = nil;
    emptyString = nil;
    locationNameWithAttributes = nil;
    locationAndTemperature = nil;
    [super tearDown];
}

#pragma mark - Getters
- (void)testModelReturnsDetailedWeatherDescriptionAsAttributedString
{
    id description = [WeatherDescriptionBuilder detailedWeatherDescriptionFromModel:model];
    XCTAssertTrue([[description class] isSubclassOfClass:[NSAttributedString class]], @"Description should be an attributed string");
}

#pragma mark - Location name
- (void)testBuilderShouldReturnLocationNameString
{
    testCase = [WeatherDescriptionBuilder updateString:emptyString withLocationNameFromModel:model];
    
    XCTAssertEqualObjects(testCase.string, locationNameWithAttributes.string, @"Builder should return a string from model.locationName");
}

- (void)testBuilderShouldSetAttributesForLocationNameString
{
    testCase = [WeatherDescriptionBuilder updateString:emptyString withLocationNameFromModel:model];
    
    XCTAssertEqualObjects(testCase, locationNameWithAttributes, @"Builder should set attributes for model.locationName");
}

- (void)testBuilderShouldReturnNilForNilLocationNameString
{
    testCase = [WeatherDescriptionBuilder updateString:emptyString withLocationNameFromModel:nil];
    
    XCTAssertEqualObjects(testCase, emptyString, @"Builder should return a nil object when given nil input");
}

#pragma mark - Temperature
- (void)testBuilderShouldAppendTemperatureString
{
    testCase = [[NSMutableAttributedString alloc] initWithString:@"London"];
    
    testCase = [WeatherDescriptionBuilder updateString:testCase withTemperatureFromModel:model];
    
    XCTAssertEqualObjects(testCase.string, [locationAndTemperature string], @"Builder should return a string appended with model.temperature");
}

- (void)testBuilderShouldReturnTemperatureStringWithEmptyInputString
{
    NSString *expectedResult =  @"12º";
    
    testCase = [WeatherDescriptionBuilder updateString:emptyString withTemperatureFromModel:model];
    
    XCTAssertEqualObjects(testCase.string, expectedResult, @"Builder should return a string with model.temperature when given nil input");
}

- (void)testBuilderShouldAppendTemperatureStringWithMinusTemperature
{
    NSString *expectedResult = @"-5º";
    model.temperature = [NSNumber numberWithFloat:268.15]; // -5ºC

    testCase = [WeatherDescriptionBuilder updateString:emptyString withTemperatureFromModel:model];
    
    XCTAssertEqualObjects(testCase.string, expectedResult, @"Builder should return a string with minus temperature");
}

- (void)testBuilderDoesNotAppendIfTemperatureNil
{
    model.temperature = nil;
    
    testCase = [WeatherDescriptionBuilder updateString:locationNameWithAttributes withTemperatureFromModel:model];
    
    XCTAssertEqualObjects(testCase, locationNameWithAttributes, @"Builder should not append model.temperature if model.temperature == nil");
}

#pragma mark - Description
- (void)testBuilderShouldAppendDescriptionString
{
    NSString *expectedResult = @"London 12º\nCloudy";

    testCase = [WeatherDescriptionBuilder updateString:locationAndTemperature withDescriptionFromModel:model];
    
    XCTAssertEqualObjects(testCase.string, expectedResult, @"Builder should return a string appended with model.weatherDescription");
}

- (void)testBuilderShouldAppendDescriptionStringAttributes
{
    NSMutableAttributedString *expectedResult =
    [[NSMutableAttributedString alloc] initWithString:@"London 12º\nCloudy"];
    [expectedResult addAttribute:NSFontAttributeName value:DESCRIPTION_FONT range:NSMakeRange(11, 6)];
    
    testCase = [WeatherDescriptionBuilder updateString:locationAndTemperature withDescriptionFromModel:model];
    
    XCTAssertEqualObjects(testCase, expectedResult, @"Builder should return an attributed string with model.weatherDescription");
}

- (void)testBuilderDoesNotAddNewLineIfInputIsEmpty
{
    NSString *expectedResult = @"Cloudy";
    
    [WeatherDescriptionBuilder updateString:emptyString withDescriptionFromModel:model];
    
    XCTAssertEqualObjects(emptyString.string, expectedResult, @"Builder should not add a new line char to model.weatherDescription if input string == nil");
}

- (void)testBuilderDoesNotAppendDescriptionIfNil
{
    model.weatherDescription = nil;
    
    testCase = [WeatherDescriptionBuilder updateString:locationAndTemperature withDescriptionFromModel:model];
    
    XCTAssertEqualObjects(testCase, locationAndTemperature, @"Builder should not append model.weatherDescription if model.weatherDescription == nil");
}

@end
