//
//  Twitter.m
//  MarsWeatherReport
//
//  Created by Leilani Montas on 4/21/13.
//  Copyright (c) 2013 Leilani Montas. All rights reserved.
//

#import "Twitter.h"
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>


#define kScreenNameKey @"screen_name"
#define kCountKey @"count"

#define kUserTimeLineURL @"https://api.twitter.com/1.1/statuses/user_timeline.json"

@implementation Twitter



-(id)initWithDelegate:(id<TwitterDelegate>)del{
    if (self=[super init]) {
        self.delegate=del;
    }
    return self;
    
}


-(void)fetchTimelineForUser:(NSString *)username{
    ACAccountStore *store=[[ACAccountStore alloc] init];
    ACAccountType *twitterType=[store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [store requestAccessToAccountsWithType:twitterType withCompletionHandler:^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *twitterAccounts=[store accountsWithAccountType:twitterType];
            if (twitterAccounts!=nil&&twitterAccounts.count>0) {
                ACAccount *account=[twitterAccounts objectAtIndex:0];
                
                NSMutableDictionary *params=[[NSMutableDictionary alloc] init];
                [params setValue:username forKey:@"screen_name"];
                [params setValue:@"20" forKey:@"count"];
                TWRequest *request=[[TWRequest alloc] initWithURL:[NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/user_timeline.json"] parameters:params requestMethod:TWRequestMethodGET];
                [request setAccount:account];
                
                [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    if (responseData!=nil) {
                        
                        self.tweets=[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
                        NSLog(@"number of tweets %d",self.tweets.count);
                        self.hasAccess=YES;
                        [(NSObject*)self.delegate performSelectorOnMainThread:@selector(twitterDidReceiveTweets:) withObject:self waitUntilDone:YES];
                        
                    }
                    
                }];
            }
            
        }
    }];
}


@end
