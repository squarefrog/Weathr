//
//  WeatherModelStubs.m
//  Weathr
//
//  Created by Paul Williamson on 20/10/2013.
//  Copyright (c) 2013 Paul Williamson. All rights reserved.
//

#import "WeatherModelStubs.h"

@implementation WeatherModelStubs

+ (NSBundle *)bundle
{
    return [NSBundle bundleForClass:[self class]];
}

+ (NSData *)stubJSON
{
    NSString *json = @"{\"coord\":{\"lon\":0.13,\"lat\":51.51},\"sys\":{\"country\":\"GB\",\"sunrise\":1382164294,\"sunset\":1382201824},\"weather\":[{\"id\":500,\"main\":\"Rain\",\"description\":\"light rain\",\"icon\":\"10n\"}],\"base\":\"global stations\",\"main\":{\"temp\":285.83,\"humidity\":91,\"pressure\":1010,\"temp_min\":284.26,\"temp_max\":287.15},\"wind\":{\"speed\":4.22,\"deg\":201.003},\"rain\":{\"3h\":1},\"clouds\":{\"all\":88},\"dt\":1382224998,\"id\":2650430,\"name\":\"East Ham\",\"cod\":200}";
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

+ (NSDictionary *)stubDict
{
    NSDictionary *coord = @{@"lon":@0.13,@"lat":@51.51};
    NSDictionary *sys = @{@"country":@"GB",@"sunrise":@1382164294,@"sunset":@1382201824};
    NSDictionary *weatherDict = @{@"id":@500,@"main":@"Rain",@"description":@"light rain",@"icon":@"10n"};
    NSArray *weather = @[weatherDict];
    NSString *base = @"global stations";
    NSDictionary *main = @{@"temp": @285.83,@"humidity":@91,@"pressure":@1010,@"temp_min":@284.26,@"temp_max":@287.15};
    NSDictionary *wind = @{@"speed":@4.22,@"deg":@201.003};
    NSDictionary *rain = @{@"3h":@1};
    NSDictionary *clouds = @{@"all":@88};
    NSNumber *dt = @1382224998;
    NSNumber *idNumber = @2650430;
    NSString *name = @"East Ham";
    NSNumber *cod = @200;
    
    NSDictionary *mock = @{@"coord":coord,@"sys":sys,@"weather":weather,@"base":base,@"main":main,@"wind":wind,@"rain":rain,@"clouds":clouds,@"dt":dt,@"id":idNumber,@"name":name,@"cod":cod};
    
    return mock;
}

@end
