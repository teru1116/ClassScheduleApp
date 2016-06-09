//
//  ContainerViewController.m
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/04/09.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import "ContainerViewController.h"
#import "WeeklyViewController.h"
#import "DailyContainerViewController.h"
#import "ConfigViewController.h"
#import "InputPopupView.h"

@interface ContainerViewController ()

@property (nonatomic, strong) WeeklyViewController *weeklyVC;
@property (nonatomic, strong) DailyContainerViewController *dailyVC;

@end

@implementation ContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"Weekly", @"Daily"]];
    segmentedControl.frame = CGRectMake(SCREEN_WIDTH/2-60, 30, 120, 30);
    segmentedControl.selectedSegmentIndex = 0;
    [segmentedControl addTarget:self action:@selector(segmentedControllerDidChange:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    
    UIBarButtonItem *configBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_config"] style:UIBarButtonItemStylePlain target:self action:@selector(showConfigView)];
    self.navigationItem.rightBarButtonItem = configBtn;
    
    self.weeklyVC = [[WeeklyViewController alloc] init];
    self.dailyVC = [[DailyContainerViewController alloc] init];
    
    [self addChildViewController:self.weeklyVC];
    self.weeklyVC.view.frame = self.view.bounds;
    [self.view addSubview:self.weeklyVC.view];
    [self.weeklyVC didMoveToParentViewController:self];
}

- (void)segmentedControllerDidChange:(UISegmentedControl *)segmentedControl
{
    UIViewController *toVC = nil;
    UIViewController *fromVC = nil;
    
    if (segmentedControl.selectedSegmentIndex == 0) {
        toVC = self.weeklyVC;
        fromVC = self.dailyVC;
    } else {
        toVC = self.dailyVC;
        fromVC = self.weeklyVC;
    }
    
    [fromVC willMoveToParentViewController:nil];
    [fromVC removeFromParentViewController];
    [fromVC.view removeFromSuperview];
    
    [self addChildViewController:toVC];
    toVC.view.frame = self.view.bounds;
    [self.view addSubview:toVC.view];
    [toVC didMoveToParentViewController:self];
}

- (void)showConfigView
{
    // ポップアップを閉じる
    for (UIView *view in [[UIApplication sharedApplication] keyWindow].subviews) {
        if ([view isKindOfClass:[InputPopupView class]]) {
            [view removeFromSuperview];
            break;
        }
    }
    
    ConfigViewController *vc = [[ConfigViewController alloc] initWithConfigViewType:ConfigViewTypeRoot];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
