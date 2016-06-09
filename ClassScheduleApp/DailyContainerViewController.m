//
//  DailyContainerViewController.m
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/04/09.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import "DailyContainerViewController.h"
#import "DailyTableViewController.h"
#import "YSLContainerViewController.h"

@implementation DailyContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(drawList) name:NOTICE_REDRAW_LIST object:nil];
    [self drawList];
}

- (void)drawList
{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    
    self.controllers = [NSMutableArray array];
    for (int i = 0; i < [CommonUtil dayCount]; i++) {
        DailyTableViewController *dailyTableVC = [[DailyTableViewController alloc] initWithDayNumber:i];
        [self.controllers addObject:dailyTableVC];
    }
    
    YSLContainerViewController *containerVC = [[YSLContainerViewController alloc] initWithControllers:_controllers topBarHeight:0 parentViewController:self];
    containerVC.menuBackGroudColor = [UIColor whiteColor];
    containerVC.menuIndicatorColor = [CommonUtil colorFromHexCode:@"4c8ffb"];
    [self.view addSubview:containerVC.view];
}


@end
