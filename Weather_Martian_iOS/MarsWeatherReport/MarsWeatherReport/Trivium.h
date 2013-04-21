//
//  Trivium.h
//  MarsWeatherReport
//
//  Created by Leilani Montas on 4/20/13.
//  Copyright (c) 2013 Leilani Montas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Trivium : NSObject

@property(nonatomic)int ID;
@property(nonatomic,strong)NSString *category;
@property(nonatomic)double minValue;
@property(nonatomic)double maxValue;
@property(nonatomic,strong)NSString *trivium;

+(Trivium*)getTriviumForCategory:(NSString *)category value:(double)value;
+(Trivium*)getRandomGeneralTrivium;
@end
