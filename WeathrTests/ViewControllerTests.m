//
//  ViewControllerTests.m
//  WeathrTests
//
//  Created by Paul Williamson on 17/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController.h"
#import "ViewController+PrivateMethods.h"
#import "WeatherModel.h"
#import "OpenWeatherAPIManager.h"
#import <CoreLocation/CoreLocation.h>

#import "JMRMockAlertView/JMRMockAlertView.h"
#import "JMRMockAlertView/JMRMockAlertViewVerifier.h"

#import <OCMock/OCMock.h>

@interface ViewControllerTests : XCTestCase {
    CLLocation *fakeLocation;
}

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
    
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(0.0f, 0.0f);
    fakeLocation = [[CLLocation alloc] initWithCoordinate:coords altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:[NSDate date]];
    
}

- (void)tearDown
{
    _sut = nil;
    [super tearDown];
}

#pragma mark - Test helper
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
    XCTAssertNotNil(_sut.weatherIcon, @"View should have a weather icon image view");
}

- (void)testWeatherDescriptionLabelShouldBeConnected
{
    XCTAssertNotNil(_sut.weatherDescription, @"View should have a weather description label");
}

- (void)testWeatherDescriptionLabelIsMultiline
{
    XCTAssertTrue(_sut.weatherDescription.numberOfLines == 0, @"Weather description label should be multi-line");
}

- (void)testLastUpdatedLabelShouldBeConnected
{
    XCTAssertNotNil(_sut.lastUpdatedLabel, @"View should have a last updated label");
}

- (void)testActivityIndicatorShouldBeConnected
{
    XCTAssertNotNil(_sut.activityIndicator, @"View should have an activity indicator");
}

- (void)testViewBackgroundShouldDefaultToWarmColour
{
    XCTAssertEqualObjects(_sut.view.backgroundColor, COLOUR_WARM, @"View background should default to warm colour");
}

- (void)testDefaultAlertViewClass
{
    XCTAssertEqual(_sut.alertViewClass, [UIAlertView class], @"Controller should set the default alert view class");
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
    
    XCTAssertEqualObjects(_sut.weatherDescription.text, description.string, @"Weather description should be updated");
}

- (void)testLastUpdatedLabelCanBeUpdated
{
    NSString *testCase = @"24/10/2013 14:30:23";
    NSString *expectedResult = [NSString stringWithFormat:@"Last updated: %@", testCase];
    
    [_sut updateLastUpdatedLabel: testCase];
    
    XCTAssertEqualObjects(_sut.lastUpdatedLabel.text, expectedResult, @"Last updated label should be updated");
}

- (void)testViewBackgroundColourCanBeChangedFromTemperature
{
    [_sut pickAndUpdateViewBackgroundColorWithTemperature:@5];
    XCTAssertEqualObjects(_sut.view.backgroundColor, COLOUR_COLD, @"Background colour should be updated");
}

#pragma mark - Colour choosing
- (void)testControllerShouldChooseColdColourBasedOnTemperature
{
    UIColor *testCase = [_sut pickColourUsingTemperature: [NSNumber numberWithFloat:8.0]];
    XCTAssertEqualObjects(testCase, COLOUR_COLD, @"View background colour should be cold colour");
}

- (void)testControllerShouldChooseCoolColourBasedOnTemperature
{
    UIColor *testCase = [_sut pickColourUsingTemperature: [NSNumber numberWithFloat:10.0]];
    XCTAssertEqualObjects(testCase, COLOUR_COOL, @"View background colour should be cool colour");
}

- (void)testControllerShouldChooseWarmColourBasedOnTemperature
{
    UIColor *testCase = [_sut pickColourUsingTemperature: [NSNumber numberWithFloat:20.0]];
    XCTAssertEqualObjects(testCase, COLOUR_WARM, @"View background colour should be warm colour");
}

- (void)testControllerShouldChooseHotColourBasedOnTemperature
{
    UIColor *testCase = [_sut pickColourUsingTemperature: [NSNumber numberWithFloat:30.0]];
    XCTAssertEqualObjects(testCase, COLOUR_HOT, @"View background colour should be hot colour");
}

#pragma mark - Activity indicator
- (void)testActivityIndicatorShouldBeInitiallyHidden
{
    XCTAssertTrue(_sut.activityIndicator.hidden, @"Activity indicator should be initially hidden");
}

- (void)testActivityIndicatorCanBeShown
{
    [_sut startActivityIndicator];
    XCTAssertTrue(!_sut.activityIndicator.hidden, @"Activity indicator should be shown");
}

- (void)testActivityIndicatorShouldBeAnimatedWhenShown
{
    [_sut startActivityIndicator];
    XCTAssertTrue(_sut.activityIndicator.isAnimating, @"Activity indicator should be animating when shown");
}

- (void)testActivityIndicatorCanBeHidden
{
    [_sut.activityIndicator startAnimating];
    [_sut stopActivityIndicator];
    XCTAssertTrue(_sut.activityIndicator.hidden, @"Activity indicator should be hidden");
}

- (void)testActivityIndicatorShouldNotBeAnimatedWhenHidden
{
    [_sut.activityIndicator startAnimating];
    [_sut stopActivityIndicator];
    XCTAssertTrue(!_sut.activityIndicator.isAnimating, @"Activity indicator should be not animating when hidden");
}

- (void)testActivityIndicatorIsStartedAsViewAppears
{
    [_sut viewDidAppear:NO];
    XCTAssertTrue(_sut.activityIndicator.isAnimating, @"Activity indicator should be started when view loads");
}

- (void)testActivityIndicatorStopsWhenViewRefreshed
{
    _sut.weatherModel = nil;
    [_sut reloadView];
    XCTAssertTrue(!_sut.activityIndicator.isAnimating, @"Activity indicator should be stopped when view is reloaded");
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
    XCTAssertTrue([_sut respondsToSelector:@selector(weatherModelUpdated)], @"View controller should implement weatherModelUpdated delegate method");
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

- (void)testControllerShowsAlertOnFailedDataTaskWithUnknownError
{
    _sut.alertViewClass = [JMRMockAlertView class];
    JMRMockAlertViewVerifier *alertVerifier = [[JMRMockAlertViewVerifier alloc] init];
    
    
    [_sut dataTaskFailWithHTTPURLResponse:nil];
    
    XCTAssertEqual(alertVerifier.showCount, 1U, @"Download failed alert should be shown");
    XCTAssertEqualObjects(alertVerifier.title, @"Error downloading weather", @"Download failed alert title should be set");
    XCTAssertEqualObjects(alertVerifier.message, @"Please check your network connection, and ensure your device is not in airplane mode", @"Download failed alert message should be set");
    XCTAssertNil(alertVerifier.delegate, @"No delegate needed");
    XCTAssertTrue(alertVerifier.otherButtonTitles.count == 0U,  @"Download failed alert other titles should be nil");
    XCTAssertEqualObjects(alertVerifier.cancelButtonTitle, @"OK", @"Download failed alert cancel button should be nil");
}

- (void)testControllerShowsAlertOnFailedDataTaskWithErrorCode
{
    _sut.alertViewClass = [JMRMockAlertView class];
    JMRMockAlertViewVerifier *alertVerifier = [[JMRMockAlertViewVerifier alloc] init];
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:nil statusCode:404 HTTPVersion:nil headerFields:nil];
    
    [_sut dataTaskFailWithHTTPURLResponse:response];
    
    XCTAssertEqual(alertVerifier.showCount, 1U, @"Download failed alert should be shown");
    XCTAssertEqualObjects(alertVerifier.title, @"Error downloading weather", @"Download failed alert title should be set");
    XCTAssertEqualObjects(alertVerifier.message, @"The server returned an error, please try again later", @"Download failed alert message should be set");
    XCTAssertNil(alertVerifier.delegate, @"No delegate needed");
    XCTAssertTrue(alertVerifier.otherButtonTitles.count == 0U,  @"Download failed alert other titles should be nil");
    XCTAssertEqualObjects(alertVerifier.cancelButtonTitle, @"OK", @"Download failed alert cancel button should be nil");
}

- (void)testControllerShowsAlertWhenDataTaskReturnsNil
{
    _sut.alertViewClass = [JMRMockAlertView class];
    JMRMockAlertViewVerifier *alertVerifier = [[JMRMockAlertViewVerifier alloc] init];
    
    [_sut dataTaskSuccessWithData:nil];
    
    XCTAssertEqual(alertVerifier.showCount, 1U, @"Download failed alert should be shown");
    XCTAssertEqualObjects(alertVerifier.title, @"Error downloading weather", @"Download failed alert title should be set");
    XCTAssertEqualObjects(alertVerifier.message, @"Please check your network connection, and ensure your device is not in airplane mode", @"Download failed alert message should be set");
    XCTAssertNil(alertVerifier.delegate, @"No delegate needed");
    XCTAssertTrue(alertVerifier.otherButtonTitles.count == 0U,  @"Download failed alert other titles should be nil");
    XCTAssertEqualObjects(alertVerifier.cancelButtonTitle, @"OK", @"Download failed alert cancel button should be nil");
}

- (void)testControllerResetsUIOnDataTaskFailure
{
    _sut.lastUpdatedLabel.text = @"Test string";
    NSAttributedString *aString = [[NSAttributedString alloc] initWithString:@"Weather description"];
    _sut.weatherDescription.attributedText = aString;
    _sut.refreshButton.hidden = YES;
    
    [_sut dataTaskFailWithHTTPURLResponse:nil];
    
    XCTAssertEqualObjects(_sut.lastUpdatedLabel.text, @"Error fetching weather report", @"Last updated label should be updated");
    XCTAssertNil(_sut.weatherDescription.attributedText, @"Weather description label text should be cleared");
    XCTAssertTrue(!_sut.refreshButton.hidden, @"Refresh button should be shown");
}

- (void)testControllerCallsModelUpdateWhenDataTaskReturnsData
{
    id model = [OCMockObject mockForClass:[WeatherModel class]];
    _sut.weatherModel = model;
    [[model expect] updateWeatherModelFromNSData:[OCMArg any]];
    
    [_sut dataTaskSuccessWithData:[NSData data]];
    
    [model verify];
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

- (void)testLocationErrorShowsAlertAndStopsLocationManager
{
    _sut.alertViewClass = [JMRMockAlertView class];
    JMRMockAlertViewVerifier *alertVerifier = [[JMRMockAlertViewVerifier alloc] init];
    
    id locationManager = [OCMockObject mockForClass:[CLLocationManager class]];
    _sut.locationManager = locationManager;
    [[locationManager expect] stopUpdatingLocation];
    
    [_sut locationManager:nil didFailWithError:nil];
    
    XCTAssertEqual(alertVerifier.showCount, 1U, @"Location failed alert should be shown");
    [locationManager verify];
}

- (void)testControllerWillStopLocationManagerWithRecentResults
{
    _sut.appStartDate = [NSDate distantPast];
    
    XCTAssertTrue([_sut shouldStopUpdatingLocation:fakeLocation], @"Controller should return yes to should stop updating location");
}

- (void)testControllerWillNotStopLocationWithStaleResults
{
    _sut.appStartDate = [NSDate distantFuture];
    
    XCTAssertTrue(![_sut shouldStopUpdatingLocation:fakeLocation], @"Controller should return no to should stop updating location");
}

- (void)testControllerShowsAlertOnFailedLocationLookupWithNetworkUnavailable
{
    _sut.alertViewClass = [JMRMockAlertView class];
    JMRMockAlertViewVerifier *alertVerifier = [[JMRMockAlertViewVerifier alloc] init];
    NSError *error = [[NSError alloc] initWithDomain:kCLErrorDomain
                                                code:kCLErrorNetwork
                                            userInfo:nil];
    
    [_sut locationUpdateFailed:error];
    
    XCTAssertEqual(alertVerifier.showCount, 1U, @"Location failed alert should be shown");
    XCTAssertEqualObjects(alertVerifier.title, @"Error fetching location", @"Loction failed alert title should be set");
    XCTAssertEqualObjects(alertVerifier.message, @"Please check your network connection, and ensure your device is not in airplane mode", @"Loction failed alert message should be set");
    XCTAssertNil(alertVerifier.delegate, @"Location failed alert doesn't need a delegate, as we are only using cancel");
    XCTAssertTrue(alertVerifier.otherButtonTitles.count == 0U,  @"Loction failed alert other titles should be nil");
    XCTAssertEqualObjects(alertVerifier.cancelButtonTitle, @"OK", @"Loction failed alert cancel button should be nil");
}

- (void)testControllerShowsAlertOnFailedLocationLookupWithLocationDenied
{
    _sut.alertViewClass = [JMRMockAlertView class];
    JMRMockAlertViewVerifier *alertVerifier = [[JMRMockAlertViewVerifier alloc] init];
    NSError *error = [[NSError alloc] initWithDomain:kCLErrorDomain
                                                code:kCLErrorDenied
                                            userInfo:nil];
    
    [_sut locationUpdateFailed:error];
    
    XCTAssertEqual(alertVerifier.showCount, 1U, @"Location failed alert should be shown");
    XCTAssertEqualObjects(alertVerifier.title, @"Error fetching location", @"Loction failed alert title should be set");
    XCTAssertEqualObjects(alertVerifier.message, @"Please ensure location services is enabled for Weathr");
    XCTAssertNil(alertVerifier.delegate, @"Location failed alert doesn't need a delegate, as we are only using cancel");
    XCTAssertTrue(alertVerifier.otherButtonTitles.count == 0U,  @"Loction failed alert other titles should be nil");
    XCTAssertEqualObjects(alertVerifier.cancelButtonTitle, @"OK", @"Loction failed alert cancel button should be nil");
}

- (void)testControllerShowsAlertOnFailedLocationLookupWithUnknownError
{
    _sut.alertViewClass = [JMRMockAlertView class];
    JMRMockAlertViewVerifier *alertVerifier = [[JMRMockAlertViewVerifier alloc] init];
    NSError *error = [[NSError alloc] initWithDomain:kCLErrorDomain
                                                code:kCLErrorLocationUnknown
                                            userInfo:nil];
    
    [_sut locationUpdateFailed:error];
    
    XCTAssertEqual(alertVerifier.showCount, 1U, @"Location failed alert should be shown");
    XCTAssertEqualObjects(alertVerifier.title, @"Error fetching location", @"Loction failed alert title should be set");
    XCTAssertEqualObjects(alertVerifier.message, @"Please try again later");
    XCTAssertNil(alertVerifier.delegate, @"Location failed alert doesn't need a delegate, as we are only using cancel");
    XCTAssertTrue(alertVerifier.otherButtonTitles.count == 0U,  @"Loction failed alert other titles should be nil");
    XCTAssertEqualObjects(alertVerifier.cancelButtonTitle, @"OK", @"Loction failed alert cancel button should be nil");
}

#pragma mark - Refresh button

- (void)testViewShouldHaveARefreshButton
{
    XCTAssertNotNil(_sut.refreshButton, @"View should have a refresh button");
}

- (void)testRefreshButtonShouldBeHiddenInitially
{
    XCTAssertTrue(_sut.refreshButton.hidden, @"Refresh button should be initially hidden");
}

- (void)testRefreshButtonShouldNotAdjustWhenHighlighted
{
    XCTAssertTrue(!_sut.refreshButton.adjustsImageWhenHighlighted, @"Refresh button should not adjust when highlighted");
}

- (void)testRefreshButtonTriggersDownloadData
{
    NSArray *actions = [_sut.refreshButton actionsForTarget:_sut forControlEvent:UIControlEventTouchUpInside];
    XCTAssertTrue([actions containsObject:@"refreshButtonTapped:"], @"Refresh button should call refresh button tapped on touch up");
}

- (void)testRefreshButtonCanBeShown
{
    [_sut showRefreshButton];
    XCTAssertTrue(!_sut.refreshButton.hidden, @"Refresh button should be shown.");
}

- (void)testRefreshButtonCanBeHidden
{
    _sut.refreshButton.hidden = NO;
    [_sut hideRefreshButton];
    XCTAssertTrue(_sut.refreshButton.hidden, @"Refresh button should be hidden.");
}

#pragma mark - Refresh button actions

- (void)testRefreshButtonFetchesLocationIfModelLocationEmpty
{
    id locationManager = [OCMockObject mockForClass:[CLLocationManager class]];
    _sut.locationManager = locationManager;
    _sut.weatherModel.location = nil;
    [[locationManager expect] startMonitoringSignificantLocationChanges];
    
    [_sut refreshButtonTapped:nil];

    [locationManager verify];
}

- (void)testRefreshButtonFetchesWeatherIfModelLocationExists
{
    id apiManager = [OCMockObject mockForClass:[OpenWeatherAPIManager class]];
    _sut.apiManager = apiManager;
    WeatherModel *model = [[WeatherModel alloc] init];
    CLLocation *location = [[CLLocation alloc] initWithLatitude:0.0 longitude:0.0];
    model.location = location;
    _sut.weatherModel = model;
    
    [[apiManager expect] updateURLWithLocation:location];
    [[apiManager expect] fetchWeatherData];
    
    [_sut refreshButtonTapped:nil];
    
    [apiManager verify];
}

- (void)testRefreshButtonTappedHidesRefreshButton
{
    _sut.refreshButton.hidden = NO;
    
    [_sut refreshButtonTapped:nil];
    
    XCTAssertTrue(_sut.refreshButton.hidden, @"Refresh button should be hidden after tapping");
}

@end
