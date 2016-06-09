//
//  CoreDataManager.h
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/04/09.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataManager : NSObject

+ (CoreDataManager *)sharedManager;
- (NSManagedObjectContext *)managedObjectContext;

/// INSERT
- (void)saveWithBlock:(void (^)(NSManagedObjectContext *context))block completion:(void (^)(void))completion;

/// SELECT
- (id)fetchOneRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate;
- (id)fetchRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate;
- (id)fetchRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;
- (id)fetchRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors limit:(NSInteger)limit;
- (id)fetchRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors fetchProperties:(NSArray*)fetchProperties;
- (id)fetchAllWithEntityName:(NSString *)entityName;

/// DELETE ALL
- (void)deleteAll;

@end
