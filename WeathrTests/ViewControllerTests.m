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

- (void)setUp
{
    [super setUp];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:[self returnStoryboardName]
                                                             bundle:nil];
    _sut = (ViewController *)[mainStoryboard instantiateInitialViewController];
    XCTAssertNotNil(_sut, @"ViewController should not be nil for storyboard %@", [self returnStoryboardName]);
    [_sut view];
    [_sut viewDidLoad];
}

- (void)tearDown
{
    _sut = nil;
    [super tearDown];
}

- (NSString *)returnStoryboardName
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        return @"Main_iPhone";
    else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        return @"Main_iPad";
    else
        return nil;
}

#pragma mark - View setup
- (void)testWeatherIconImageViewShouldBeConnected
{
    XCTAssertNotNil(_sut.weatherIcon, @"Weather icon image view should be in view");
}

- (void)testWeatherDescriptionLabelShouldBeConnected
{
    XCTAssertNotNil(_sut.weatherDescription, @"Weather description label should be in view");
}

- (void)testLastUpdatedLabelShouldBeConnected
{
    XCTAssertNotNil(_sut.lastUpdatedLabel, @"Last updated label should be in view");
}

- (void)testViewBackgroundShouldDefaultToWarmColour
{
    XCTAssertEqualObjects(_sut.view.backgroundColor, COLOUR_WARM, @"View background should default to warm colour");
}

#pragma mark - View updates
- (void)testWeatherIconCanBeUpdated
{
    [_sut loadImageNamed:@"01d"];
    
    XCTAssertEqual(_sut.weatherIcon.image, [UIImage imageNamed:@"01d"], @"Weather icon should be updated");
}

- (void)testWeatherDescriptionLabelCanBeUpdated
{
    NSAttributedString *description = [[NSAttributedString alloc] initWithString:@"Mostly cloudy"];
    [_sut updateWeatherDescription: description];
    
    XCTAssertEqualObjects(_sut.weatherDescription.text, description.string, @"Weather description text should have changed");
}

- (void)testLastUpdatedCanBeUpdated
{
    NSString *testCase = @"24/10/2013 14:30:23";
    [_sut updateLastUpdatedLabel: testCase];
    
    NSString *testAssertion = [NSString stringWithFormat:@"Last updated: %@", testCase];
    XCTAssertEqualObjects(_sut.lastUpdatedLabel.text, testAssertion, @"Last updated label should have changed");
}

- (void)testViewBackgroundColourCanBeChanged
{
    _sut.view.backgroundColor = COLOUR_COLD;
    [_sut updateViewBackgroundColour: COLOUR_HOT];
    XCTAssertEqualObjects(_sut.view.backgroundColor, COLOUR_HOT, @"Backgound colour not updated");
}

#pragma mark - Colour choosing
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

#pragma mark - Weather model instantiation
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

#pragma mark - Core location
- (void)testControllerInstantiatesLocationManager
{
    XCTAssertNotNil(_sut.locationManager, @"View controller should have a location manager");
}

- (void)testControllerSetsLocationManagerDelegateToSelf
{
    XCTAssertNotNil(_sut.locationManager.delegate, @"View controller should be location manager delegate");
}

- (void)testControllerImplementsDidUpdateToLocation
{
    XCTAssertTrue([_sut respondsToSelector:@selector(locationManager:didUpdateToLocation:fromLocation:)], @"Controller should implement locationManager:didUpdateToLocation:fromLocation delegate method");
}

- (void)testControllerImplementsDidFailWithError
{
    XCTAssertTrue([_sut respondsToSelector:@selector(locationManager:didFailWithError:)], @"Controller should implement locationManager:didFailWithError: delegate method");
}

@end
