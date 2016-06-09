//
//  DailyTableViewCell.m
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/05/22.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import "DailyTableViewCell.h"
#import "TriangleButton.h"

@implementation DailyTableViewCell

@synthesize classData = _classData;

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)setClassData:(ClassData *)classData
{
    _classData = classData;
    self.nameLabel.text = classData.name;
    self.placeLabel.text = classData.place;
    self.teacherLabel.text = classData.teacher;
    self.noteLabel.text = classData.note;
    
    CGRect rect = CGRectMake(0, 0, 170, 1023);
    UIGraphicsBeginImageContext(rect.size);
    [classData.cellBGImage drawAtPoint:rect.origin];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIGraphicsBeginImageContext(self.colorView.frame.size);
    [backgroundImage drawInRect:self.colorView.frame];
    backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.colorView.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    if (self.placeLabel.text.length) {
        self.classIcon.hidden = NO;
    }
    if (self.teacherLabel.text.length) {
        self.teacherIcon.hidden = NO;
    }
    if (self.noteLabel.text.length) {
        self.pencilIcon.hidden = NO;
    }
    
    if (classData.periodNumber > 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"H:mm";
        int idx = [classData.periodNumber intValue]-1;
        self.timeLabel.text = [NSString stringWithFormat:@"%@〜%@", [dateFormatter stringFromDate:[CommonUtil startTimes][idx]], [dateFormatter stringFromDate:[CommonUtil endingTimes][idx]]];
        self.timeLabel.hidden = NO;
    }
    
    // 出席回数
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 55, 60, 50)];
    view.backgroundColor = COLOR_GRAY;
    view.layer.cornerRadius = 4.0;
    view.clipsToBounds = YES;
    view.tag = 10;
    [self.contentView addSubview:view];
    
    for (int i = 0; i < 2; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*30, 0, 30, 15)];
        label.text = @[@"出席", @"欠席"][i];
        label.textColor = [CommonUtil colorFromHexCode:@"4a4a4a"];
        label.font = [UIFont systemFontOfSize:11];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
    }
    
    self.attendBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 30, 35)];
    self.attendBtn.tag = 1;
    self.attendBtn.backgroundColor = COLOR_GRAY;
    self.attendBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.attendBtn setTitleColor:[CommonUtil colorFromHexCode:@"4a4a4a"] forState:UIControlStateNormal];
    [self.attendBtn addTarget:self action:@selector(btnDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.attendBtn];
    
    self.absentBtn = [[UIButton alloc] initWithFrame:CGRectMake(30, 15, 30, 35)];
    self.absentBtn.tag = 2;
    self.absentBtn.backgroundColor = COLOR_GRAY;
    self.absentBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    [self.absentBtn setTitleColor:[CommonUtil colorFromHexCode:@"4a4a4a"] forState:UIControlStateNormal];
    [self.absentBtn addTarget:self action:@selector(btnDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.absentBtn];
    
    [self reloadAttendCount];
}

- (void)reloadAttendCount
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"classDataId == %@", _classData.classDataId];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO];
    NSArray *histories = [[[CoreDataManager sharedManager] fetchRequestWithEntityName:@"HistoryData" predicate:predicate sortDescriptors:@[sortDescriptor]] mutableCopy];
    
    NSInteger attend = 0;
    NSInteger absent = 0;
    for (HistoryData *historyData in histories) {
        if (historyData.attendanceType == AttendanceTypeAttend) {
            attend++;
        } else if (historyData.attendanceType == AttendanceTypeAbsent) {
            absent++;
        }
    }
    
    [self.attendBtn setTitle:[NSString stringWithFormat:@"%ld", (long)attend] forState:UIControlStateNormal];
    [self.absentBtn setTitle:[NSString stringWithFormat:@"%ld", (long)absent] forState:UIControlStateNormal];
}

- (void)btnDidTap:(UIButton *)sender
{
    [[CoreDataManager sharedManager] saveWithBlock:^(NSManagedObjectContext *context) {
        HistoryData *historyData = [[HistoryData alloc] initWithEntity:[NSEntityDescription entityForName:@"HistoryData" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
        historyData.historyDataId = [[NSUUID UUID] UUIDString];
        historyData.classDataId = self.classData.classDataId;
        historyData.createdDate = [NSDate date];
        historyData.attendanceType = sender.tag;
    } completion:^{
        [self reloadAttendCount];
    }];
}

@end
