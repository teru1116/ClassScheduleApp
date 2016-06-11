//
//  InputViewController.h
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/05/28.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InputViewController : UIViewController

- (instancetype)initWithClassData:(ClassData *)classData dayNumber:(NSInteger)dayNumber periodNumber:(NSInteger)periodNumber;

- (IBAction)attendanceBtnDidTap:(UIButton *)sender;

@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UIView *basicInfoSectionView;
@property (nonatomic, weak) IBOutlet UITextField *nameTextField;
@property (nonatomic, weak) IBOutlet UITextField *placeTextField;
@property (nonatomic, weak) IBOutlet UITextField *teacherTextField;
@property (nonatomic, weak) IBOutlet UITextField *noteTextField;

@property (nonatomic, weak) IBOutlet UIView *colorSectionView;

@property (nonatomic, weak) IBOutlet UIView *attendanceSectionView;
@property (nonatomic, weak) IBOutlet UITextField *dateSelectField;

@end
