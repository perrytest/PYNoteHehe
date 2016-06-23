//
//  AppDelegate.h
//  PYNote
//
//  Created by kingnet on 15/12/16.
//  Copyright © 2015年 perry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PYUserModel.h"
#import "RootViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootViewController *rootVC;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, retain) PYUserModel *currentUser;

@property (nonatomic, copy) NSString *userToken;
@property (nonatomic, assign) BOOL userActive;
//
//
//
//- (void)showLoginView;
//
//- (void)showUnlockView;


@end

extern AppDelegate *app;

