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

@interface OpenWeatherAPIManagerTests : XCTestCase
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) InspectableOpenWeatherAPIManager *manager;
@property (nonatomic, strong) NSMutableArray *notifications;
@end

@implementation OpenWeatherAPIManagerTests

- (void)setUp
{
    [super setUp];
    _url = @"http://api.openweathermap.org/data/2.5/weather?";
    _location = [[CLLocation alloc] initWithLatitude:51.5072 longitude:0.1275];
    _manager = [[InspectableOpenWeatherAPIManager alloc] initWithLocation:_location];
    _notifications = [[NSMutableArray alloc] init];
    XCTAssertNotNil(_manager, @"Instantiated OpenWeatherAPIManager should not be nil");
}

- (void)tearDown
{
    _url = nil;
    _location = nil;
    _manager = nil;
    _notifications = nil;
    [super tearDown];
}

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

#pragma mark - Notifications
- (void)testAPIManagerCanPostNotification
{
    NSString *name = @"TestKey";
    [[NSNotificationCenter defaultCenter] addObserver:_notifications
                                             selector:@selector(addObject:)
                                                 name:name
                                               object:nil];
    NSNotification *notification = [NSNotification notificationWithName:name object:nil];
    
    [_manager postNotification:notification];
    
    XCTAssertTrue(_notifications.count == 1, @"Notification should be sent");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)testAPIManagerCanPostNotificationWithSuccess
{
    [[NSNotificationCenter defaultCenter] addObserver:_notifications
                                             selector:@selector(addObject:)
                                                 name:OpenWeatherAPIManagerTaskFinishedWithSuccess
                                               object:nil];
    
    [_manager postSuccessNotificationWithResponse:nil];
    
    XCTAssertTrue(_notifications.count == 1, @"Success notification should be sent");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)testAPIManagerCanPostNotificationWithFailure
{
    [[NSNotificationCenter defaultCenter] addObserver:_notifications
                                             selector:@selector(addObject:)
                                                 name:OpenWeatherAPIManagerTaskFinishedWithFailure
                                               object:nil];
    
    [_manager postFailureNotificationWithResponse:nil];
    
    XCTAssertTrue(_notifications.count == 1, @"Failure notification should be sent");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
