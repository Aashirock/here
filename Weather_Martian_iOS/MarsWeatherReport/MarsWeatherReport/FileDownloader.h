//
//  FileDownloader.h
//  ARKO
//
//  Created by Leilani Montas on 12/17/12.
//  Copyright (c) 2012 Leilani Montas. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FileDownloader;
@protocol FileDownloaderDelegate <NSObject>
@required
-(void)downloaderDidBeginDownloading:(FileDownloader *)downloader;
-(void)downloaderDidFinishDownloading:(FileDownloader *)downloader;

@end
@interface FileDownloader : NSOperation
@property(nonatomic,strong)NSString *key;
@property(nonatomic,weak)id<FileDownloaderDelegate>delegate;
@property(nonatomic)BOOL isSuccessful;
-(id)initWithKey:(NSString *)aKey delegate:(id<FileDownloaderDelegate>)del;

@end
