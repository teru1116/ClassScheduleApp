//
//  GridView.m
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/04/09.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import "GridView.h"

@implementation GridView

- (void)drawRect:(CGRect)rect
{
    NSInteger dayCount = [CommonUtil dayCount];
    NSInteger periodCount = [CommonUtil periodCount];
    
    // 背景色
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(context, CGRectMake(0, 0, self.frame.size.width, self.frame.size.height));
    
    // 縦線
    CGFloat horizontalInterval = self.frame.size.width/dayCount;
    for (int i = 0; i <= dayCount; i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(context, i*horizontalInterval, 0);
        CGContextAddLineToPoint(context, i*horizontalInterval, self.frame.size.height);
        CGContextSetLineWidth(context, 0.4);
        CGContextStrokePath(context);
    }
    
    // 横線
    CGFloat verticalInterval = self.frame.size.height/periodCount;
    for (int i = 0; i <= periodCount; i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextMoveToPoint(context, 0, i*verticalInterval);
        CGContextAddLineToPoint(context, self.frame.size.width, i*verticalInterval);
        CGContextSetLineWidth(context, 0.4);
        CGContextStrokePath(context);
    }
}


@end
