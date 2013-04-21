//
//  NSArray+Random.m
//  MarsWeatherReport
//
//  Created by Leilani Montas on 4/21/13.
//  Copyright (c) 2013 Leilani Montas. All rights reserved.
//

#import "NSArray+Random.h"

@implementation NSArray (Random)
-(id)randomObject{
    uint32_t rnd=arc4random_uniform([self count]);
    return [self objectAtIndex:rnd];
    
}

@end
