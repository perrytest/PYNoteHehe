//
//  AppDelegate.m
//  PYNote
//
//  Created by kingnet on 15/12/16.
//  Copyright © 2015年 perry. All rights reserved.
//

#import "AppDelegate.h"
#import "CoverViewController.h"
#import "PYAppManager.h"
#import "PYMergeSever.h"

AppDelegate *app = nil;

#define kLuanchWindowTag    10000

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if (self.window && [self.window rootViewController]) {
        TTDEBUGLOG(@"self.window rootViewController is not null:%@", [[self.window rootViewController] class]);
    }
    app = self;
    
    [self makeResourceDirectory];
    
    //
    [SVProgressHUD setBackgroundColor:[UIColor darkGrayColor]];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        PYAppManager *appManager = [PYAppManager shareAppManager];
//        TTDEBUGLOG(@"installed app : %@", appManager.installedArray);
        [[PYMergeSever sharedInstance] start];
    });
    
    
    
    return YES;
}

- (RootViewController *)rootVC {
    if (_rootVC == nil) {
        if ([[self.window rootViewController] isKindOfClass:[CoverViewController class]]) {
            return nil;
        }
        UINavigationController *rootNav = (UINavigationController *)[self.window rootViewController];
        self.rootVC = [rootNav.viewControllers objectAtIndex:0];
    }
    return _rootVC;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[PYCoreDataController sharedInstance] saveContext];
    [self showCoverPage];
    [[PYMergeSever sharedInstance] stop];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[PYMergeSever sharedInstance] start];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    TTDEBUGLOG(@"become active");
    [self showCoverPage];
    
    NSString *userID = UserDefaultsObjectForKey(kCurrentUserID);
    User *currentUser;
    if (self.activeUserOID) {
        currentUser = [self activeUser];
    } else if (userID && userID.length>0) {
        currentUser = [[PYCoreDataController sharedInstance] userWithUserID:userID];
    }
    if (currentUser && [currentUser isTokenValid]) {
        [self setActiveUser:currentUser];
    } else {
        self.activeUserOID = nil;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self activeUser] == nil) {
            [self showUnLockPageWithUser:currentUser];
        }
        [self unshowCoverPage:nil];
    });
    
}

- (void)showUnLockPageWithUser:(User *)loginUser {
    if (loginUser) {
        UserAuthType lockType = [loginUser authType];
        switch (lockType) {
            case UserAuthType_CheckID:
                [self.rootVC showLoginPage:NO];
                break;
            case UserAuthType_Login:
                [self.rootVC showLoginPage:NO];
                break;
            case UserAuthType_Easy:
                [self.rootVC showLoginPage:NO];
                break;
            case UserAuthType_Gesture:
                [self.rootVC showLockPage:loginUser];
                break;
            default:
                break;
        }
        
    } else{
        [self.rootVC showLoginPage:NO];
    }
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[PYCoreDataController sharedInstance] saveContext];
}

#pragma mark - Public

- (User *)activeUser {
    if (self.activeUserOID) {
        User *activeUser = [[PYCoreDataController sharedInstance].managedObjectContext existingObjectWithID:self.activeUserOID error:NULL];
        return activeUser;
    }
    return nil;
}

- (void)setActiveUser:(User *)activeUser {
    UserDefaultsSetValueForKey(activeUser.userId, kCurrentUserID);
    UserDefaultSynchronize;
    [activeUser refreshAuthToken];
    [[PYCoreDataController sharedInstance] saveContext];
    self.activeUserOID = activeUser.objectID;
    [PYTools makeResourceDirectoryForUser:activeUser.userId];
}

- (void)logout {
    UserDefaultsRemoveObjectForKey(kCurrentUserID);
    UserDefaultSynchronize;
    [[self activeUser] deleteAuthToken];
    self.activeUserOID = nil;
}

#pragma mark - Private

- (void)makeResourceDirectory {
    NSString *resourcePath = [PYTools getResourceRootDirectoryPath];
    BOOL isDir = YES;
    if (!([[NSFileManager defaultManager] fileExistsAtPath:resourcePath isDirectory:&isDir] && isDir)) {
        [[NSFileManager defaultManager] createDirectoryAtPath:resourcePath withIntermediateDirectories:YES attributes:nil error:NULL];
    }
}

- (void)showCoverPage {
    BOOL needToShow = YES;
    if ([self.window viewWithTag:kLuanchWindowTag]) {
        needToShow = NO;
    }
    if (needToShow) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MyLuanch" bundle:nil];
        UIViewController *coverPage = [storyboard instantiateInitialViewController];
        UIView *luanchView = coverPage.view;
        luanchView.tag = kLuanchWindowTag;
        [self.window addSubview:luanchView];
    }
}

- (void)unshowCoverPage:(void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0) {
    if ([self.window viewWithTag:kLuanchWindowTag]) {
        UIView *luanchView = [self.window viewWithTag:kLuanchWindowTag];
        [luanchView removeFromSuperview];
    }
    if (completion) completion();
}



@end
