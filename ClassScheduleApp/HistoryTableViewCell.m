//
//  HistoryTableViewCell.m
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/05/28.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import "HistoryTableViewCell.h"

@implementation HistoryTableViewCell

@synthesize attendanceType = _attendanceType;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 180, 40)];
        self.dateLabel.textColor = [CommonUtil colorFromHexCode:@"4a4a4a"];
        self.dateLabel.font = [UIFont systemFontOfSize:14];
        self.dateLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.dateLabel];
        
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-90, 2, 20, 40)];
            label.text = @"出";
            label.textColor = COLOR_GRAY;
            label.font = [UIFont boldSystemFontOfSize:15];
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = 1;
            [self.contentView addSubview:label];
        }
        
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 2, 20, 40)];
            label.text = @"欠";
            label.textColor = COLOR_GRAY;
            label.font = [UIFont boldSystemFontOfSize:15];
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = 2;
            [self.contentView addSubview:label];
        }
        
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, 2, 20, 40)];
            label.text = @"遅";
            label.textColor = COLOR_GRAY;
            label.font = [UIFont boldSystemFontOfSize:15];
            label.textAlignment = NSTextAlignmentCenter;
            label.tag = 3;
            [self.contentView addSubview:label];
        }
    }
    return self;
}

- (void)setAttendanceType:(AttendanceType)attendanceType
{
    _attendanceType = attendanceType;
    
    NSString *colorCode = @"";
    if (attendanceType == AttendanceTypeAttend) {
        colorCode = @"4c8ffb";
    } else if (attendanceType == AttendanceTypeAbsent) {
        colorCode = @"ff1493";
    } else if (attendanceType == AttendanceTypeLate) {
        colorCode = @"F5A623";
    }
    
    UILabel *label = (UILabel *)[self.contentView viewWithTag:attendanceType];
    label.textColor = [CommonUtil colorFromHexCode:colorCode];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
