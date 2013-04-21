//
//  File.m
//  ARKO
//
//  Created by Leilani Montas on 10/10/12.
//  Copyright (c) 2012 Leilani Montas. All rights reserved.
//

#import "File.h"

@implementation File
@synthesize name;
@synthesize type;
-(id)initWithName:(NSString *)theName type:(NSString *)theType
{
    self=[super init];
    if (self) {
        self.name=theName;
        self.type=theType;
    }
    return self;
}
-(id)init
{
    return [self initWithName:nil type:nil];
}
+(NSString *)pathInDocumentsDirectoryForFileName:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:filename];
}
-(void)copyToDocumentsDirectory
{
    NSError *error=nil;
    NSString *filename=[NSString stringWithFormat:@"%@.%@",name,type];
    NSString *newPath=[File pathInDocumentsDirectoryForFileName:filename];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:newPath]) {
        if ([fileManager copyItemAtPath:[[NSBundle mainBundle] pathForResource:name ofType:type] toPath:newPath error:&error]) {
        }
        else
        {
            NSLog(@"error : %@",[error localizedDescription]);
        }
    }
   
    

}


@end
