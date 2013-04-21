//
//  Twitter.h
//  MarsWeatherReport
//
//  Created by Leilani Montas on 4/21/13.
//  Copyright (c) 2013 Leilani Montas. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Twitter;
@protocol TwitterDelegate <NSObject>
-(void)twitterDidReceiveTweets:(Twitter *)twitter;
@end

@interface Twitter : NSObject
@property(nonatomic,weak)id<TwitterDelegate,NSObject>delegate;
@property(nonatomic,strong)NSArray *tweets;
@property(nonatomic)BOOL hasAccess;
-(void)fetchTimelineForUser:(NSString *)username;
-(id)initWithDelegate:(id<TwitterDelegate>)del;

@end
