//
//  CoreDataManager.m
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/04/09.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import "CoreDataManager.h"

static CoreDataManager *_sharedManager;

@implementation CoreDataManager
{
    NSManagedObjectContext *_mainThreadContext;
    NSManagedObjectContext *_bgThreadContext;
    NSPersistentStoreCoordinator *_persistentStoreCoordinator;
    NSManagedObjectModel *_managedObjectModel;
}

+ (CoreDataManager *)sharedManager
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init
{
    if ([super init]) {
        if (_mainThreadContext == nil) {
            NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
            if (coordinator != nil) {
                _mainThreadContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
                [_mainThreadContext setPersistentStoreCoordinator:coordinator];
            }
        }
        if (_bgThreadContext == nil) {
            _bgThreadContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            [_bgThreadContext setParentContext:_mainThreadContext];
        }
    }
    return self;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if ([NSThread isMainThread])
    {
        return _mainThreadContext;
    }
    return _bgThreadContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
    NSError *error = nil;
    
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (!_managedObjectModel) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    
    return _managedObjectModel;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)saveWithBlock:(void (^)(NSManagedObjectContext *context))block completion:(void (^)(void))completion
{
    [_bgThreadContext performBlock:^{
        
        NSError *error = nil;
        if (block) block(_bgThreadContext);
        
        if ([_bgThreadContext hasChanges]) {
            if (![_bgThreadContext save:&error]) {
                abort();
            }
            
            [_mainThreadContext performBlock:^{
                if ([_mainThreadContext hasChanges]) {
                    NSError *error = nil;
                    if (![_mainThreadContext save:&error]) {
                        abort();
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) completion();
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (completion) completion();
                    });
                }
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) completion();
            });
        }
    }];
}

- (id)fetchOneRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate
{
    NSArray *result = [self fetchRequestWithEntityName:entityName predicate:predicate sortDescriptors:nil fetchProperties:nil limit:1];
    id data = nil;
    if (result && [result count]) {
        data = [result lastObject];
    }
    return data;
}

- (id)fetchAllWithEntityName:(NSString *)entityName
{
    return [self fetchRequestWithEntityName:entityName predicate:nil sortDescriptors:nil fetchProperties:nil limit:0];
}

- (id)fetchRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate
{
    return [self fetchRequestWithEntityName:entityName predicate:predicate sortDescriptors:nil fetchProperties:nil limit:0];
}

- (id)fetchRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
{
    return [self fetchRequestWithEntityName:entityName predicate:predicate sortDescriptors:sortDescriptors fetchProperties:nil limit:0];
}

- (id)fetchRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors limit:(NSInteger)limit
{
    return [self fetchRequestWithEntityName:entityName predicate:predicate sortDescriptors:sortDescriptors fetchProperties:nil limit:limit];
}

- (id)fetchRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors fetchProperties:(NSArray*)fetchProperties
{
    return [self fetchRequestWithEntityName:entityName predicate:predicate sortDescriptors:sortDescriptors fetchProperties:fetchProperties limit:0];
}

- (id)fetchRequestWithEntityName:(NSString *)entityName predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors fetchProperties:(NSArray*)fetchProperties limit:(NSInteger)limit
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
    
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setPredicate:predicate];
    
    if (fetchProperties) {
        [fetchRequest setPropertiesToFetch:fetchProperties];
    }
    if (sortDescriptors) {
        [fetchRequest setSortDescriptors:sortDescriptors];
    }
    if (limit > 0) {
        [fetchRequest setFetchLimit:limit];
    }
    
    __block NSError *error = nil;
    __block NSArray *result = nil;
    
    [context performBlockAndWait:^{
        result = [context executeFetchRequest:fetchRequest error:&error];
    }];
    
    if (!error && result && [result count]) {
        return result;
    }
    return nil;
}

- (void)deleteAll
{
    // Delete current PersistentStore
    NSError *error = nil;
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Model.sqlite"];
    NSPersistentStoreCoordinator *storeCoodinator = [[self managedObjectContext] persistentStoreCoordinator];
    NSPersistentStore *store = [storeCoodinator persistentStoreForURL:storeURL];
    [[self persistentStoreCoordinator] removePersistentStore:store error:&error];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
    
    // Add new PersistentStore
    NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
    [storeCoodinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error];
}

@end
