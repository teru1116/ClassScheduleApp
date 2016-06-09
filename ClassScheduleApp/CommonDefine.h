//
//  CommonDefine.h
//  ClassScheduleApp
//
//  Created by teruyakusumoto on 2016/04/09.
//  Copyright © 2016年 teruyakusumoto. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h

#define COLOR_GRAY      [CommonUtil colorFromHexCode:@"f4f5f6"]
#define COLOR_BLACK     [CommonUtil colorFromHexCode:@"333"]

#define SCREEN_WIDTH                ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT               ([UIScreen mainScreen].bounds.size.height)
#define GRID_VIEW_FRAME             CGRectMake(40, 30, SCREEN_WIDTH-40, SCREEN_HEIGHT-114)

#define NOTICE_REDRAW_GRID          @"noticeRedrawGrid"
#define NOTICE_REDRAW_LIST          @"noticeRedrawList"

#endif /* CommonDefine_h */
