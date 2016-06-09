//
//  DaoEvents.m
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/06/02.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import "DaoEvents.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "Event.h"

#define DB_FILE_NAME @"timetable.db"

@implementation DaoEvents
{
    FMDatabase* _db;
}

- (FMDatabase *)dbConnect
{
    BOOL isSucceeded;
    NSArray  *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    NSString* dir = [paths objectAtIndex:0];
    NSString* documentsPath = [dir stringByAppendingPathComponent:DB_FILE_NAME];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    isSucceeded = [fileManager fileExistsAtPath:documentsPath];
    if ( !isSucceeded ) {
        return nil;
    }
    
    FMDatabase* db = [FMDatabase databaseWithPath:documentsPath];
    return db;
}

- (NSMutableArray *)events
{
    FMDatabase* db = [self dbConnect];
    if (!db) {
        return nil;
    }
    
    [db open];
    
    FMResultSet*    results = [db executeQuery:@"SELECT id, day, title, period, place, absent, delay, dayNumber, lecturer, memo, startTime, finishTime, color, deadline FROM timetable1 ;"];
    NSMutableArray* events = [[NSMutableArray alloc] initWithCapacity:0];
    
    while( [results next] )
    {
        Event* event = [[Event alloc] init];
        event.eventId    = [results intForColumnIndex:0];
        event.day    = [results stringForColumnIndex:1];
        event.title     = [results stringForColumnIndex:2];
        event.period     = [results intForColumnIndex:3];
        event.place     = [results stringForColumnIndex:4];
        event.absent     = [results intForColumnIndex:5];
        event.delay     = [results intForColumnIndex:6];
        event.dayNumber = [results intForColumnIndex:7];
        event.lecturer = [results stringForColumnIndex:8];
        event.memo = [results stringForColumnIndex:9];
        event.startTime = [results dateForColumnIndex:10];
        event.finishTime = [results dateForColumnIndex:11];
        event.color = [results stringForColumnIndex:12];
        event.deadline = [results dateForColumnIndex:13];
        
        [events addObject:event];
    }
    
    [db close];
    
    return events;
}

@end
