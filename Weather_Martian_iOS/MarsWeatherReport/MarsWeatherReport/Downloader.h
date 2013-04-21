//
//  Downloader.h
//  ARKO
//
//  Created by Leilani Montas on 10/17/12.
//  Copyright (c) 2012 Leilani Montas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Downloader : NSObject
+(BOOL)downloadFrom:(NSURL *)url saveAs:(NSString *)fileName;

@end
