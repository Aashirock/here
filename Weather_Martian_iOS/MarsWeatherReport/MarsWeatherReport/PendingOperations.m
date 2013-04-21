//
//  PendingOperations.m
//  ARKO
//
//  Created by Leilani Montas on 11/18/12.
//  Copyright (c) 2012 Leilani Montas. All rights reserved.
//

#import "PendingOperations.h"

@implementation PendingOperations
@synthesize parsingInProgress;
@synthesize parsingQueue;
@synthesize plottingOverlayInProgress;
@synthesize plottingOverlayQueue;
@synthesize downloadingQueue;
@synthesize downloadsInProgress;

-(NSMutableDictionary *)parsingInProgress
{
    if (!parsingInProgress) {
        parsingInProgress=[[NSMutableDictionary alloc]init];
    }
    return parsingInProgress;
}
-(NSOperationQueue *)parsingQueue
{
    if (!parsingQueue) {
        parsingQueue=[[NSOperationQueue alloc] init];
        parsingQueue.name=@"Parsing Queue";
        parsingQueue.maxConcurrentOperationCount=1;
    }
    return parsingQueue;
}
-(NSMutableDictionary *)plottingOverlayInProgress
{
    if (!plottingOverlayInProgress) {
        plottingOverlayInProgress=[[NSMutableDictionary alloc] init];
    }
    return plottingOverlayInProgress;
}
-(NSOperationQueue *)plottingOverlayQueue
{
    if (!plottingOverlayQueue) {
        plottingOverlayQueue=[[NSOperationQueue alloc] init];
        plottingOverlayQueue.name=@"Plotting Overlay Queue";
        plottingOverlayQueue.maxConcurrentOperationCount=1;
    }
    return plottingOverlayQueue;
}
-(NSMutableDictionary *)downloadsInProgress
{
    if (!downloadsInProgress) {
        downloadsInProgress=[[NSMutableDictionary alloc] init];
    }
    return downloadsInProgress;
}
-(NSOperationQueue *)downloadingQueue
{
    if (!downloadingQueue) {
        downloadingQueue=[[NSOperationQueue alloc] init];
        downloadingQueue.name=@"Downloading Queue";
        downloadingQueue.maxConcurrentOperationCount=1;
    }
    return downloadingQueue;
}

@end
