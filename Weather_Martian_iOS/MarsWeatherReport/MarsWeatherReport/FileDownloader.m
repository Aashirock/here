//
//  FileDownloader.m
//  ARKO
//
//  Created by Leilani Montas on 12/17/12.
//  Copyright (c) 2012 Leilani Montas. All rights reserved.
//

#import "FileDownloader.h"
#import "Downloader.h"
#import "Url.h"

@interface FileDownloader()
@property(nonatomic,strong)NSString *urlString;

@end

@implementation FileDownloader
@synthesize key;
@synthesize delegate;
@synthesize isSuccessful;
@synthesize urlString;

-(NSString *)urlString{
    return [Url getUrlForKey:self.key];
}
-(id)initWithKey:(NSString *)aKey delegate:(id<FileDownloaderDelegate>)del{
    if (self=[super init]) {
        self.key=aKey;
        self.delegate=del;
    }
    return self;
    
    
}
-(void)main
{
    @autoreleasepool {
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(downloaderDidBeginDownloading:) withObject:self waitUntilDone:NO];
        if (self.isCancelled) {
            return;
            
        }
        self.isSuccessful=[Downloader downloadFrom:[NSURL URLWithString:self.urlString] saveAs:[NSString stringWithFormat:@"%@.txt",self.key]];
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(downloaderDidFinishDownloading:) withObject:self waitUntilDone:NO];
        
    }
}
@end
