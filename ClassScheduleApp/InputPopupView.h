//
//  InputPopupView.h
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/04/09.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputPopupViewDelegate <NSObject>

- (void)closePopup;

@end

@interface InputPopupView : UIView

@property (nonatomic, strong) ClassData *classData;
@property (nonatomic, weak) id<InputPopupViewDelegate> delegate;

- (instancetype)initWithClassData:(ClassData *)classData dayNumber:(NSInteger)dayNumber periodNumber:(NSInteger)periodNumber;

@end
