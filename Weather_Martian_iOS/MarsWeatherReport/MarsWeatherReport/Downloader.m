//
//  Downloader.m
//  ARKO
//
//  Created by Leilani Montas on 10/17/12.
//  Copyright (c) 2012 Leilani Montas. All rights reserved.
//

#import "Downloader.h"
#import "ASIHTTPRequest.h"
#import "File.h"

@implementation Downloader
+(BOOL)downloadFrom:(NSURL *)url saveAs:(NSString *)fileName
{
    BOOL success=NO;
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:30];
    [request startSynchronous];
    NSError *error = [request error];
    
    if (!error) {
        
        NSData *data=[request responseData];
        NSString *origContent=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        if (![origContent isEqualToString:@""]) {
            NSString *filePath=[File pathInDocumentsDirectoryForFileName:fileName];
            NSString *content=[[NSString alloc] initWithData:[request responseData] encoding:NSUTF8StringEncoding];
            NSRange range=[content rangeOfString:@"Page not found"];
            if (range.location==NSNotFound) {
                [[request responseData] writeToFile:filePath atomically:YES];
                success = YES;
                
            }
            
        }
        
        
    }
    return success;
    
}
@end
