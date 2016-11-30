//
//  AppListViewController.h
//  PYNote
//
//  Created by kingnet on 16/9/19.
//  Copyright © 2016年 perry. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AppListSelectDelegate <NSObject>

@optional
- (void)didSelectedAppList:(NSArray <PYAppProxy *> *)appList;

@end

@interface AppListViewController : UITableViewController

@property (nonatomic, weak) id <AppListSelectDelegate> delegate;

@end
