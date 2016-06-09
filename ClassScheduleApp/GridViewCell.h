//
//  GridViewCell.h
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/04/09.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputPopupView.h"

@interface GridViewCell : UIView

@property (nonatomic) NSInteger dayNumber;
@property (nonatomic) NSInteger periodNumber;
@property (nonatomic, strong) ClassData *classData;

@end
