//
//  HistoryTableViewCell.h
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/05/28.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic) AttendanceType attendanceType;

@end
