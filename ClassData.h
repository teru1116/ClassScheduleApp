//
//  ClassData.h
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/04/09.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassData : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (UIImage *)cellBGImage;

@end

NS_ASSUME_NONNULL_END

#import "ClassData+CoreDataProperties.h"
