//
//  RootViewController.m
//  PYMemorandum
//
//  Created by perry on 14-8-13.
//  Copyright (c) 2014年 Perry. All rights reserved.
//

#import "RootViewController.h"
#import "LoginVC.h"
#import "GestureLockVC.h"
#import "UserInfoViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = NSLocalizedString(@"首页", @"");
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"user_top_bar"] style:UIBarButtonItemStylePlain target:self action:@selector(goUserCenter:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public

- (void)showLoginPage:(BOOL)animated {
    // enter login
    if (!self.presentedViewController) {
        LoginVC *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginPage"];
        UINavigationController *loginNavVC = [[UINavigationController alloc] initWithRootViewController:loginVC];
        
        [self.navigationController presentViewController:loginNavVC animated:animated completion:nil];
    }
}

- (void)showLockPage:(User *)loginUser {
    //GestureLockPage
    if (!self.presentedViewController) {
        GestureLockVC *gestureLockVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GestureLockPage"];
        gestureLockVC.type = GestureLockTypeVerifyPwd;
        gestureLockVC.unlockUser = loginUser;
        gestureLockVC.successBlock = ^(NSString *pwd) {
            loginUser.lastAt = [NSDate date];
            [loginUser refreshAuthToken];
            [app setActiveUser:loginUser];
        };
        gestureLockVC.forgetPwdBlock = ^ {
            
        };
        UINavigationController *gestureLockNavVC = [[UINavigationController alloc] initWithRootViewController:gestureLockVC];
        [self.navigationController presentViewController:gestureLockNavVC animated:NO completion:nil];
    }
}

#pragma mark - Action

- (void)logoutAction:(UIBarButtonItem *)sender {
    [app logout];
    [self showLoginPage:YES];
}

- (void)goUserCenter:(UIBarButtonItem *)sender {
    //RootToUserInfo
    [self performSegueWithIdentifier:@"RootToUserInfo" sender:nil];
//    UserInfoViewController *userInfoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"UserInfoPage"];
//    [self.navigationController pushViewController:userInfoVC animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonCellIdentify"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommonCellIdentify"];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = NSLocalizedString(@"账号", @"");
            break;
        case 1:
            cell.textLabel.text = NSLocalizedString(@"app列表", @"");
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            // enter account list
            [self performSegueWithIdentifier:@"RootToAccount" sender:nil];
            break;
        case 1:
            // enter app list
            [self performSegueWithIdentifier:@"RootToAppList" sender:nil];
            break;
        default:
            break;
    }
}

@end
