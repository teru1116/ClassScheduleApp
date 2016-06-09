//
//  DailyTableViewController.h
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/04/09.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DayNumberMonday = 0,
    DayNumberTuesday,
    DayNumberWednesday,
    DayNumberThursday,
    DayNumberFriday,
    DayNumberSaturday,
    DayNumberSunday,
} DayNumber;

@interface DailyTableViewController : UIViewController

- (instancetype)initWithDayNumber:(DayNumber)dayNumber;
- (void)reload;

@end
