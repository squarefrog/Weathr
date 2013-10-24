//
//  ViewController+Protected.h
//  Weathr
//
//  Created by Paul Williamson on 17/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import "ViewController.h"

@class WeatherModel;
@class OpenWeatherAPIManager;
@class CLLocationManager;
@class CLLocation;

@interface ViewController (PrivateMethods)

@property (nonatomic, weak) UIImageView *weatherIcon;
@property (nonatomic, weak) UILabel *weatherDescription;
@property (nonatomic, weak) UILabel *lastUpdatedLabel;
@property (nonatomic, weak) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) WeatherModel *weatherModel;
@property (nonatomic, strong) OpenWeatherAPIManager *apiManager;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, weak) UIButton *refreshButton;
@property (nonatomic, strong) NSDate *appStartDate;
@property (nonatomic, strong) Class alertViewClass;

- (void)loadImageNamed: (NSString *)imageName;
- (void)updateWeatherDescription: (NSAttributedString *)description;
- (void)updateLastUpdatedLabel: (NSString *)lastUpdated;
- (UIColor *)pickColourUsingTemperature: (NSNumber *)temp;
- (void)updateViewBackgroundColour: (UIColor *)color;
- (void)startActivityIndicator;
- (void)stopActivityIndicator;
- (void)reloadView;
- (IBAction)refreshButtonTapped:(id)sender;
- (void)showRefreshButton;
- (void)hideRefreshButton;
- (BOOL)shouldStopUpdatingLocation:(CLLocation *)location;
- (void)locationUpdateFailed:(NSError *)error;
@end