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

@property (nonatomic, weak) ViewController *vc;
@property (nonatomic, copy) NSString *storyboardName;

@end

@implementation ViewControllerTests

- (void)setUp
{
    [super setUp];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        _storyboardName = @"Main_iPhone";
    else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        _storyboardName = @"Main_iPad";
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:_storyboardName bundle:nil];
    _vc = (ViewController *)[mainStoryboard instantiateInitialViewController];
    [self.vc performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    
    XCTAssertNotNil(_vc, @"ViewController should not be nil for storyboard %@", _storyboardName);
}

- (void)tearDown
{
    [super tearDown];
}

#pragma mark - Test UI is complete
- (void)testViewHasWeatherIcon
{
    XCTAssertTrue([_vc.weatherIcon isDescendantOfView:_vc.view], @"weatherIcon outlet should be present for %@", _storyboardName);
}

- (void)testViewHasWeatherDescriptionLabel
{
    XCTAssertTrue([_vc.weatherDescription isDescendantOfView:_vc.view], @"weatherDescription outlet should be present for %@", _storyboardName);
}

- (void)testViewHasLastUpdatedLabel
{
    XCTAssertTrue([_vc.lastUpdatedLabel isDescendantOfView:_vc.view], @"lastUpdated outlet should be present for %@", _storyboardName);
}

@end
