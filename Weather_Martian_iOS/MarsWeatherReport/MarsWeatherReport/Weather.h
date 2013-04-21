//
//  Weather.h
//  MarsWeatherReport
//
//  Created by Leilani Montas on 4/15/13.
//  Copyright (c) 2013 Leilani Montas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *link;
@property(nonatomic,strong)NSString *sol;
@property(nonatomic,strong)NSString *terrestialDate;
@property(nonatomic)double minTemp;
@property(nonatomic)double maxTemp;
@property(nonatomic)double pressure;
@property(nonatomic,strong)NSString *pressureString;
@property(nonatomic)double humidity;
@property(nonatomic)double windSpeed;
@property(nonatomic,strong)NSString *windDirection;
@property(nonatomic,strong)NSString *atmoOpacity;
@property(nonatomic,strong)NSString *season;
@property(nonatomic)double ls;
@property(nonatomic,strong)NSString *sunrise;
@property(nonatomic,strong)NSString *sunset;


@end
