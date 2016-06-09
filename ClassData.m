//
//  ClassData.m
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/04/09.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import "ClassData.h"

@implementation ClassData

// Insert code here to add functionality to your managed object subclass
- (UIImage *)cellBGImage
{
    NSInteger index = [self.color integerValue];
    NSString *imageName = @[@"brown", @"red", @"orange", @"yellow", @"lightgreen", @"green", @"lightblue", @"blue", @"purple", @"pink"][index];
    return [UIImage imageNamed:[imageName stringByAppendingString:@".jpg"]];
}

@end
