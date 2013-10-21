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
#import "OpenWeatherAPIManager+PrivateMethods.h"
#import "InspectableOpenWeatherAPIManager.h"
#import <CoreLocation/CoreLocation.h>

@interface OpenWeatherAPIManagerTests : XCTestCase <OpenWeatherAPIManagerDelegate>
{
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
    _url = @"http://api.openweathermap.org/data/2.5/weather?lat=51.5072&lon=0.1275";
    _location = [[CLLocation alloc] initWithLatitude:51.5072 longitude:0.1275];
    _manager = [[InspectableOpenWeatherAPIManager alloc] init];
    _manager.delegate = self;
}

- (void)tearDown
{
    _url = nil;
    _location = nil;
    _manager = nil;
    _manager.delegate = nil;
    [super tearDown];
}

#pragma mark - Instantiation
- (void)testLocationCanInitialised
{
    XCTAssertNotNil(_manager, @"Instantiated OpenWeatherAPIManager should not be nil");
}

- (void)testAPIManagerShouldUseSharedSession
{
    XCTAssertEqualObjects(_manager.session, [NSURLSession sharedSession], @"Manager should be using the shared session");
}

#pragma mark - URL handling
- (void)testAPIURLCanBeSetWithLocation
{
    [_manager updateURLWithLocation:_location];
    NSURL *returnedURL = [_manager URLToFetch];
    XCTAssertEqualObjects([returnedURL absoluteString], _url, @"API url should be set");
}

- (void)testURLShouldNotBeSetWithNilLocation
{
    [_manager updateURLWithLocation:nil];
    XCTAssertNil([_manager URLToFetch], @"Manager url should not be set when passed a nil object");
}

#pragma mark - Data transfer
- (void)testTaskCanBeCreated
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:nil];
    NSURLSessionTask *task = [_manager createTaskWithURLRequest:urlRequest];
    XCTAssertNotNil(task, @"Task should be created");
}

- (void)testTaskShouldNotBeCreatedWithNoURLRequest
{
    XCTAssertNil([_manager createTaskWithURLRequest:nil], @"Task should not be created when url request is nil");
}

#pragma mark - Delegates
- (void)testDataTaskFinishedWithSuccessDelegateMethodCalled
{
    [_manager tellDelegateDataTaskSucceededWithData:nil];
    XCTAssertTrue(successCallbackInvoked, @"Success callback should be called");
}

- (void)testDataTaskFinishedWithFailureDelegateMethodCalled
{
    [_manager tellDelegateDataTaskFailedWithHTTPURLResponse:nil];
    XCTAssertTrue(failureCallbackInvoked, @"Failure callback should be called");
}

#pragma mark - Test helpers
- (void)dataTaskSuccessWithData:(NSData *)data
{
    successCallbackInvoked = YES;
}

- (void)dataTaskFailWithHTTPURLResponse:(NSHTTPURLResponse *)response
{
    failureCallbackInvoked = YES;
}

@end
