//
//  ConfigTableViewCell.h
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/06/05.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfigTableViewCell : UITableViewCell

@property (nonatomic) BOOL isTimeSetting;
@property (nonatomic) BOOL isEditingStartTime;
@property (nonatomic, strong) UITextField *startTimeTextField;
@property (nonatomic, strong) UITextField *endingTimeTextField;
@property (nonatomic, strong) UIDatePicker *datePicker;

@end
