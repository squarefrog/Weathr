//
//  OpenWeatherAPIManagerTests.m
//  Weathr
//
//  Created by Paul Williamson on 18/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Foundation/Foundation.h>
#import "OpenWeatherAPIManager.h"
#import "InspectableOpenWeatherAPIManager.h"
#import <CoreLocation/CoreLocation.h>

@interface OpenWeatherAPIManagerTests : XCTestCase <OpenWeatherAPIManagerDelegate> {
    BOOL successCallbackInvoked;
    BOOL failureCallbackInvoked;
}
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) InspectableOpenWeatherAPIManager *manager;
@end

@implementation OpenWeatherAPIManagerTests

- (void)setUp
{
    [super setUp];
    _url = @"http://api.openweathermap.org/data/2.5/weather?";
    _location = [[CLLocation alloc] initWithLatitude:51.5072 longitude:0.1275];
    _manager = [[InspectableOpenWeatherAPIManager alloc] initWithLocation:_location];
    XCTAssertNotNil(_manager, @"Instantiated OpenWeatherAPIManager should not be nil");
}

- (void)tearDown
{
    _url = nil;
    _location = nil;
    _manager = nil;
    [super tearDown];
}

#pragma mark - URL handling
- (void)testAPIURLIsCorrect
{
    XCTAssertEqualObjects(OpenWeatherMapAPIUrl, _url, @"Open weather map API url not correct");
}

- (void)testAPIURLCanHaveLocationInjected {
    NSString *urlString = [NSString stringWithFormat:@"%@lat=%f&lon=%f", _url, _location.coordinate.latitude, _location.coordinate.longitude];
    [_manager updateURLWithLocation:_location];
    NSURL *returnedURL = [_manager URLToFetch];
    XCTAssertEqualObjects([returnedURL absoluteString], urlString, @"Open weather map API url not modified correctly");
}

- (void)testLocationCanBePassedDuringInit
{
    XCTAssertNotNil([_manager URLToFetch], @"Instantiated OpenWeatherAPIManager should have a url");
}

#pragma mark - Delegates
- (void)testDataTaskFinishedWithSuccessDelegateMethodCalled
{
    _manager.delegate = self;
    [_manager tellDelegateDataTaskSucceededWithData:nil];
    XCTAssertTrue(successCallbackInvoked, @"Success callback should be called");
    _manager.delegate = nil;
}

- (void)dataTaskSuccessWithData:(NSData *)data
{
    successCallbackInvoked = YES;
}

- (void)testDataTaskFinishedWithFailureDelegateMethodCalled
{
    _manager.delegate = self;
    [_manager tellDelegateDataTaskFailedWithHTTPURLResponse:nil];
    XCTAssertTrue(failureCallbackInvoked, @"Failure callback should be called");
    _manager.delegate = nil;
}

- (void)dataTaskFailWithHTTPURLResponse:(NSHTTPURLResponse *)response
{
    failureCallbackInvoked = YES;
}

@end
