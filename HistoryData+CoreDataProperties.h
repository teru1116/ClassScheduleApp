//
//  HistoryData+CoreDataProperties.h
//  
//
//  Created by teruyakusumoto on 2016/05/28.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HistoryData.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int16_t, AttendanceType) {
    AttendanceTypeAttend = 1,   // 出席
    AttendanceTypeAbsent,       // 欠席
    AttendanceTypeLate,         // 遅刻
};

@interface HistoryData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *historyDataId;
@property (nullable, nonatomic, retain) NSString *classDataId;
@property (nullable, nonatomic, retain) NSDate *createdDate;
@property (nonatomic) AttendanceType attendanceType;

@end

NS_ASSUME_NONNULL_END
