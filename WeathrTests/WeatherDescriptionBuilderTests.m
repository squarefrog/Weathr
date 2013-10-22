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
}

- (void)tearDown
{
    model = nil;
    [super tearDown];
}

#pragma mark - Getters
- (void)testModelReturnsDetailedWeatherDescriptionAsAttributedString
{
    id description = [WeatherDescriptionBuilder detailedWeatherDescriptionFromModel:model];
    XCTAssertTrue([[description class] isSubclassOfClass:[NSAttributedString class]], @"Description should be an attributed string");
}

- (void)testModelReturnsDetailedWeatherDescriptionStringText
{
    NSString *expectedAnswer = @"London 12º\nCloudy";
    XCTAssertEqualObjects([[WeatherDescriptionBuilder detailedWeatherDescriptionFromModel:model] string], expectedAnswer, @"Model should return a detailed weather description string");
}

- (void)testModelReturnsDetailedWeatherDescriptionStringTextWithMinusTemperature
{
    model.temperature = [NSNumber numberWithFloat:268.15];
    NSString *expectedAnswer = @"London -5º\nCloudy";
    XCTAssertEqualObjects([[WeatherDescriptionBuilder detailedWeatherDescriptionFromModel:model] string], expectedAnswer, @"Model should return a detailed weather description string");
}

#pragma mark - Location name
- (void)testBuilderShouldCreateLocationNameString
{
    NSMutableAttributedString *inputString = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *tString = [WeatherDescriptionBuilder updateString:inputString withLocationNameFromModel:model];
    XCTAssertEqualObjects(tString.string, locationName.string, @"Builder should return a string for model location");
}

- (void)testBuilderShouldSetAttributesForLocationNameString
{
    NSMutableAttributedString *inputString = [[NSMutableAttributedString alloc] init];
    NSMutableAttributedString *tString = [WeatherDescriptionBuilder updateString:inputString withLocationNameFromModel:model];
    XCTAssertEqualObjects(tString, locationName, @"Builder should set attributes for location name");
}

- (void)testBuilderShouldSetNilForNilLocationNameString
{
    NSMutableAttributedString *inputString = [[NSMutableAttributedString alloc] init];
    XCTAssertEqualObjects([WeatherDescriptionBuilder updateString:inputString withTemperatureFromModel:nil], inputString, @"Builder should return a nil object when given nil model");
}

#pragma mark - Temperature
- (void)testBuilderShouldAppendTemperatureString
{
    NSString *expected = @"London 12º";
    NSMutableAttributedString *inputString = [[NSMutableAttributedString alloc] initWithString:@"London"];
    NSMutableAttributedString *temperature = [WeatherDescriptionBuilder updateString:inputString withTemperatureFromModel:model];
    XCTAssertEqualObjects(temperature.string, expected, @"Builder should return a string appended with temperature");
}

- (void)testBuilderShouldReturnTemperatureStringWithBlankInput
{
    NSMutableAttributedString *inputString = [[NSMutableAttributedString alloc] init];
    NSString *expected = @"12º";
    NSMutableAttributedString *temperature = [WeatherDescriptionBuilder updateString:inputString withTemperatureFromModel:model];
    XCTAssertEqualObjects(temperature.string, expected, @"Builder should return a string with temperature");
}

@end
