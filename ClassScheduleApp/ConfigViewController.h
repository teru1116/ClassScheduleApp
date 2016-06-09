//
//  ConfigViewController.h
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/04/09.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ConfigViewTypeRoot,     // 設定画面ルート
    ConfigViewTypePeriod,   // 時限数
    ConfigViewTypeDays,     // 土日の有無
    ConfigViewTypeTime,     // 時間の設定
} ConfigViewType;

@interface ConfigViewController : UIViewController

- (instancetype)initWithConfigViewType:(ConfigViewType)configViewType;

@end
