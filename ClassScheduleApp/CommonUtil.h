//
//  CommonUtil.h
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/04/09.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CommonUtil : NSObject

+ (UIColor *)colorFromHexCode:(NSString *)hexString;

+ (NSInteger)dayCount;
+ (void)setDayCount:(NSInteger)dayCount;

+ (NSInteger)periodCount;
+ (void)setPeriodCount:(NSInteger)periodCount;

+ (NSArray *)startTimes;
+ (void)setStartTimes:(NSArray *)startTimes;
+ (void)setStartTime:(NSDate *)startTime AtPeriond:(NSInteger)period;

+ (NSArray *)endingTimes;
+ (void)setEndingTimes:(NSArray *)endingTimes;
+ (void)setEndingTime:(NSDate *)endingTime AtPeriond:(NSInteger)period;

+ (BOOL)isFirstRun;

+ (BOOL)showsTime;
+ (void)setShowsTime:(BOOL)showsTime;

@end
