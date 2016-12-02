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
    GestureLockTypeVerifyPwd,
    
} GestureLockType;


@interface GestureLockVC : PYViewController

@property (nonatomic,assign) GestureLockType type;

@property (nonatomic, strong) User *unlockUser;


/** 操作成功：密码设置成功、密码验证成功 */
@property (nonatomic,copy) void (^successBlock)(NSString *pwd);

@property (nonatomic,copy) void (^forgetPwdBlock)();

@end
