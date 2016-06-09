//
//  InputViewController.m
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/05/28.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import "InputViewController.h"
#import "HistoryTableViewCell.h"

#import "ContainerViewController.h"
#import "DailyContainerViewController.h"
#import "DailyTableViewController.h"

@interface InputViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) NSInteger dayNumber;
@property (nonatomic) NSInteger periodNumber;
@property (nonatomic, strong) ClassData *classData;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *place;
@property (nonatomic, strong) NSString *teacher;
@property (nonatomic, strong) NSString *note;
@property (nonatomic) NSInteger color;

//@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextField *nameTextField;
@property (nonatomic, strong) UITextField *placeTextField;
@property (nonatomic, strong) UITextField *teacherTextField;
@property (nonatomic, strong) UITextField *noteTextField;
@property (nonatomic, strong) UITapGestureRecognizer *recognizer;
@property (nonatomic) BOOL enableSave;

@property (nonatomic, strong) UILabel *attendLabel;
@property (nonatomic, strong) UILabel *absentLabel;
@property (nonatomic, strong) UILabel *lateLabel;

@property (nonatomic, strong) NSMutableArray *histories;
@property (nonatomic, strong) UITableView *historyTableView;
@property (nonatomic, strong) UITextField *currentDateField;

@end

@implementation InputViewController

- (instancetype)initWithClassData:(ClassData *)classData dayNumber:(NSInteger)dayNumber periodNumber:(NSInteger)periodNumber
{
    if ([super init]) {
        self.classData = classData;
        self.dayNumber = dayNumber;
        self.periodNumber = periodNumber;
        self.histories = [NSMutableArray array];
        self.color = classData ? [classData.color integerValue] : arc4random_uniform(10);
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    UINavigationController *nav = (UINavigationController *)[[[UIApplication sharedApplication] keyWindow] rootViewController];
    ContainerViewController *containerVC = nav.childViewControllers[0];
    if ([containerVC.childViewControllers[0] isKindOfClass:[DailyContainerViewController class]]) {
        DailyContainerViewController *dailyContaineVC = containerVC.childViewControllers[0];
        DailyTableViewController *dailyVC = dailyContaineVC.controllers[self.dayNumber-1];
        [dailyVC reload];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // スクロールビュー
    [self.scrollView setFrame:self.view.frame];
    [self.scrollView addSubview:self.contentView];
    [self.contentView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1000)];
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 1000)];
    
    // カラーパネル
    int col = 0;
    int row = 0;
    NSArray *colorCodes = @[@"d16f6b", @"ec513b", @"f7a644", @"fce984", @"b4db6d", @"43d593", @"a0e0e8", @"4a85e8", @"ba9aff", @"f790b4"];
    for (int i = 0; i < [colorCodes count]; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20+col*40, 20+row*40, 30, 30)];
        btn.tag = i;
        [btn addTarget:self action:@selector(colorDidSelect:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [CommonUtil colorFromHexCode:colorCodes[i]];
        [self.colorSectionView addSubview:btn];
        
        if (i == self.color) {
            [btn setImage:[UIImage imageNamed:@"checkmark"] forState:UIControlStateNormal];
        }
        
        if (20+col*40 > SCREEN_WIDTH-100) {
            col = 0;
            row++;
        } else {
            col++;
        }
    }
}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    self.dayNumber = 1;
//    self.periodNumber = 1;
//
//    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-108)];
//    self.scrollView.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.scrollView];
//    
//    {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 120, 30)];
//        NSString *dayString = @[@"月曜日", @"火曜日", @"水曜日", @"木曜日", @"金曜日", @"土曜日", @"日曜日"][_dayNumber-1];
//        label.text = [NSString stringWithFormat:@"%@ %ld限", dayString, (long)_periodNumber];
//        label.textColor = [UIColor whiteColor];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = [UIFont boldSystemFontOfSize:17];
//        self.navigationItem.titleView = label;
//    }
//    
//    // 授業名（必須）
//    {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 120, 20)];
//        label.text = @"授業名（必須）";
//        label.font = [UIFont systemFontOfSize:14];
//        [self.scrollView addSubview:label];
//        
//        self.nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 35, SCREEN_WIDTH-40, 30)];
//        self.nameTextField.text = _classData ? _classData.name : nil;
//        self.nameTextField.backgroundColor = COLOR_GRAY;
//        self.nameTextField.font = [UIFont systemFontOfSize:15];
//        self.nameTextField.layer.cornerRadius = 4.0;
//        self.nameTextField.clipsToBounds = YES;
//        self.nameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
//        self.nameTextField.delegate = self;
//        self.nameTextField.tag = 1;
//        [self.scrollView addSubview:self.nameTextField];
//    }
//    
//    // 教室
//    {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 100, 20)];
//        label.text = @"教室";
//        label.font = [UIFont systemFontOfSize:14];
//        [self.scrollView addSubview:label];
//        
//        self.placeTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 100, SCREEN_WIDTH-40, 30)];
//        self.placeTextField.text = _classData ? _classData.place : nil;
//        self.placeTextField.backgroundColor = COLOR_GRAY;
//        self.placeTextField.font = [UIFont systemFontOfSize:15];
//        self.placeTextField.layer.cornerRadius = 4.0;
//        self.placeTextField.clipsToBounds = YES;
//        self.placeTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
//        self.placeTextField.delegate = self;
//        self.placeTextField.tag = 2;
//        [self.scrollView addSubview:self.placeTextField];
//    }
//    
//    // 先生
//    {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 140, 100, 20)];
//        label.text = @"先生";
//        label.font = [UIFont systemFontOfSize:14];
//        [self.scrollView addSubview:label];
//        
//        self.teacherTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 165, SCREEN_WIDTH-40, 30)];
//        self.teacherTextField.text = _classData ? _classData.teacher : nil;
//        self.teacherTextField.backgroundColor = COLOR_GRAY;
//        self.teacherTextField.font = [UIFont systemFontOfSize:15];
//        self.teacherTextField.layer.cornerRadius = 4.0;
//        self.teacherTextField.clipsToBounds = YES;
//        self.teacherTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
//        self.teacherTextField.delegate = self;
//        self.teacherTextField.tag = 3;
//        [self.scrollView addSubview:self.teacherTextField];
//    }
//    
//    // 備考
//    {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 205, 100, 20)];
//        label.text = @"備考";
//        label.font = [UIFont systemFontOfSize:14];
//        [self.scrollView addSubview:label];
//        
//        self.noteTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 230, SCREEN_WIDTH-40, 30)];
//        self.noteTextField.text = _classData ? _classData.note : nil;
//        self.noteTextField.backgroundColor = COLOR_GRAY;
//        self.noteTextField.font = [UIFont systemFontOfSize:15];
//        self.noteTextField.layer.cornerRadius = 4.0;
//        self.noteTextField.clipsToBounds = YES;
//        self.noteTextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0);
//        self.noteTextField.delegate = self;
//        self.noteTextField.tag = 4;
//        [self.scrollView addSubview:self.noteTextField];
//    }
//    
//    // 色
//    {
//        int col = 0;
//        int row = 0;
//        NSArray *colorCodes = @[@"d16f6b", @"ec513b", @"f7a644", @"fce984", @"b4db6d", @"43d593", @"a0e0e8", @"4a85e8", @"ba9aff", @"f790b4"];
//        for (int i = 0; i < [colorCodes count]; i++) {
//            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(20+col*40, 280+row*40, 30, 30)];
//            btn.tag = i;
//            [btn addTarget:self action:@selector(colorDidSelect:) forControlEvents:UIControlEventTouchUpInside];
//            btn.backgroundColor = [CommonUtil colorFromHexCode:colorCodes[i]];
//            [self.scrollView addSubview:btn];
//            
//            if (i == self.color) {
//                [btn setImage:[UIImage imageNamed:@"checkmark"] forState:UIControlStateNormal];
//            }
//            
//            if (20+col*40 > SCREEN_WIDTH-100) {
//                col = 0;
//                row++;
//            } else {
//                col++;
//            }
//        }
//    }
//    
//    {
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 360, SCREEN_WIDTH-20, 30)];
//        label.text = @"出欠管理";
//        label.font = [UIFont systemFontOfSize:14];
//        [self.scrollView addSubview:label];
//    }
//    
//    // 日付
//    {
//        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//        dateFormatter.dateFormat = @"yyyy年 M月 d日（E）";
//        
//        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
//        datePicker.datePickerMode = UIDatePickerModeDate;
//        datePicker.backgroundColor = [UIColor whiteColor];
//        [datePicker addTarget:self action:@selector(updateDateField:) forControlEvents:UIControlEventValueChanged];
//        
//        self.currentDateField = [[UITextField alloc] initWithFrame:CGRectMake(0, 390, SCREEN_WIDTH, 44)];
//        self.currentDateField.inputView = datePicker;
//        self.currentDateField.text = [dateFormatter stringFromDate:[NSDate date]];
//        self.currentDateField.textColor = [CommonUtil colorFromHexCode:@"4a4a4a"];
//        self.currentDateField.font = [UIFont systemFontOfSize:15];
//        self.currentDateField.textAlignment = NSTextAlignmentLeft;
//        self.currentDateField.layer.borderColor = COLOR_GRAY.CGColor;
//        self.currentDateField.layer.borderWidth = 1.0;
//        self.currentDateField.layer.sublayerTransform = CATransform3DMakeTranslation(20, 0, 0);
//        self.currentDateField.delegate = self;
//        self.currentDateField.tag = 5;
//        self.currentDateField.tintColor = [UIColor clearColor];
//        [self.scrollView addSubview:self.currentDateField];
//        
//        UIImageView *iconDown = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-60, 14, 20, 20)];
//        iconDown.image = [UIImage imageNamed:@"icon_down"];
//        [self.currentDateField addSubview:iconDown];
//    }
//    
//    // 出席
//    {
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(40, 450, 60, 60)];
//        btn.backgroundColor = [CommonUtil colorFromHexCode:@"4c8ffb"];
//        btn.layer.cornerRadius = 30;
//        btn.tag = 1;
//        [btn addTarget:self action:@selector(btnDidTap:) forControlEvents:UIControlEventTouchUpInside];
//        [self.scrollView addSubview:btn];
//        
//        self.attendLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 30, 30)];
//        self.attendLabel.textColor = [UIColor whiteColor];
//        self.attendLabel.font = [UIFont boldSystemFontOfSize:18];
//        self.attendLabel.textAlignment = NSTextAlignmentCenter;
//        [btn addSubview:self.attendLabel];
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 34, 30, 20)];
//        label.text = @"出席";
//        label.textColor = [UIColor whiteColor];
//        label.font = [UIFont systemFontOfSize:12];
//        label.textAlignment = NSTextAlignmentCenter;
//        [btn addSubview:label];
//    }
//    
//    // 欠席
//    {
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, 450, 60, 60)];
//        btn.backgroundColor = [CommonUtil colorFromHexCode:@"ff1493"];
//        btn.layer.cornerRadius = 30;
//        btn.tag = 2;
//        [btn addTarget:self action:@selector(btnDidTap:) forControlEvents:UIControlEventTouchUpInside];
//        [self.scrollView addSubview:btn];
//        
//        self.absentLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 30, 30)];
//        self.absentLabel.textColor = [UIColor whiteColor];
//        self.absentLabel.font = [UIFont boldSystemFontOfSize:18];
//        self.absentLabel.textAlignment = NSTextAlignmentCenter;
//        [btn addSubview:self.absentLabel];
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 34, 30, 20)];
//        label.text = @"欠席";
//        label.textColor = [UIColor whiteColor];
//        label.font = [UIFont systemFontOfSize:12];
//        label.textAlignment = NSTextAlignmentCenter;
//        [btn addSubview:label];
//    }
//    
//    // 遅刻
//    {
//        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, 450, 60, 60)];
//        btn.backgroundColor = [CommonUtil colorFromHexCode:@"F5A623"];
//        btn.layer.cornerRadius = 30;
//        btn.tag = 3;
//        [btn addTarget:self action:@selector(btnDidTap:) forControlEvents:UIControlEventTouchUpInside];
//        [self.scrollView addSubview:btn];
//        
//        self.lateLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 30, 30)];
//        self.lateLabel.textColor = [UIColor whiteColor];
//        self.lateLabel.font = [UIFont boldSystemFontOfSize:18];
//        self.lateLabel.textAlignment = NSTextAlignmentCenter;
//        [btn addSubview:self.lateLabel];
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 34, 30, 20)];
//        label.text = @"遅刻";
//        label.textColor = [UIColor whiteColor];
//        label.font = [UIFont systemFontOfSize:12];
//        label.textAlignment = NSTextAlignmentCenter;
//        [btn addSubview:label];
//    }
//    
//    // 履歴
//    {
//        self.historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 530, SCREEN_WIDTH, 0) style:UITableViewStylePlain];
//        self.historyTableView.delegate = self;
//        self.historyTableView.dataSource = self;
//        self.historyTableView.allowsSelection = NO;
//        [self.historyTableView registerClass:[HistoryTableViewCell class] forCellReuseIdentifier:@"historyCell"];
//        [self.scrollView addSubview:self.historyTableView];
//    }
//    [self reloadHistoryData];
//    
//    // 削除ボタン
//    if (_classData) {
//        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-44-64, SCREEN_WIDTH/2, 44)];
//        [deleteBtn setTitle:@"削除" forState:UIControlStateNormal];
//        deleteBtn.backgroundColor = [CommonUtil colorFromHexCode:@"ddd"];
//        [deleteBtn setTitleColor:[CommonUtil colorFromHexCode:@"4a4a4a"] forState:UIControlStateNormal];
//        deleteBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//        [deleteBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:deleteBtn];
//    }
//    
//    // 登録ボタン
//    CGFloat x = _classData ? SCREEN_WIDTH/2 : 0;
//    CGFloat width = _classData ? SCREEN_WIDTH/2 : SCREEN_WIDTH;
//    NSString *title = _classData ? @"保存" : @"登録";
//    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, self.view.frame.size.height-44-64, width, 44)];
//    [saveBtn setTitle:title forState:UIControlStateNormal];
//    saveBtn.backgroundColor = [CommonUtil colorFromHexCode:@"4c8ffb"];
//    saveBtn.titleLabel.font = [UIFont systemFontOfSize:14];
//    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:saveBtn];
//}

#pragma mark - UITableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.histories count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryTableViewCell *cell = (HistoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"historyCell"];
    if (!cell) {
        cell = [[HistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"historyCell"];
    }
    
    cell.dateLabel.text = nil;
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            if (![label isEqual:cell.dateLabel]) {
                label.textColor = COLOR_GRAY;
            }
        }
    }
    
    HistoryData *historyData = self.histories[indexPath.row];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年 M月 d日（E）";
    cell.dateLabel.text = [dateFormatter stringFromDate:historyData.createdDate];
    cell.attendanceType = historyData.attendanceType;
    
    return cell;
}

- (void)reloadHistoryData
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"classDataId == %@", _classData.classDataId];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO];
    self.histories = [[[CoreDataManager sharedManager] fetchRequestWithEntityName:@"HistoryData" predicate:predicate sortDescriptors:@[sortDescriptor]] mutableCopy];
    
    NSInteger attend = 0;
    NSInteger absent = 0;
    NSInteger late = 0;
    for (HistoryData *historyData in self.histories) {
        if (historyData.attendanceType == AttendanceTypeAttend) {
            attend++;
        } else if (historyData.attendanceType == AttendanceTypeAbsent) {
            absent++;
        } else if (historyData.attendanceType == AttendanceTypeLate) {
            late++;
        }
    }
    self.attendLabel.text = [NSString stringWithFormat:@"%ld", (long)attend];
    self.absentLabel.text = [NSString stringWithFormat:@"%ld", (long)absent];
    self.lateLabel.text = [NSString stringWithFormat:@"%ld", (long)late];
    
    self.historyTableView.frame = CGRectMake(0, 530, SCREEN_WIDTH, [self.histories count]*44);
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 580 + self.historyTableView.frame.size.height);
    
    [self.historyTableView reloadData];
    
    [[self.scrollView viewWithTag:40] removeFromSuperview];
    if (self.histories.count) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 535+[self.histories count]*44, 200, 20)];
        label.tag = 40;
        label.text = @"左にスワイプで出欠を削除";
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = COLOR_BLACK;
        [self.scrollView addSubview:label];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    HistoryData *historyData = self.histories[indexPath.row];
    [[CoreDataManager sharedManager] saveWithBlock:^(NSManagedObjectContext *context) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"historyDataId == %@", historyData.historyDataId];
        HistoryData *historyData = [[CoreDataManager sharedManager] fetchOneRequestWithEntityName:@"HistoryData" predicate:predicate];
        [context deleteObject:historyData];
        [self.histories removeObjectAtIndex:indexPath.row];
    } completion:^{
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self performSelector:@selector(reloadHistoryData) withObject:nil afterDelay:0.1];
    }];
}

#pragma mark - UITextField Delegate

- (void)updateDateField:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年 M月 d日（E）";
    self.currentDateField.text = [dateFormatter stringFromDate:sender.date];
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
        [self.scrollView addGestureRecognizer:self.recognizer];
        [self.recognizer addTarget:self action:@selector(closeKeyboard)];
    }
    
    [self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.y-30) animated:YES];
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    return YES;
}

- (void)closeKeyboard
{
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            [textField resignFirstResponder];
        }
    }
}

#pragma mark - button event

- (void)btnDidTap:(UIButton *)sender
{
    [[CoreDataManager sharedManager] saveWithBlock:^(NSManagedObjectContext *context) {
        HistoryData *historyData = [[HistoryData alloc] initWithEntity:[NSEntityDescription entityForName:@"HistoryData" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
        historyData.historyDataId = [[NSUUID UUID] UUIDString];
        historyData.classDataId = self.classData.classDataId;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = @"yyyy年 M月 d日（E）";
        historyData.createdDate = [dateFormatter dateFromString:self.currentDateField.text];
        historyData.attendanceType = sender.tag;
    } completion:^{
        [self reloadHistoryData];
    }];
}

- (void)colorDidSelect:(UIButton *)sender
{
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)view;
            [btn setImage:nil forState:UIControlStateNormal];
        }
    }
    [sender setImage:[UIImage imageNamed:@"checkmark"] forState:UIControlStateNormal];
    self.color = sender.tag;
}

- (void)save
{
    if (!self.nameTextField.text.length) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 200, 20)];
        label.text = @"授業名は必須項目です。";
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = [UIColor redColor];
        label.textAlignment = NSTextAlignmentCenter;
        [self.scrollView addSubview:label];
        
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        return;
    }
    
    [[CoreDataManager sharedManager] saveWithBlock:^(NSManagedObjectContext *context) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dayNumber == %@ AND periodNumber == %@", self.classData.dayNumber, self.classData.periodNumber];
        ClassData *data = [[CoreDataManager sharedManager] fetchOneRequestWithEntityName:@"ClassData" predicate:predicate];
        if (!data) {
            data = [[ClassData alloc] initWithEntity:[NSEntityDescription entityForName:@"ClassData" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
            data.classDataId = [[NSUUID UUID] UUIDString];
        }
        
        data.dayNumber = [NSNumber numberWithInteger:self.dayNumber];
        data.periodNumber = [NSNumber numberWithInteger:self.periodNumber];
        data.name = self.nameTextField.text;
        data.place = self.placeTextField.text;
        data.teacher = self.teacherTextField.text;
        data.note = self.noteTextField.text;
        data.color = [NSNumber numberWithInteger:self.color];
    } completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_REDRAW_GRID object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_REDRAW_LIST object:nil];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"授業を登録しました。" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"閉じる" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }]];
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
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }]];
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertController animated:YES completion:nil];
}

@end
