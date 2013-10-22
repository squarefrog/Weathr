//
//  WeatherDescriptionBuilderTests.m
//  Weathr
//
//  Created by Paul Williamson on 22/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WeatherDescriptionBuilder.h"
#import "WeatherModel.h"

@interface WeatherDescriptionBuilderTests : XCTestCase {
    WeatherModel *model;
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

@end
