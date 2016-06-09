//
//  TriangleButton.m
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/05/26.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import "TriangleButton.h"

@interface TriangleButton ()

@property (nonatomic, strong) UIColor *btnBackgroundColor;

@end

@implementation TriangleButton

- (id)initWithFrame:(CGRect)frame backgroundColor:(UIColor *)backgroundColor
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.btnBackgroundColor = backgroundColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self.btnBackgroundColor setFill];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGContextMoveToPoint(context, width/2, 0);
    CGContextAddLineToPoint(context, 0, height);
    CGContextFillPath(context);
}

@end
