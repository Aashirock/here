//
//  File.h
//  ARKO
//
//  Created by Leilani Montas on 10/10/12.
//  Copyright (c) 2012 Leilani Montas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface File : NSObject

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *type;

-(id)initWithName:(NSString *)theName type:(NSString *)theType;
+(NSString *)pathInDocumentsDirectoryForFileName:(NSString *)filename;
-(void)copyToDocumentsDirectory;

@end
