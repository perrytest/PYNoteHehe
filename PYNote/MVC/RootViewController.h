//
//  RootViewController.h
//  PYMemorandum
//
//  Created by perry on 14-8-13.
//  Copyright (c) 2014年 Perry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface RootViewController : UITableViewController

- (void)showLoginPage:(BOOL)animated;

- (void)showLockPage:(User *)loginUser;


@end
