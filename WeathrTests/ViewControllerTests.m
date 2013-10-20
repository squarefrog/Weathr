//
//  ViewControllerTests.m
//  WeathrTests
//
//  Created by Paul Williamson on 17/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "ViewController+Protected.h"
#import "WeatherModel.h"
#import "OpenWeatherAPIManager.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewControllerTests : XCTestCase

@property (nonatomic, weak) ViewController *sut;

@end

@implementation ViewControllerTests

- (NSString *)returnStoryboardName
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        return @"Main_iPhone";
    else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return @"Main_iPad";
    else
        return nil;
}

- (void)setUp
{
    [super setUp];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self returnStoryboardName]
                                                             bundle:nil];
    _sut = (ViewController *)[mainStoryboard instantiateInitialViewController];
    XCTAssertNotNil(_sut, @"ViewController should not be nil for storyboard %@", [self returnStoryboardName]);
    [_sut viewDidLoad];
}

- (void)tearDown
{
    _sut = nil;
    [super tearDown];
}

#pragma mark - Test UI is complete
- (void)testWeatherIconImageViewShouldBeConnected
{
    [_sut view];
    XCTAssertNotNil(_sut.weatherIcon, @"Weather icon image view should not be nil");
}

- (void)testWeatherDescriptionLabelShouldBeConnected
{
    [_sut view];
    XCTAssertNotNil(_sut.weatherDescription, @"Weather description label should not be nil");
}

- (void)testLastUpdatedLabelShouldBeConnected
{
    [_sut view];
    XCTAssertNotNil(_sut.lastUpdatedLabel, @"Last updated label should not be nil");
}

#pragma mark - Outlet updates

- (void)testWeatherIconCanBeUpdated {
    [_sut view];
    
    [_sut loadImageNamed:@"01d"];
    
    XCTAssertEqual(_sut.weatherIcon.image, [UIImage imageNamed:@"01d"], @"Weather icon should be updated");
}

- (void)testWeatherDescriptionLabelCanBeUpdated {
    [_sut view];
    NSString *testCase = @"Mostly cloudy";
    [_sut updateWeatherDescription: testCase];
    
    XCTAssertEqualObjects(_sut.weatherDescription.text, testCase, @"Weather description text should be %@, got %@", testCase, _sut.weatherDescription.text);
}

- (void)testLastUpdatedCanBeUpdated {
    [_sut view];
    NSString *testCase = @"24/10/2013 14:30:23";
    [_sut updateLastUpdatedLabel: testCase];
    
    NSString *testAssertion = [NSString stringWithFormat:@"Last updated: %@", testCase];
    XCTAssertEqualObjects(_sut.lastUpdatedLabel.text, testAssertion, @"Weather description text should be %@, got %@", testCase, _sut.weatherDescription.text);
}

#pragma mark - UI updates

- (void)testControllerShouldChooseColdColourBasedOnTemperature
{
    UIColor *testCase = [_sut pickColourUsingTemperature: [NSNumber numberWithFloat:8.0]];
    XCTAssertEqualObjects(testCase, COLOUR_COLD, @"Colour should be cold colour");
}

- (void)testControllerShouldChooseCoolColourBasedOnTemperature
{
    UIColor *testCase = [_sut pickColourUsingTemperature: [NSNumber numberWithFloat:10.0]];
    XCTAssertEqualObjects(testCase, COLOUR_COOL, @"Colour should be cool colour");
}

- (void)testControllerShouldChooseWarmColourBasedOnTemperature
{
    UIColor *testCase = [_sut pickColourUsingTemperature: [NSNumber numberWithFloat:20.0]];
    XCTAssertEqualObjects(testCase, COLOUR_WARM, @"Colour should be warm colour");
}

- (void)testControllerShouldChooseHotColourBasedOnTemperature
{
    UIColor *testCase = [_sut pickColourUsingTemperature: [NSNumber numberWithFloat:30.0]];
    XCTAssertEqualObjects(testCase, COLOUR_HOT, @"Colour should be hot colour");
}

- (void)testViewBackgroundColourCanBeChanged
{
    _sut.view.backgroundColor = COLOUR_COLD;
    [_sut updateViewBackgroundColour: COLOUR_HOT];
    XCTAssertEqualObjects(_sut.view.backgroundColor, COLOUR_HOT, @"Backgound colour not updated");
}

#pragma mark - Weather instantiation
- (void)testControllerInstantiatesWeatherModel
{
    XCTAssertNotNil(_sut.weatherModel, @"View controller should have a weather model");
}

- (void)testControllerSetsWeatherModelDelegateToSelf
{
    XCTAssertNotNil(_sut.weatherModel.delegate, @"View controller should be a delegate of weather model");
}

- (void)testControllerImplementsWeatherModelDelegateMethods
{
    XCTAssertTrue([_sut respondsToSelector:@selector(weatherModelUpdated)], @"View controller should implement weatherModelUpdated");
}

#pragma mark - API manager instantiation
- (void)testControllerInstantiatesAPIManager
{
    XCTAssertNotNil(_sut.apiManager, @"View controller should have an api manager");
}

- (void)testControllerSetsAPIManagerDelegateToSelf
{
    XCTAssertNotNil(_sut.apiManager.delegate, @"View controller should be a delegate of api manager");
}

- (void)testControllerImplementsAPIManagerSuccessDelegateMethod
{
    XCTAssertTrue([_sut respondsToSelector:@selector(dataTaskSuccessWithData:)], @"View controller should implement dataTaskSuccessWithData:");
}

- (void)testControllerImplementsAPIManagerFailureDelegateMethod
{
    XCTAssertTrue([_sut respondsToSelector:@selector(dataTaskFailWithHTTPURLResponse:)], @"View controller should implement dataTaskFailWithHTTPURLResponse:");
}

#pragma mark - Location manager instantiation
- (void)testControllerInstantiatesLocationManager
{
    XCTAssertNotNil(_sut.locationManager, @"View controller should have a location manager");
}

- (void)testControllerSetsLocationManagerDelegateToSelf
{
    XCTAssertNotNil(_sut.locationManager.delegate, @"View controller should be location manager delegate");
}

@end
