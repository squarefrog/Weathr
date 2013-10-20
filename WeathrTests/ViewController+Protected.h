//
//  ViewController+Protected.h
//  Weathr
//
//  Created by Paul Williamson on 17/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import "ViewController.h"

@class CLLocationManager;
@class WeatherModel;

@interface ViewController (Protected)

@property (nonatomic, weak) UIImageView *weatherIcon;
@property (nonatomic, weak) UILabel *weatherDescription;
@property (nonatomic, weak) UILabel *lastUpdatedLabel;
@property (nonatomic, strong) WeatherModel *weatherModel;
@property (nonatomic, strong) CLLocationManager *locationManager;

- (void)loadImageNamed: (NSString *)imageName;
- (void)updateWeatherDescription: (NSString *)description;
- (void)updateLastUpdatedLabel: (NSString *)lastUpdated;
- (UIColor *)pickColourUsingTemperature: (NSNumber *)temp;
- (void)updateViewBackgroundColour: (UIColor *)color;

@end
