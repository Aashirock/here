//
//  DBAccess.m
//  MarsWeatherReport
//
//  Created by Leilani Montas on 4/20/13.
//  Copyright (c) 2013 Leilani Montas. All rights reserved.
//

#import "DBAccess.h"
#import <sqlite3.h>
#import "File.h"
@interface DBAccess()
-(void)initializeDatabase;
@end
@implementation DBAccess


sqlite3 *database;

-(id)init
{
    
	if (self=[super init]) {
    
		[self initializeDatabase];
	}
	return self;
    
}

-(void)initializeDatabase
{
    NSString *path=[File pathInDocumentsDirectoryForFileName:@"TriviaDB.sqlite"];
	
    // Open the database. The database was prepared outside the application.
    if (sqlite3_open([path UTF8String], &database) != SQLITE_OK) {
        // Even though the open failed,
        // call close to properly clean up resources.
        sqlite3_close(database);
        NSAssert1(0, 
                  @"Failed to open database with message '%s'.", 
                  sqlite3_errmsg(database)
                  );
    }
    else{
        NSLog(@"database opened");
    }
	
}


-(Trivium*)getTriviumForCategory:(NSString *)category value:(double)value{
    
    const char *sql=[[NSString stringWithFormat:@"SELECT id,category,min_value,max_value,trivium FROM Trivia WHERE category='%@' AND min_value<='%f' AND max_value>='%f' ORDER BY RANDOM() LIMIT 1",category,value,value] UTF8String];
    return [self getTriviumWithSql:sql];
	  
}
-(Trivium*)getRandomGeneralTrivium{
    const char *sql=[@"SELECT id,category,min_value,max_value,trivium FROM Trivia WHERE category='General' ORDER BY RANDOM() LIMIT 1" UTF8String];
    return [self getTriviumWithSql:sql];

}
-(Trivium*)getTriviumWithSql:(const char*)sql{
    Trivium *trivium=nil;
    sqlite3_stmt *statement;
	int sqlResult = sqlite3_prepare_v2(database, sql, -1, &statement, NULL);
	
	if (sqlResult==SQLITE_OK)
	{
		while (sqlite3_step(statement)==SQLITE_ROW)
		{
			int ID=sqlite3_column_int(statement, 0);
            char *category=(char *)sqlite3_column_text(statement, 1);
            double minVal=sqlite3_column_double(statement, 2);
            double maxVal=sqlite3_column_double(statement, 3);
            char *triv=(char *)sqlite3_column_text(statement, 4);
            
            if (trivium==nil) {
                trivium=[[Trivium alloc] init];
            }
            
            trivium.ID=ID;
            trivium.category=[NSString stringWithUTF8String:category];
            trivium.minValue=minVal;
            trivium.maxValue=maxVal;
            trivium.trivium=[NSString stringWithUTF8String:triv];
            
			
		}
		sqlite3_finalize(statement);
	}
	else {
        NSLog(@"Problem with the database");
		NSLog(@"%d",sqlResult);
        NSLog(@"error %s",sqlite3_errmsg(database));
		
	}
    return trivium;
    
}

@end
