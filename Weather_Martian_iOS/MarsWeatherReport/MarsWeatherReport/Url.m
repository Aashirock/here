//
//  Url.m
//  ARKO
//
//  Created by Leilani Montas on 3/5/13.
//  Copyright (c) 2013 Leilani Montas. All rights reserved.
//

#import "Url.h"

@implementation Url

+(NSString *)getUrlForKey:(NSString*)key{
    if ([key isEqualToString:kDownloadWeatherKey]) {
        return @"http://cab.inta-csic.es/rems/rems_weather.xml";
    }
    else if([key isEqualToString:@""]){
        return @"";
    }
    else{
        return nil;
    }
    
    
}


@end
