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
    
    // タイトル
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 120, 30)];
    NSString *dayString = @[@"月曜日", @"火曜日", @"水曜日", @"木曜日", @"金曜日", @"土曜日", @"日曜日"][_dayNumber-1];
    titleLabel.text = [NSString stringWithFormat:@"%@ %ld限", dayString, (long)_periodNumber];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:17];
    self.navigationItem.titleView = titleLabel;
    
    // スクロールビュー
    [self.scrollView setFrame:self.view.frame];
    [self.scrollView addSubview:self.contentView];
    [self.contentView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1000)];
    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, 1000)];
    
    // FIXME: Interface Builder使ってコードごっそりなくしたい
    // ボーダー
    UIColor *borderColor = [CommonUtil colorFromHexCode:@"e3e4e5"];
    {
        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        border.backgroundColor = borderColor;
        [self.basicInfoSectionView addSubview:border];
    }
    {
        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, self.basicInfoSectionView.frame.size.height-1, SCREEN_WIDTH, 1)];
        border.backgroundColor = borderColor;
        [self.basicInfoSectionView addSubview:border];
    }
    {
        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        border.backgroundColor = borderColor;
        [self.colorSectionView addSubview:border];
    }
    {
        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, self.colorSectionView.frame.size.height-1, SCREEN_WIDTH, 1)];
        border.backgroundColor = borderColor;
        [self.colorSectionView addSubview:border];
    }
    {
        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        border.backgroundColor = borderColor;
        [self.attendanceSectionView addSubview:border];
    }
    {
        UIView *border = [[UIView alloc] initWithFrame:CGRectMake(0, self.attendanceSectionView.frame.size.height-1, SCREEN_WIDTH, 1)];
        border.backgroundColor = borderColor;
        [self.attendanceSectionView addSubview:border];
    }
    
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
    
    // 日付セレクトボックス
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy年 M月 d日（E）";
    self.dateSelectField.text = [dateFormatter stringFromDate:[NSDate date]];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.backgroundColor = [UIColor whiteColor];
    [datePicker addTarget:self action:@selector(updateDateField:) forControlEvents:UIControlEventValueChanged];
    self.dateSelectField.inputView = datePicker;
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 30)];
    self.dateSelectField.leftView = paddingView;
    self.dateSelectField.leftViewMode = UITextFieldViewModeAlways;
}

//- (void)viewDidLoad
//{
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
    self.dateSelectField.text = [dateFormatter stringFromDate:sender.date];
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
        [self.contentView addGestureRecognizer:self.recognizer];
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
    for (UIView *view in self.contentView.subviews) {
        for (UIView *subView in view.subviews) {
            if ([subView isKindOfClass:[UITextField class]]) {
                UITextField *textField = (UITextField *)subView;
                [textField resignFirstResponder];
            }
        }
    }
}

#pragma mark - button event

- (IBAction)attendanceBtnDidTap:(UIButton *)sender
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
    for (UIView *view in self.colorSectionView.subviews) {
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
