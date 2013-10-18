//
//  ViewController.m
//  Weathr
//
//  Created by Paul Williamson on 17/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface ViewController () <CLLocationManagerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *weatherIcon;
@property (nonatomic, weak) IBOutlet UILabel *weatherDescription;
@property (nonatomic, weak) IBOutlet UILabel *lastUpdatedLabel;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

#pragma mark - Methods
- (void)loadImageNamed: (NSString *)imageName
{
    _weatherIcon.image = [UIImage imageNamed:imageName];
}

- (void)updateWeatherDescription: (NSString *)description
{
    _weatherDescription.text = description;
}

- (void)updateLastUpdatedLabel: (NSString *)lastUpdated
{
    _lastUpdatedLabel.text = [NSString stringWithFormat:@"Last updated: %@", lastUpdated];
}

#pragma mark - Colour Methods
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
