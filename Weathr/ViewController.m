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
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>

#define ANIMATION_DURATION 1.0f

@interface ViewController () <WeatherModelDelegate,OpenWeatherAPIManagerDelegate,CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *weatherIcon;
@property (nonatomic, weak) IBOutlet UILabel *weatherDescription;
@property (nonatomic, weak) IBOutlet UILabel *lastUpdatedLabel;
@property (nonatomic, strong) WeatherModel *weatherModel;
@property (nonatomic, strong) OpenWeatherAPIManager *apiManager;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _weatherModel = [[WeatherModel alloc] init];
    _weatherModel.delegate = self;
    
    _apiManager = [[OpenWeatherAPIManager alloc] init];
    _apiManager.delegate = self;
    
    // Fetch current location
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
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

- (void)updateWeatherDescription: (NSString *)description
{
    [_weatherDescription.layer addAnimation:[self animationStyle] forKey:nil];
    _weatherDescription.text = description;
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

#pragma mark - Colour Methods
- (void)pickAndUpdateViewBackgroundColorWithTemperature: (NSNumber *)temp
{
    UIColor *colour = [self pickColourUsingTemperature:temp];
    [self updateViewBackgroundColour:colour];
}

- (UIColor *)pickColourUsingTemperature: (NSNumber *)temp
{
    if ([temp floatValue] >= 10.0f && [temp floatValue] < 18.0f)
        return COLOUR_COOL;
    else if ([temp floatValue] >= 18.0f && [temp floatValue] < 27.0f)
        return COLOUR_WARM;
    else if ([temp floatValue] >= 27.0f)
        return COLOUR_HOT;
    return COLOUR_COLD;
}

- (void)updateViewBackgroundColour: (UIColor *)color
{
    [self.view.layer addAnimation:[self animationStyle] forKey:nil];
    self.view.backgroundColor = color;
}

#pragma mark - Weather model delegate
- (void)weatherModelUpdated
{
    [self loadImageNamed:_weatherModel.icon];
    [self updateWeatherDescription:[_weatherModel getDetailedWeatherDescriptionString]];
    [self updateLastUpdatedLabel:[WeatherModel parseDate:_weatherModel.lastUpdated]];
    [self pickColourUsingTemperature:[_weatherModel getTemperatureInCelsius]];
}

#pragma mark - API manager delegate
- (void)dataTaskSuccessWithData:(NSData *)data
{
    [_weatherModel updateWeatherModelFromNSData:data];
}
// UIAlertView should probably be mocked
- (void)dataTaskFailWithHTTPURLResponse:(NSHTTPURLResponse *)response
{
    NSString *title = [NSString stringWithFormat:@"Error %d", [response statusCode]];
    NSString *message = [NSHTTPURLResponse localizedStringForStatusCode:response.statusCode];
    [[[UIAlertView alloc] initWithTitle:title
                               message:message
                              delegate:nil
                     cancelButtonTitle:@"Ok"
                      otherButtonTitles:nil] show];
}

#pragma mark - Core Location

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    [_locationManager stopUpdatingLocation];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"%@\nlocation: %@", placemarks[0], newLocation);
    }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [_locationManager stopUpdatingLocation];
    [[[UIAlertView alloc] initWithTitle:@"Error fetching location"
                                message:@"Please ensure you have enabled location services"
                               delegate:nil
                      cancelButtonTitle:@"Ok"
                       otherButtonTitles:nil] show];
}

@end
