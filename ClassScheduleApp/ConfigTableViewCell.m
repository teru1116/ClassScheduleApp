//
//  ConfigTableViewCell.m
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/06/05.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import "ConfigTableViewCell.h"

@interface ConfigTableViewCell () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *wavedashLabel;

@end

@implementation ConfigTableViewCell

@synthesize isTimeSetting = _isTimeSetting;

- (void)setIsTimeSetting:(BOOL)isTimeSetting
{
    _isTimeSetting = isTimeSetting;
    self.startTimeTextField.hidden = NO;
    self.endingTimeTextField.hidden = NO;
    self.wavedashLabel.hidden = NO;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.startTimeTextField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-130, 5, 50, 30)];
        self.startTimeTextField.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.startTimeTextField];
        
        self.endingTimeTextField = [[UITextField alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 5, 50, 30)];
        self.endingTimeTextField.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.endingTimeTextField];
        
        self.wavedashLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-80, 5, 20, 30)];
        self.wavedashLabel.text = @"〜";
        self.wavedashLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.wavedashLabel];
        
        self.startTimeTextField.hidden = YES;
        self.endingTimeTextField.hidden = YES;
        self.wavedashLabel.hidden = YES;
    }
    return self;
}

@end
