//
//  InputPopupView.m
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/04/09.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import "InputPopupView.h"
#import <QuartzCore/QuartzCore.h>

@interface InputPopupView () <UITextFieldDelegate>

@property (nonatomic) NSInteger dayNumber;
@property (nonatomic) NSInteger periodNumber;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *place;
@property (nonatomic, strong) NSString *teacher;
@property (nonatomic, strong) NSString *note;

@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *placeTextField;
@property (nonatomic, strong) UITextField *teacherTextField;
@property (nonatomic, strong) UITextField *noteTextField;
@property (nonatomic, strong) UITapGestureRecognizer *recognizer;

@end

@implementation InputPopupView

@synthesize delegate = _delegate;

- (instancetype)initWithClassData:(ClassData *)classData dayNumber:(NSInteger)dayNumber periodNumber:(NSInteger)periodNumber
{
    if ([super init]) {
        self.classData = classData;
        self.dayNumber = dayNumber;
        self.periodNumber = periodNumber;
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = COLOR_GRAY.CGColor;
        
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 0;
        self.layer.shadowOffset = CGSizeMake(0, 0);
        self.layer.shadowRadius = 3;
        self.layer.shadowOpacity = 0.8;
        
        // 〜曜日〜限
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 120, 30)];
            NSString *dayString = @[@"月曜日", @"火曜日", @"水曜日", @"木曜日", @"金曜日", @"土曜日", @"日曜日"][dayNumber-1];
            label.text = [NSString stringWithFormat:@"%@ %ld限", dayString, (long)periodNumber];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
        }
        
        // 閉じる
        {
            self.closeButton = [[UIButton alloc] initWithFrame:CGRectMake(210, 10, 30, 30)];
            [self.closeButton setTitle:@"×" forState:UIControlStateNormal];
            self.closeButton.titleLabel.font = [UIFont systemFontOfSize:20];
            [self.closeButton setTitleColor:COLOR_BLACK forState:UIControlStateNormal];
            [self addSubview:self.closeButton];
        }
        
        // 授業名（必須）
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 50, 120, 20)];
            label.text = @"授業名（必須）";
            label.font = [UIFont systemFontOfSize:14];
            [self addSubview:label];
            
            self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 70, 200, 30)];
            self.nameTextField.text = classData ? classData.name : nil;
            self.nameTextField.backgroundColor = COLOR_GRAY;
            self.nameTextField.font = [UIFont systemFontOfSize:15];
            self.nameTextField.delegate = self;
            self.nameTextField.tag = 1;
            [self addSubview:self.nameTextField];
        }
        
        // 教室
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, 100, 20)];
            label.text = @"教室";
            label.font = [UIFont systemFontOfSize:14];
            [self addSubview:label];
            
            self.placeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 130, 200, 30)];
            self.placeTextField.text = classData ? classData.place : nil;
            self.placeTextField.backgroundColor = COLOR_GRAY;
            self.placeTextField.font = [UIFont systemFontOfSize:15];
            self.placeTextField.delegate = self;
            self.placeTextField.tag = 2;
            [self addSubview:self.placeTextField];
        }
        
        // 先生
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 170, 100, 20)];
            label.text = @"先生";
            label.font = [UIFont systemFontOfSize:14];
            [self addSubview:label];
            
            self.teacherTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 190, 200, 30)];
            self.teacherTextField.text = classData ? classData.teacher : nil;
            self.teacherTextField.backgroundColor = COLOR_GRAY;
            self.teacherTextField.font = [UIFont systemFontOfSize:15];
            self.teacherTextField.delegate = self;
            self.teacherTextField.tag = 3;
            [self addSubview:self.teacherTextField];
        }
        
        // 備考
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 230, 100, 20)];
            label.text = @"備考";
            label.font = [UIFont systemFontOfSize:14];
            [self addSubview:label];
            
            self.noteTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 250, 200, 30)];
            self.noteTextField.text = classData ? classData.note : nil;
            self.noteTextField.backgroundColor = COLOR_GRAY;
            self.noteTextField.font = [UIFont systemFontOfSize:15];
            self.noteTextField.delegate = self;
            self.noteTextField.tag = 4;
            [self addSubview:self.noteTextField];
        }
        
        // TODO: 色
        {
            //
        }
        
        // 削除ボタン
        CGFloat saveBtnX = 75;
        if (classData) {
            saveBtnX = 130;
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20, 310, 90, 30)];
            [btn setTitle:@"削除" forState:UIControlStateNormal];
            btn.backgroundColor = [CommonUtil colorFromHexCode:@"ddd"];
            [btn setTitleColor:[CommonUtil colorFromHexCode:@"4a4a4a"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
        
        // 登録ボタン
        {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(saveBtnX, 310, 90, 30)];
            [btn setTitle:@"登録" forState:UIControlStateNormal];
            btn.backgroundColor = COLOR_BLACK;
            btn.titleLabel.font = [UIFont systemFontOfSize:14];
            [btn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
        }
    }
    return self;
}

- (void)setDelegate:(id<InputPopupViewDelegate>)delegate
{
    _delegate = delegate;
    [self.closeButton addTarget:_delegate action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
}

- (void)save
{
    if (!self.nameTextField.text.length) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 285, 200, 20)];
        label.text = @"授業名を入力してください。";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        return;
    }
    
    [[CoreDataManager sharedManager] saveWithBlock:^(NSManagedObjectContext *context) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dayNumber == %@ AND periodNumber == %@", self.classData.dayNumber, self.classData.periodNumber];
        ClassData *data = [[CoreDataManager sharedManager] fetchOneRequestWithEntityName:@"ClassData" predicate:predicate];
        if (!data) {
            data = [[ClassData alloc] initWithEntity:[NSEntityDescription entityForName:@"ClassData" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
            data.classDataId = [[NSUUID UUID] UUIDString];
            data.color = [NSNumber numberWithInt:arc4random_uniform(10)];
        }
        
        data.dayNumber = [NSNumber numberWithInteger:self.dayNumber];
        data.periodNumber = [NSNumber numberWithInteger:self.periodNumber];
        data.name = self.nameTextField.text;
        data.place = self.placeTextField.text;
        data.teacher = self.teacherTextField.text;
        data.note = self.noteTextField.text;
    } completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_REDRAW_GRID object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_REDRAW_LIST object:nil];
        if ([_delegate respondsToSelector:@selector(closePopup)]) {
            [_delegate closePopup];
        }
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"授業を登録しました。" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"閉じる" style:UIAlertActionStyleCancel handler:nil]];
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
    }];
}

- (void)delete
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"授業を削除します。\nよろしいですか？" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"キャンセル" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[CoreDataManager sharedManager] saveWithBlock:^(NSManagedObjectContext *context) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dayNumber == %@ AND periodNumber == %@", self.classData.dayNumber, self.classData.periodNumber];
            ClassData *data = [[CoreDataManager sharedManager] fetchOneRequestWithEntityName:@"ClassData" predicate:predicate];
            [context deleteObject:data];
        } completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_REDRAW_GRID object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_REDRAW_LIST object:nil];
            if ([_delegate respondsToSelector:@selector(closePopup)]) {
                [_delegate closePopup];
            }
        }];
    }]];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (!textField.inputAccessoryView) {
        UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
        textField.inputAccessoryView = toolBar;
        UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完了" style:UIBarButtonItemStyleDone target:self action:@selector(closeKeyboard)];
        UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        toolBar.items = @[flex, doneBtn];
    }
    
    if (!self.recognizer) {
        self.recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard)];
        [self addGestureRecognizer:self.recognizer];
        [self.superview addGestureRecognizer:self.recognizer];
        [self.recognizer addTarget:self action:@selector(closeKeyboard)];
    }
    
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y-textField.tag*20, self.frame.size.width, self.frame.size.height);
                     } completion:nil];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y+textField.tag*20, self.frame.size.width, self.frame.size.height);
                     } completion:nil];
    
    return YES;
}

- (void)closeKeyboard
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            [textField resignFirstResponder];
        }
    }
}

@end
