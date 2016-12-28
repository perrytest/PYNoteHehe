//
//  TitleSettingViewController.h
//  PYNote
//
//  Created by kingnet on 16/12/19.
//  Copyright © 2016年 perry. All rights reserved.
//

#import <UIKit/UIKit.h>

//TitleSettingPage
@interface TitleSettingViewController : UITableViewController

@property (nonatomic, assign) BOOL secureTextEntry;

@property (nonatomic, assign) BOOL hasNotice;

@property (nonatomic, copy) NSString *textValue;

@property (nonatomic, copy) NSString *noticeValue;

@property (nonatomic,copy) void (^changedBlock)(NSString *textValue, NSString *noticeValue);

@end
