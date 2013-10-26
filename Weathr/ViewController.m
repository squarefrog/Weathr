//
//  ViewController.m
//  Weathr
//
//  Created by Paul Williamson on 17/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import "ViewController.h"
#import "WeatherModel.h"
#import "OpenWeatherAPIManager.h"
#import "WeatherDescriptionBuilder.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

#define ANIMATION_DURATION 1.0f

#define COOL_THRESHOLD   10.0f
#define WARM_THRESHOLD   18.0f
#define HOT_THRESHOLD    27.0f

@interface ViewController () <WeatherModelDelegate,OpenWeatherAPIManagerDelegate,CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *weatherIcon;
@property (nonatomic, weak) IBOutlet UILabel *weatherDescription;
@property (nonatomic, weak) IBOutlet UILabel *lastUpdatedLabel;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) WeatherModel *weatherModel;
@property (nonatomic, strong) OpenWeatherAPIManager *apiManager;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, weak) IBOutlet UIButton *refreshButton;
@property (nonatomic, strong) NSDate *appStartDate;
@property (nonatomic, strong) Class alertViewClass;

@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _alertViewClass = [UIAlertView class];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _weatherModel = [[WeatherModel alloc] init];
    _weatherModel.delegate = self;
    
    _apiManager = [[OpenWeatherAPIManager alloc] init];
    _apiManager.delegate = self;
    
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self fetchLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI Updates
- (void)loadImageNamed: (NSString *)imageName
{
    [_weatherIcon.layer addAnimation:[self animationStyle] forKey:nil];
    _weatherIcon.image = [UIImage imageNamed:imageName];
}

- (void)updateWeatherDescription: (NSAttributedString *)description
{
    [_weatherDescription.layer addAnimation:[self animationStyle] forKey:nil];
    _weatherDescription.attributedText = description;
}

- (void)updateLastUpdatedLabel: (NSString *)lastUpdated
{
    [_lastUpdatedLabel.layer addAnimation:[self animationStyle] forKey:nil];
    _lastUpdatedLabel.text = [NSString stringWithFormat:@"Last updated: %@", lastUpdated];
}

- (CATransition *)animationStyle
{
    CATransition *transition = [CATransition animation];
    transition.duration = ANIMATION_DURATION;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    return transition;
}

- (void)startActivityIndicator
{
    [_activityIndicator startAnimating];
}

- (void)stopActivityIndicator
{
    [_activityIndicator stopAnimating];
}

- (void)reloadView
{
    if (_weatherModel) {
        [self loadImageNamed:_weatherModel.icon];
        NSMutableAttributedString *description = [WeatherDescriptionBuilder detailedWeatherDescriptionFromModel:_weatherModel];
        [self updateWeatherDescription:description];
        [self updateLastUpdatedLabel:[WeatherModel parseDate:_weatherModel.lastUpdated]];
        [self pickAndUpdateViewBackgroundColorWithTemperature:[_weatherModel getTemperatureInCelsius]];
    }
    [self stopActivityIndicator];
}

#pragma mark - Colour Methods
- (void)pickAndUpdateViewBackgroundColorWithTemperature: (NSNumber *)temp
{
    UIColor *colour = [self pickColourUsingTemperature:temp];
    [self updateViewBackgroundColour:colour];
}

- (UIColor *)pickColourUsingTemperature: (NSNumber *)temp
{
    if ([temp floatValue] >= COOL_THRESHOLD && [temp floatValue] < WARM_THRESHOLD)
        return COLOUR_COOL;
    
    else if ([temp floatValue] >= WARM_THRESHOLD && [temp floatValue] < HOT_THRESHOLD)
        return COLOUR_WARM;
    
    else if ([temp floatValue] >= HOT_THRESHOLD)
        return COLOUR_HOT;
    
    return COLOUR_COLD;
}

- (void)updateViewBackgroundColour: (UIColor *)color
{
    [self.view.layer addAnimation:[self animationStyle] forKey:nil];
    self.view.backgroundColor = color;
}

#pragma mark - Alerts
- (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    [[[_alertViewClass alloc] initWithTitle:title
                                    message:message
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
}

#pragma mark - Weather model delegate
- (void)weatherModelUpdated
{
    [self reloadView];
}

#pragma mark - API manager delegate
- (void)downloadWeatherDataWithLocation:(CLLocation *)newLocation
{
    [_apiManager updateURLWithLocation:newLocation];
    [_apiManager fetchWeatherData];
}

- (void)dataTaskSuccessWithData:(NSData *)data
{
    if (data) {
        [_weatherModel updateWeatherModelFromNSData:data];
    } else {
        [self downloadTaskFailed:nil];
    }
}

- (void)dataTaskFailWithHTTPURLResponse:(NSHTTPURLResponse *)response
{
    [self downloadTaskFailed:response];
    [self downloadFailedHandler];
}

- (void)downloadTaskFailed:(NSHTTPURLResponse *)response
{
    [self showAlertWithTitle:@"Error downloading weather"
                     message:[self failedDownloadMessage:response]];
}

- (NSString *)failedDownloadMessage:(NSHTTPURLResponse *)response
{
    if (response) {
        return @"The server returned an error, please try again later";
    }
    else
        return @"Please check your network connection, and ensure your device is not in airplane mode";
}

- (void)downloadFailedHandler
{
    [self resetUIForFailure];
}

- (void)resetUIForFailure
{
    _lastUpdatedLabel.text = @"Error fetching weather report";
    _weatherDescription.attributedText = nil;
    [self showRefreshButton];
}

#pragma mark - Core Location
- (void)fetchLocation
{
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
    {
        [_activityIndicator startAnimating];
        [_locationManager startMonitoringSignificantLocationChanges];
    }
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    if ([self shouldStopUpdatingLocation:newLocation])
        [_locationManager stopUpdatingLocation];
    
    [self downloadWeatherDataWithLocation:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [_locationManager stopUpdatingLocation];
    [self locationUpdateFailed:error];
    [self resetUIForFailure];
}

- (NSString *)humanLocationError:(NSError *)error
{
    switch (error.code) {
        case kCLErrorNetwork:
            return @"Please check your network connection, and ensure your device is not in airplane mode";
            break;
        case kCLErrorDenied:
            return @"Please ensure location services is enabled for Weathr";
            break;
        default:
            return @"Please try again later";
            break;
    }
}

- (void)locationUpdateFailed:(NSError *)error
{
    [self showAlertWithTitle:@"Error fetching location"
                     message:[self humanLocationError:error]];
}

- (BOOL)shouldStopUpdatingLocation:(CLLocation *)location
{
    return [_appStartDate compare:location.timestamp] == NSOrderedAscending;
}

#pragma mark - Refresh button
- (IBAction)refreshButtonTapped:(id)sender
{
    if (_weatherModel.location) {
        [self downloadWeatherDataWithLocation:_weatherModel.location];
    } else {
        [self fetchLocation];
    }
    [self hideRefreshButton];
}

- (void)showRefreshButton
{
    [_refreshButton.layer addAnimation:[self animationStyle] forKey:nil];
    _refreshButton.hidden = NO;
}

- (void)hideRefreshButton
{
    [_refreshButton.layer addAnimation:[self animationStyle] forKey:nil];
    _refreshButton.hidden = YES;
}

@end
