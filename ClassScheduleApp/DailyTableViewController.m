//
//  DailyTableViewController.m
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/04/09.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import "DailyTableViewController.h"
#import "DailyTableViewCell.h"
#import "InputViewController.h"

@interface DailyTableViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) DayNumber dayNumber;
@property (nonatomic, strong) NSArray *results;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation DailyTableViewController

- (instancetype)initWithDayNumber:(DayNumber)dayNumber
{
    if (self = [super init]) {
        self.dayNumber = dayNumber;
        self.title = @[@"Mon", @"Tue", @"Wed", @"Thu", @"Fri", @"Sat", @"Sun"][self.dayNumber];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = COLOR_GRAY;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dayNumber == %d", self.dayNumber+1];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"periodNumber" ascending:YES];
    self.results = [[CoreDataManager sharedManager] fetchRequestWithEntityName:@"ClassData" predicate:predicate sortDescriptors:@[sortDescriptor]];
    
    CGFloat marginTop = [[UIApplication sharedApplication] statusBarFrame].size.height + 64;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-marginTop-40) style:UITableViewStylePlain];
    self.tableView.backgroundColor = COLOR_GRAY;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"DailyTableViewCell" bundle:nil] forCellReuseIdentifier:@"DailyTableViewCell"];
    [self.view addSubview:self.tableView];
}

- (void)reload
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"dayNumber == %d", self.dayNumber+1];
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"periodNumber" ascending:YES];
    self.results = [[CoreDataManager sharedManager] fetchRequestWithEntityName:@"ClassData" predicate:predicate sortDescriptors:@[sortDescriptor]];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [CommonUtil periodCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DailyTableViewCell *cell = (DailyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"DailyTableViewCell"];
    if (!cell) {
        cell = [[DailyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DailyTableViewCell"];
    }
    
    cell.classData = nil;
    cell.colorView.backgroundColor = [UIColor clearColor];
    for (UIView *view in cell.contentView.subviews) {
        if ([view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)view;
            label.text = nil;
        }
        if (view.tag == 10) {
            [view removeFromSuperview];
        }
    }
    cell.classIcon.hidden = YES;
    cell.teacherIcon.hidden = YES;
    cell.pencilIcon.hidden = YES;
    cell.timeLabel.hidden = YES;
    
    cell.periodLabel.text = [NSString stringWithFormat:@"%ld限", indexPath.row+1];
    for (ClassData *classData in self.results) {
        if ([classData.periodNumber isEqualToNumber:[NSNumber numberWithInteger:indexPath.row+1]]) {
            cell.classData = classData;
            break;
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DailyTableViewCell *cell = (DailyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    InputViewController *vc = [[InputViewController alloc] initWithClassData:cell.classData dayNumber:_dayNumber+1 periodNumber:indexPath.row+1];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
