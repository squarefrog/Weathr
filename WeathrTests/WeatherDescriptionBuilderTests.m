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
    NSMutableAttributedString *locationName;
    NSMutableAttributedString *inputString;
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
    
    locationName = [[NSMutableAttributedString alloc] initWithString:model.locationName attributes:@{NSFontAttributeName: LOCATION_NAME_FONT}];
    
    inputString = [[NSMutableAttributedString alloc] init];
}

- (void)tearDown
{
    model = nil;
    locationName = nil;
    inputString = nil;
    [super tearDown];
}

#pragma mark - Getters
- (void)testModelReturnsDetailedWeatherDescriptionAsAttributedString
{
    id description = [WeatherDescriptionBuilder detailedWeatherDescriptionFromModel:model];
    XCTAssertTrue([[description class] isSubclassOfClass:[NSAttributedString class]], @"Description should be an attributed string");
}

#pragma mark - Location name
- (void)testBuilderShouldCreateLocationNameString
{
    NSMutableAttributedString *tString = [WeatherDescriptionBuilder updateString:inputString withLocationNameFromModel:model];
    XCTAssertEqualObjects(tString.string, locationName.string, @"Builder should return a string for model location");
}

- (void)testBuilderShouldSetAttributesForLocationNameString
{
    NSMutableAttributedString *tString = [WeatherDescriptionBuilder updateString:inputString withLocationNameFromModel:model];
    XCTAssertEqualObjects(tString, locationName, @"Builder should set attributes for location name");
}

- (void)testBuilderShouldSetNilForNilLocationNameString
{
    XCTAssertEqualObjects([WeatherDescriptionBuilder updateString:inputString withTemperatureFromModel:nil], inputString, @"Builder should return a nil object when given nil model");
}

#pragma mark - Temperature
- (void)testBuilderShouldAppendTemperatureString
{
    NSString *expected = @"London 12º";
    NSMutableAttributedString *iString = [[NSMutableAttributedString alloc] initWithString:@"London"];
    NSMutableAttributedString *temperature = [WeatherDescriptionBuilder updateString:iString withTemperatureFromModel:model];
    XCTAssertEqualObjects(temperature.string, expected, @"Builder should return a string appended with temperature");
}

- (void)testBuilderShouldReturnTemperatureStringWithBlankInput
{
    NSString *expected = @"12º";
    NSMutableAttributedString *temperature = [WeatherDescriptionBuilder updateString:inputString withTemperatureFromModel:model];
    XCTAssertEqualObjects(temperature.string, expected, @"Builder should return a string with temperature");
}

- (void)testBuilderShouldAppendTemperatureStringWithMinusTemperature
{
    model.temperature = [NSNumber numberWithFloat:268.15];
    NSString *expectedAnswer = @"-5º";
    NSMutableAttributedString *temperature = [WeatherDescriptionBuilder updateString:inputString withTemperatureFromModel:model];
    XCTAssertEqualObjects(temperature.string, expectedAnswer, @"Model should return a string with minus temperature");
}

#pragma mark - Description
- (void)testBuilderShouldAppendDescriptionString
{
    NSString *expected = @"London 12º\nCloudy";
    NSMutableAttributedString *iString = [[NSMutableAttributedString alloc] initWithString:@"London 12º"];
    NSMutableAttributedString *description = [WeatherDescriptionBuilder updateString:iString withDescriptionFromModel:model];
    XCTAssertEqualObjects(description.string, expected, @"Builder should return a string appended with description");
}

- (void)testBuilderShouldAppendDescriptionStringAttributes
{
    // Expectation
    NSRange range = NSMakeRange(11, 6);
    NSMutableAttributedString *expected = [[NSMutableAttributedString alloc] initWithString:@"London 12º\nCloudy"];
    [expected addAttribute:NSFontAttributeName value:DESCRIPTION_FONT range:range];
    
    NSMutableAttributedString *iString = [[NSMutableAttributedString alloc] initWithString:@"London 12º"];
    
    XCTAssertEqualObjects([WeatherDescriptionBuilder updateString:iString withDescriptionFromModel:model], expected, @"Builder should return an attributed string with description");
}

- (void)testBuilderDoesNotAddNewLineIfInputIsEmpty
{
    [WeatherDescriptionBuilder updateString:inputString withDescriptionFromModel:model];
    XCTAssertEqualObjects(inputString.string, @"Cloudy", @"Builder should not add a new line if input is empty");
}

- (void)testBuilderDoesNotAppendDescriptionIfNil
{
    NSMutableAttributedString *expected = [[NSMutableAttributedString alloc] initWithString:@"London 12º"];
    model.weatherDescription = nil;
    XCTAssertEqualObjects([WeatherDescriptionBuilder updateString:expected withDescriptionFromModel:model], expected, @"Builder should not append description if nil");
}

@end
