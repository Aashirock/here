//
//  Trivium.m
//  MarsWeatherReport
//
//  Created by Leilani Montas on 4/20/13.
//  Copyright (c) 2013 Leilani Montas. All rights reserved.
//

#import "Trivium.h"
#import "DBAccess.h"

@implementation Trivium
+(Trivium*)getTriviumForCategory:(NSString *)category value:(double)value{
    DBAccess *dba=[[DBAccess alloc] init];
    return [dba getTriviumForCategory:category value:value];

}
+(Trivium*)getRandomGeneralTrivium{
    DBAccess *dba=[[DBAccess alloc] init];
    return [dba getRandomGeneralTrivium];
}
@end
