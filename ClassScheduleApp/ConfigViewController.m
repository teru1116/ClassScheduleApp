//
//  ConfigViewController.m
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/04/09.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import "ConfigViewController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <sys/utsname.h>
#import "ConfigTableViewCell.h"

#import "DaoEvents.h"
#import "Event.h"
#import "SVProgressHUD.h"

@interface ConfigViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic) ConfigViewType configViewType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *editingTextField;

@end

@implementation ConfigViewController

- (instancetype)initWithConfigViewType:(ConfigViewType)configViewType
{
    if (self = [super init]) {
        self.configViewType = configViewType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = COLOR_GRAY;
    [self.view addSubview:self.tableView];
    
    if (self.configViewType == ConfigViewTypeTime) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 90, 200, 20)];
        label.text = @"タップして時刻を編集できます。";
        label.font = [UIFont systemFontOfSize:13];
        [self.view addSubview:label];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.configViewType == ConfigViewTypeRoot) {
        return 3;
    } else if (self.configViewType == ConfigViewTypeTime) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.configViewType == ConfigViewTypeRoot) {
        if (section == 0) {
            return 3;
        }
        return 1;
    } else if (self.configViewType == ConfigViewTypePeriod) {
        return 5;
    } else if (self.configViewType == ConfigViewTypeDays) {
        return 3;
    } else if (self.configViewType == ConfigViewTypeTime) {
        if (section == 0) {
            return 1;
        } else if (section == 1) {
            return [CommonUtil periodCount];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConfigTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ConfigTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSArray *items = nil;
    if (self.configViewType == ConfigViewTypeRoot) {
        items = @[@[@"最大時限数", @"土日の有無", @"時間の設定"], @[@"以前の授業データを復元"], @[@"お問い合わせ・要望"]];
        if (indexPath.section == 0) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    } else if (self.configViewType == ConfigViewTypePeriod) {
        items = @[@[@"4限", @"5限", @"6限", @"7限", @"8限"]];
        cell.accessoryType = [CommonUtil periodCount]-4 == indexPath.row ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    } else if (self.configViewType == ConfigViewTypeDays) {
        items = @[@[@"平日のみ", @"土曜あり", @"土日あり"]];
        cell.accessoryType = [CommonUtil dayCount]-5 == indexPath.row ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    }
    cell.textLabel.text = items[indexPath.section][indexPath.row];
    
    if (self.configViewType == ConfigViewTypeTime) {
        if (indexPath.section == 0) {
            cell.textLabel.text = @"授業時間を表示する";
            cell.accessoryType = [CommonUtil showsTime] ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
        } else if (indexPath.section == 1) {
            cell.isTimeSetting = YES;
            cell.textLabel.text = [NSString stringWithFormat:@"%ld限", (long)indexPath.row+1];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"H:mm";
            cell.startTimeTextField.text = [dateFormatter stringFromDate:[CommonUtil startTimes][indexPath.row]];
            cell.endingTimeTextField.text = [dateFormatter stringFromDate:[CommonUtil endingTimes][indexPath.row]];
            cell.datePicker.date = [CommonUtil startTimes][indexPath.row];
            
            cell.startTimeTextField.tag = indexPath.row;
            cell.endingTimeTextField.tag = indexPath.row;
            cell.startTimeTextField.delegate = self;
            cell.endingTimeTextField.delegate = self;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    // 設定画面トップ
    if (self.configViewType == ConfigViewTypeRoot) {
        ConfigViewController *vc = nil;
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                vc = [[ConfigViewController alloc] initWithConfigViewType:ConfigViewTypePeriod];
//                vc.title = @"最大時限数";
            } else if (indexPath.row == 1) {
                vc = [[ConfigViewController alloc] initWithConfigViewType:ConfigViewTypeDays];
//                vc.title = @"土日の有無";
            } else if (indexPath.row == 2) {
                vc = [[ConfigViewController alloc] initWithConfigViewType:ConfigViewTypeTime];
//                vc.title = @"授業時間の設定";
            }
            [self.navigationController pushViewController:vc animated:YES];
        // 過去データ復元
        } else if (indexPath.section == 1) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"2016年6月1日以前のデータを復元" message:@"バージョン1（2016年6月1日以前）に登録していた授業データを復元します。\nただし、新たに授業を登録し直していた場合、そのコマに関しては新たに登録したほうの授業データが表示されます。" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"復元する" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                // 過去データ復元
                [SVProgressHUD showWithStatus:@"データ復元中"];
                DaoEvents *daoEvents = [[DaoEvents alloc] init];
                NSArray *oldData = [daoEvents events];
                if ([oldData count] != 0) {
                    [[CoreDataManager sharedManager] saveWithBlock:^(NSManagedObjectContext *context) {
                        for (Event *event in oldData) {
                            if (event.title.length > 1) {
                                NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"dayNumber == %@ AND periodNumber == %@", [NSNumber numberWithInteger:event.dayNumber], [NSNumber numberWithInteger:event.period]]];
                                ClassData *classData = [[CoreDataManager sharedManager] fetchOneRequestWithEntityName:@"ClassData" predicate:predicate];
                                if (!classData) {
                                    classData = [[ClassData alloc] initWithEntity:[NSEntityDescription entityForName:@"ClassData" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
                                    classData.classDataId = [[NSUUID UUID] UUIDString];
                                    classData.color = [NSNumber numberWithInt:arc4random_uniform(10)];
                                    classData.dayNumber = [NSNumber numberWithInteger:event.dayNumber];
                                    classData.periodNumber = [NSNumber numberWithInteger:event.period];
                                    classData.name = event.title;
                                    classData.place = event.place;
                                    classData.teacher = event.lecturer;
                                    classData.note = event.memo;
                                }
                            }
                        }
                    } completion:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_REDRAW_GRID object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_REDRAW_LIST object:nil];
                        [SVProgressHUD showSuccessWithStatus:@"復元が完了しました"];
                    }];
                } else {
                    [SVProgressHUD showSuccessWithStatus:@"復元できるデータはありませんでした"];
                }
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:@"キャンセル" style:UIAlertActionStyleCancel handler:nil]];
            [self presentViewController:alertController animated:YES completion:nil];
        // お問い合わせ
        } else if (indexPath.section == 2) {
            Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
            if (mailClass) {
                MFMailComposeViewController *mailPicker = [[MFMailComposeViewController alloc] init];
                mailPicker.mailComposeDelegate = self;
                [mailPicker setSubject:@"時間割アプリに関するお問い合わせ・要望"];
                struct utsname systemInfo;
                uname(&systemInfo);
                NSString *messageBosy = [NSString stringWithFormat:@"\n\n\n\n\n機種 : %@\nOS : %@\nアプリのバージョン : %@", [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding], [[UIDevice currentDevice] systemVersion], [[NSBundle mainBundle] infoDictionary][@"CFBundleVersion"]];
                [mailPicker setMessageBody:messageBosy isHTML:NO];
                [mailPicker setToRecipients:@[@"teruyakusumoto@gmail.com"]];
                if ([mailClass canSendMail]) {
                    [self presentViewController:mailPicker animated:YES completion:nil];
                }
            }
        }
    // 時限数設定
    } else if (self.configViewType == ConfigViewTypePeriod) {
        // チェックマーク
        for (UITableViewCell *cell in [tableView visibleCells]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        // 変更を反映
        [CommonUtil setPeriodCount:indexPath.row+4];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_REDRAW_GRID object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_REDRAW_LIST object:nil];
    // 曜日設定
    } else if (self.configViewType == ConfigViewTypeDays) {
        // チェックマーク
        for (UITableViewCell *cell in [tableView visibleCells]) {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        // 変更を反映
        [CommonUtil setDayCount:indexPath.row+5];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_REDRAW_GRID object:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_REDRAW_LIST object:nil];
    } else if (self.configViewType == ConfigViewTypeTime) {
        if (indexPath.section == 0) {
            // チェックマーク
            cell.accessoryType = cell.accessoryType == UITableViewCellAccessoryCheckmark ? UITableViewCellAccessoryNone : UITableViewCellAccessoryCheckmark;
            [CommonUtil setShowsTime:cell.accessoryType == UITableViewCellAccessoryCheckmark];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_REDRAW_GRID object:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_REDRAW_LIST object:nil];
        }
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self closeKeyboard];
    self.editingTextField = textField;
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker.backgroundColor = [UIColor whiteColor];
    [datePicker addTarget:self action:@selector(updateDateField:) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完了" style:UIBarButtonItemStyleDone target:self action:@selector(closeKeyboard)];
    UIBarButtonItem *flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBar.items = @[flex, doneBtn];
    
    textField.inputView = datePicker;
    textField.inputAccessoryView = toolBar;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"H:mm";
    datePicker.date = [dateFormatter dateFromString:textField.text];
    
    return YES;
}

- (void)updateDateField:(UIDatePicker *)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"H:mm";
    self.editingTextField.text = [dateFormatter stringFromDate:sender.date];
}

- (void)closeKeyboard
{
    for (ConfigTableViewCell *cell in [self.tableView visibleCells]) {
        [cell.startTimeTextField resignFirstResponder];
        [cell.endingTimeTextField resignFirstResponder];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"H:mm";
    if (self.editingTextField.frame.origin.x < SCREEN_WIDTH-120) {
        [CommonUtil setStartTime:[dateFormatter dateFromString:textField.text] AtPeriond:textField.tag+1];
    } else {
        [CommonUtil setEndingTime:[dateFormatter dateFromString:textField.text] AtPeriond:textField.tag+1];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_REDRAW_GRID object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTICE_REDRAW_LIST object:nil];
    
    self.editingTextField = nil;
    return YES;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(nullable NSError *)error
{
    [controller dismissViewControllerAnimated:YES completion:nil];

    NSString *message = @"";
    if (result == MFMailComposeResultSent) {
        message = @"お問い合わせ内容を受け付けました。\n追って運営よりご連絡させていただきます。";
    } else if (result == MFMailComposeResultSaved) {
        message = @"メールを下書き保存しました。";
    } else if (result == MFMailComposeResultFailed) {
        message = @"送信に失敗しました。ネットワークの接続状態をご確認いただくか、後ほどお試しください。";
    }
    
    if (result != MFMailComposeResultCancelled) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
