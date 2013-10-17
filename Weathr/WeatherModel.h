//
//  WeatherModel.h
//  Weathr
//
//  Created by Paul Williamson on 17/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherModel : NSObject

@property (nonatomic, copy)     NSString *weatherDescription;
@property (nonatomic, strong)   NSNumber *temperature;
@property (nonatomic, copy)     NSString *icon;
@property (nonatomic, copy)     NSString *locationName;
@property (nonatomic, strong)   NSDate   *lastUpdated;
@property (nonatomic, strong)   NSNumber *lat;
@property (nonatomic, strong)   NSNumber *lon;

@end
