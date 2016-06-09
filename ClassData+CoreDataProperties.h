//
//  ClassData+CoreDataProperties.h
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/04/09.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ClassData.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClassData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *classDataId;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *dayNumber;
@property (nullable, nonatomic, retain) NSNumber *periodNumber;
@property (nullable, nonatomic, retain) NSString *place;
@property (nullable, nonatomic, retain) NSString *teacher;
@property (nullable, nonatomic, retain) NSString *note;
@property (nullable, nonatomic, retain) NSNumber *color;

@end

NS_ASSUME_NONNULL_END
