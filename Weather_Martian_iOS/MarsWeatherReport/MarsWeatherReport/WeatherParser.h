//
//  WeatherParser.h
//  MarsWeatherReport
//
//  Created by Leilani Montas on 4/16/13.
//  Copyright (c) 2013 Leilani Montas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Weather.h"
@class WeatherParser;
@protocol WeatherParserDelegate <NSObject>
@required
-(void)weatherParserDidFinishParsing:(WeatherParser *)parser;
-(void)weatherParserDidFailWithError:(WeatherParser *)parser;

@end

@interface WeatherParser : NSOperation
@property(nonatomic,strong)NSString *key;
@property(nonatomic,strong)Weather *weather;
@property(nonatomic,weak)id<WeatherParserDelegate>delegate;
@property(nonatomic,strong)NSError *error;
-(id)initWithKey:(NSString *)aKey delegate:(id<WeatherParserDelegate>)del;

@end
