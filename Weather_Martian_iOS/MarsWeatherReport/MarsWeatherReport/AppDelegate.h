//
//  AppDelegate.h
//  MarsWeatherReport
//
//  Created by Leilani Montas on 4/15/13.
//  Copyright (c) 2013 Leilani Montas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "PendingOperations.h"
#import "FileDownloader.h"
#import "WeatherParser.h"
#import "Twitter.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,FileDownloaderDelegate,WeatherParserDelegate,TwitterDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NetworkStatus netStatus;
@property (nonatomic,strong)PendingOperations *pendingOperations;
-(void)fetchData;
@end
