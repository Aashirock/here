//
//  PendingOperations.h
//  ARKO
//
//  Created by Leilani Montas on 11/18/12.
//  Copyright (c) 2012 Leilani Montas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PendingOperations : NSObject
@property(nonatomic,strong)NSMutableDictionary *parsingInProgress;
@property(nonatomic,strong)NSOperationQueue *parsingQueue;
@property(nonatomic,strong)NSMutableDictionary *plottingOverlayInProgress;
@property(nonatomic,strong)NSOperationQueue *plottingOverlayQueue;
@property(nonatomic,strong)NSMutableDictionary *downloadsInProgress;
@property(nonatomic,strong)NSOperationQueue *downloadingQueue;

@end
