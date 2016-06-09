//
//  GridViewCell.m
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/04/09.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import "GridViewCell.h"
#import "InputPopupView.h"

@interface GridViewCell ()

@property (nonatomic, strong) InputPopupView *popup;

@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *placeLabel;

@end

@implementation GridViewCell

@synthesize classData = _classData;

- (instancetype)initWithFrame:(CGRect)frame
{    
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        // 授業名ラベル
        {
            self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-20)];
            self.nameLabel.font = [UIFont systemFontOfSize:13];
            self.nameLabel.textColor = [CommonUtil colorFromHexCode:@"1d1d1d"];
            self.nameLabel.textAlignment = NSTextAlignmentCenter;
            self.nameLabel.numberOfLines = 0;
            [self addSubview:self.nameLabel];
        }
        
        // 教室ラベル
        {
            self.placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20)];
            self.placeLabel.font = [UIFont systemFontOfSize:13];
            self.nameLabel.textColor = [CommonUtil colorFromHexCode:@"1d1d1d"];
            self.placeLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:self.placeLabel];
        }
    }
    return self;
}

- (void)setClassData:(ClassData *)classData
{
    _classData = classData;
    
    UIGraphicsBeginImageContext(self.frame.size);
    [classData.cellBGImage drawInRect:self.bounds];
    UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
    
    self.nameLabel.text = classData.name;
    self.placeLabel.text = classData.place;
}

@end
