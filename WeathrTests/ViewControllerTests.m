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

#pragma mark - Methods

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

@end
