//
//  GestureLockVC.h
//  PYMemorandum
//
//  Created by perry on 14-8-15.
//  Copyright (c) 2014年 Perry. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{
    //设置密码
    GestureLockTypeSetPwd=0,
    
    //输入并验证密码
    GestureLockTypeVeryfiPwd,
    
} GestureLockType;


@interface GestureLockVC : PYViewController

@property (nonatomic,assign) GestureLockType type;

@property (nonatomic, copy) NSString *checkPwd;

@property (nonatomic, assign) NSInteger limitTryTimes;

@end
