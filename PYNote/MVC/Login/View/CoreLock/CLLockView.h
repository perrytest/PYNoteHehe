//
//  CLLockView.h
//  CoreLock
//
//  Created by 成林 on 15/4/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface CLLockView : UIView



/*
 *  设置密码
 */

/** 开始输入，第一次 */
@property (nonatomic,copy) void (^setPWDBeginBlock)();

/** 开始输入，确认密码*/
@property (nonatomic,copy) void (^setPWDConfirmlock)(NSString *pwd);


/** 设置密码出错：长度不够 */
@property (nonatomic,copy) void (^setPWDErrorBlock)(NSUInteger currentCount);






@end
