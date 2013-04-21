//
//  AppDelegate.m
//  MarsWeatherReport
//
//  Created by Leilani Montas on 4/15/13.
//  Copyright (c) 2013 Leilani Montas. All rights reserved.
//

#import "AppDelegate.h"
#import "Downloader.h"
#import "File.h"

#define kTriviaDBName @"TriviaDb"
#define kTriviaDBType @"sqlite"

@implementation AppDelegate
@synthesize netStatus;
@synthesize pendingOperations;

Reachability *curReach;

UIImageView *splashScreen;
UIWebView *webView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    File *file=[[File alloc]initWithName:kTriviaDBName type:kTriviaDBType];
    [file copyToDocumentsDirectory];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
    
    
    curReach=[Reachability reachabilityWithHostName: @"www.apple.com"];
    netStatus=[curReach currentReachabilityStatus];
    [curReach startNotifier];
    [self fetchData];
    
   // [self performSelectorOnMainThread:@selector(removeSplash) withObject:nil waitUntilDone:YES];
    
    return YES;
    
}
-(void)removeSplash{
    [webView removeFromSuperview];
    
}

-(void)fetchData{

    if (netStatus!=NotReachable) {
        
        [self startDownloadingForKey:kDownloadWeatherKey];
        Twitter *twitter=[[Twitter alloc] initWithDelegate:self];
        [twitter fetchTimelineForUser:@"MarsWxReport"];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Network Connection" message:@"You are not connected to a network. " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        [self startParsingForKey:kDownloadWeatherKey];
    }
}

-(void)startDownloadingForKey:(NSString *)key{
    if (![self.pendingOperations.downloadsInProgress.allKeys containsObject:key]) {
        FileDownloader *fileDownloader=[[FileDownloader alloc] initWithKey:key delegate:self];
        [self.pendingOperations.downloadingQueue setMaxConcurrentOperationCount:1];
        [self.pendingOperations.downloadingQueue addOperation:fileDownloader];
        [self.pendingOperations.downloadsInProgress setObject:fileDownloader forKey:key];
    }
    
}
-(void)startParsingForKey:(NSString *)key{
    if (![self.pendingOperations.parsingInProgress.allKeys containsObject:key]) {
        WeatherParser *parser=[[WeatherParser alloc] initWithKey:key delegate:self];
        FileDownloader *weatherDownloader=[self.pendingOperations.downloadsInProgress objectForKey:key];
        if (weatherDownloader) {
            [parser addDependency:weatherDownloader];
        }
        [self.pendingOperations.parsingQueue setMaxConcurrentOperationCount:1];
        [self.pendingOperations.parsingQueue addOperation:parser];
        [self.pendingOperations.parsingInProgress setObject:parser forKey:key];
    }
}

-(PendingOperations *)pendingOperations
{
    if (!pendingOperations) {
        pendingOperations=[[PendingOperations alloc] init];
    }
    return pendingOperations;
}
-(void)reachabilityChanged:(NSNotification *)notification
{
    curReach=[notification object];
    netStatus = [curReach currentReachabilityStatus];
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark FileDownloaderDelegate Methods
-(void)downloaderDidBeginDownloading:(FileDownloader *)downloader{
    
}
-(void)downloaderDidFinishDownloading:(FileDownloader *)downloader{
    if ([downloader.key isEqualToString:kDownloadWeatherKey]) {
        [self startParsingForKey:kDownloadWeatherKey];
        [self.pendingOperations.downloadsInProgress removeObjectForKey:downloader.key];
        // [self removeSplash];
    }
    
}

#pragma mark WeatherParserDelegate Methods
-(void)weatherParserDidFinishParsing:(WeatherParser *)parser{
    [self performSelector:@selector(removeSplash) withObject:nil afterDelay:5];
    
    NSDictionary *userInfo=[NSDictionary dictionaryWithObject:parser.weather forKey:kWeatherKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationWeatherParsed object:nil userInfo:userInfo];
    [self.pendingOperations.parsingInProgress removeObjectForKey:parser.key];
    

}
-(void)weatherParserDidFailWithError:(WeatherParser *)parser{
    [self performSelector:@selector(removeSplash) withObject:nil afterDelay:5];
    [self.pendingOperations.parsingInProgress removeObjectForKey:parser.key];
    
}

#pragma mark TwitterDelegate Methods
-(void)twitterDidReceiveTweets:(Twitter *)twitter{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationFetchedTwitterTimeline object:nil userInfo:[NSDictionary dictionaryWithObject:twitter.tweets forKey:@"tweets"]];

}
@end
