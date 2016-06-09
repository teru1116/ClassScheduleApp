//
//  DailyTableViewCell.h
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/05/22.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyTableViewCell : UITableViewCell

@property (nonatomic, strong) ClassData *classData;

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *periodLabel;
@property (nonatomic, weak) IBOutlet UILabel *timeLabel;
@property (nonatomic, weak) IBOutlet UILabel *placeLabel;
@property (nonatomic, weak) IBOutlet UILabel *teacherLabel;
@property (nonatomic, weak) IBOutlet UILabel *noteLabel;
@property (nonatomic, weak) IBOutlet UIView *colorView;

@property (nonatomic, strong) UIButton *attendBtn;
@property (nonatomic, strong) UIButton *absentBtn;

@property (nonatomic, weak) IBOutlet UIImageView *classIcon;
@property (nonatomic, weak) IBOutlet UIImageView *teacherIcon;
@property (nonatomic, weak) IBOutlet UIImageView *pencilIcon;

@end
