//
//  AppDelegate.h
//  PYNote
//
//  Created by kingnet on 15/12/16.
//  Copyright © 2015年 perry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "RootViewController.h"
#import "User.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) RootViewController *rootVC;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic, strong) NSManagedObjectID *activeUserOID;


- (User *)activeUser;

- (void)setActiveUser:(User *)activeUser;

- (void)logout;

@end

extern AppDelegate *app;

