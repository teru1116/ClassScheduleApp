//
//  WeeklyViewController.m
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/04/09.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import "WeeklyViewController.h"
#import "GridView.h"
#import "GridViewCell.h"
#import "InputViewController.h"

@interface WeeklyViewController ()

@end

@implementation WeeklyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self drawGridView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(redrawGrid) name:NOTICE_REDRAW_GRID object:nil];
}

- (void)drawGridView
{
    NSInteger dayCount = [CommonUtil dayCount];
    NSInteger periodCount = [CommonUtil periodCount];
    
    CGFloat cellWidth = GRID_VIEW_FRAME.size.width/dayCount;
    CGFloat cellHeight = GRID_VIEW_FRAME.size.height/periodCount;
    
    // 縦線
    CGFloat horizontalInterval = (SCREEN_WIDTH-40)/dayCount;
    for (int i = 0; i <= dayCount; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(40+i*horizontalInterval, 30, 1.0, SCREEN_HEIGHT-114)];
        line.backgroundColor = [CommonUtil colorFromHexCode:@"ddd"];
        [self.view addSubview:line];
    }
    
    // 横線
    CGFloat verticalInterval = (SCREEN_HEIGHT-114)/periodCount;
    for (int i = 0; i <= periodCount; i++) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 30+i*verticalInterval, SCREEN_WIDTH, 1.0)];
        line.backgroundColor = [CommonUtil colorFromHexCode:@"ddd"];
        [self.view addSubview:line];
    }
    
    // ラベル
    for (int i = 0; i < dayCount; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40+i*cellWidth, 5, cellWidth, 20)];
        label.text = @[@"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", @"Sun"][i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = COLOR_BLACK;
        [self.view addSubview:label];
    }
    for (int i = 0; i < periodCount; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20+cellHeight/2+i*cellHeight, 40, 20)];
        label.text = [NSString stringWithFormat:@"%d", i+1];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = COLOR_BLACK;
        [self.view addSubview:label];
    }
    
    // 授業時間
    if ([CommonUtil showsTime]) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"H:mm";
        for (int i = 0; i < periodCount; i++) {
            UILabel *startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30+i*cellHeight, 40, 20)];
            startTimeLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[CommonUtil startTimes][i]]];
            startTimeLabel.font = [UIFont systemFontOfSize:12];
            startTimeLabel.textColor = COLOR_BLACK;
            startTimeLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:startTimeLabel];
            
            UILabel *endingTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10+cellHeight+i*cellHeight, 40, 20)];
            endingTimeLabel.text = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[CommonUtil endingTimes][i]]];
            endingTimeLabel.font = [UIFont systemFontOfSize:12];
            endingTimeLabel.textColor = COLOR_BLACK;
            endingTimeLabel.textAlignment = NSTextAlignmentCenter;
            [self.view addSubview:endingTimeLabel];
        }
    }
    
    // セルを設置
    NSArray *classDatas = [[CoreDataManager sharedManager] fetchRequestWithEntityName:@"ClassData" predicate:nil sortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"dayNumber" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"periodNumber" ascending:YES]]];
    
    NSInteger index = 0;
    for (int i = 0; i < dayCount; i++) {
        for (int j = 0; j < periodCount; j++) {
            // 右端だけ調整
            CGFloat width = i+1 == dayCount ? cellWidth-5 : cellWidth-3;
            
            GridViewCell *cell = [[GridViewCell alloc] initWithFrame:CGRectMake(42+i*cellWidth, 32+j*cellHeight, width, cellHeight-3)];
            cell.layer.cornerRadius = 4.0;
            cell.clipsToBounds = YES;
            
            cell.dayNumber = i+1;
            cell.periodNumber = j+1;
            [self.view addSubview:cell];
            
            if ([classDatas count] != index) {
                ClassData *data = classDatas[index];
                if ([data.dayNumber intValue] == i+1 && [data.periodNumber intValue] == j+1) {
                    cell.classData = data;
                    index++;
                }
            }
            
            UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellDidTap:)];
            [cell addGestureRecognizer:recognizer];
        }
    }
}

- (void)redrawGrid
{
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
    [self drawGridView];
}

- (void)cellDidTap:(UITapGestureRecognizer *)recognizer
{
    GridViewCell *cell = (GridViewCell *)recognizer.view;
    InputViewController *vc = [[InputViewController alloc] initWithClassData:cell.classData dayNumber:cell.dayNumber periodNumber:cell.periodNumber];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
