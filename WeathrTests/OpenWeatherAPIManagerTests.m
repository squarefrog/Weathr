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
#import "OpenWeatherAPIManager+Protected.h"
#import <CoreLocation/CoreLocation.h>

@interface OpenWeatherAPIManagerTests : XCTestCase
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) OpenWeatherAPIManager *manager;
@end

@implementation OpenWeatherAPIManagerTests

- (void)setUp
{
    [super setUp];
    _url = @"http://api.openweathermap.org/data/2.5/weather?";
    _manager = [[OpenWeatherAPIManager alloc] init];
    XCTAssertNotNil(_manager, @"Instantiated OpenWeatherAPIManager should not be nil");
}

- (void)tearDown
{
    _url = nil;
    _manager = nil;
    [super tearDown];
}

- (void)testAPIURLIsCorrect
{
    XCTAssertEqualObjects(OpenWeatherMapAPIUrl, _url, @"Open weather map API url not correct");
}

- (void)testAPIURLCanHaveLocationInjected {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:51.5072 longitude:0.1275];
    NSString *urlString = [NSString stringWithFormat:@"%@lat=%f&lon=%f", _url, location.coordinate.latitude, location.coordinate.longitude];
    [_manager updateURLWithLocation:location];
    NSURL *returnedURL = _manager.fetchingURL;
    XCTAssertEqualObjects([returnedURL absoluteString], urlString, @"Open weather map API url not modified correctly");
}

@end
