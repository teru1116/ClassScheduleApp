//
//  AppDelegate.m
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/04/09.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import "AppDelegate.h"
#import "ContainerViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if ([CommonUtil isFirstRun]) {
        [CommonUtil setPeriodCount:5];
        [CommonUtil setDayCount:5];
    }
    if (![CommonUtil startTimes]) {
        NSMutableArray *startTimes = [NSMutableArray array];
        NSMutableArray *endingTimes = [NSMutableArray array];
        NSArray *startTimeStrings = @[@"9:00", @"11:00", @"13:20", @"15:05", @"16:50", @"18:30", @"20:10", @"21:40"];
        NSArray *endingTimeStrings = @[@"10:30", @"12:30", @"14:50", @"16:35", @"18:20", @"20:00", @"21:30", @"23:10"];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"H:mm Z";
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        for (int i = 0; i < 8; i++) {
            NSString *startTimeString = [NSString stringWithFormat:@"%@ +0900", startTimeStrings[i]];
            NSString *endingTimeString = [NSString stringWithFormat:@"%@ +0900", endingTimeStrings[i]];
            [startTimes addObject:[dateFormatter dateFromString:startTimeString]];
            [endingTimes addObject:[dateFormatter dateFromString:endingTimeString]];
        }
        [CommonUtil setStartTimes:startTimes];
        [CommonUtil setEndingTimes:endingTimes];
        [CommonUtil setShowsTime:YES];
    }
        
    ContainerViewController *vc = [[ContainerViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBar.tintColor = [UIColor whiteColor];
    nav.navigationBar.barTintColor = COLOR_BLACK;
    nav.navigationBar.translucent = NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
