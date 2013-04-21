//
//  DBAccess.h
//  MarsWeatherReport
//
//  Created by Leilani Montas on 4/20/13.
//  Copyright (c) 2013 Leilani Montas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Trivium.h"

@interface DBAccess : NSObject

-(Trivium*)getTriviumForCategory:(NSString *)category value:(double)value;
-(Trivium*)getRandomGeneralTrivium;

@end
