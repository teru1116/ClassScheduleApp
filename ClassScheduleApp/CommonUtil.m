//
//  CommonUtil.m
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/04/09.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#define UD_DAY_COUNT    @"udDayCount"
#define UD_PERIOD_COUNT @"udPeriodCount"
#define UD_START_TIMES  @"udStartTimes"
#define UD_ENDING_TIMES @"udEndingTimes"
#define UD_IS_FIRSTRUN  @"udIsFirstRun"
#define UD_SHOWS_TIME   @"udShowsTime"

#import "CommonUtil.h"

@implementation CommonUtil

+ (UIColor *)colorFromHexCode:(NSString *)hexString
{
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if ([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)], [cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)], [cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)], [cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if ([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (NSInteger)dayCount
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:UD_DAY_COUNT];
}

+ (void)setDayCount:(NSInteger)dayCount
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setInteger:dayCount forKey:UD_DAY_COUNT];
    [pref synchronize];
}

+ (NSInteger)periodCount
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:UD_PERIOD_COUNT];
}

+ (void)setPeriodCount:(NSInteger)periodCount
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setInteger:periodCount forKey:UD_PERIOD_COUNT];
    [pref synchronize];
}

+ (NSArray *)startTimes
{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:UD_START_TIMES];
}

+ (void)setStartTimes:(NSArray *)startTimes
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setObject:startTimes forKey:UD_START_TIMES];
    [pref synchronize];
}

+ (void)setStartTime:(NSDate *)startTime AtPeriond:(NSInteger)period;
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSMutableArray *startTimes = [[pref arrayForKey:UD_START_TIMES] mutableCopy];
    startTimes[period-1] = startTime;
    [pref setObject:startTimes forKey:UD_START_TIMES];
    [pref synchronize];
}

+ (NSArray *)endingTimes
{
    return [[NSUserDefaults standardUserDefaults] arrayForKey:UD_ENDING_TIMES];
}

+ (void)setEndingTimes:(NSArray *)endingTimes
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setObject:endingTimes forKey:UD_ENDING_TIMES];
    [pref synchronize];
}

+ (void)setEndingTime:(NSDate *)endingTime AtPeriond:(NSInteger)period;
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    NSMutableArray *endingTimes = [[pref arrayForKey:UD_ENDING_TIMES] mutableCopy];
    endingTimes[period-1] = endingTime;
    [pref setObject:endingTimes forKey:UD_ENDING_TIMES];
    [pref synchronize];
}

+ (BOOL)isFirstRun
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    if ([pref objectForKey:UD_IS_FIRSTRUN]) {
        return NO;
    }
    [pref setObject:[NSDate date] forKey:UD_IS_FIRSTRUN];
    [pref synchronize];
    return YES;
}

+ (BOOL)showsTime
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:UD_SHOWS_TIME];
}

+ (void)setShowsTime:(BOOL)showsTime
{
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setBool:showsTime forKey:UD_SHOWS_TIME];
    [pref synchronize];
}

@end
