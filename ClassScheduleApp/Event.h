//
//  Event.h
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/06/02.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic, assign) NSInteger eventId;
@property (nonatomic,   copy) NSString* day;
@property (nonatomic,   copy) NSString* title;
@property (nonatomic, assign) NSInteger period;
@property (nonatomic,   copy) NSString* place;
@property (nonatomic, assign) NSInteger absent;
@property (nonatomic, assign) NSInteger delay;
@property (nonatomic, assign) NSInteger dayNumber;
@property (nonatomic,   copy) NSString* lecturer;
@property (nonatomic,   copy) NSString* memo;
@property (nonatomic,   copy) NSDate* startTime;
@property (nonatomic,   copy) NSDate* finishTime;
@property (nonatomic,   copy) NSString* color;
@property (nonatomic,   copy) NSDate* deadline;

@end
