//
//  LoginVC.m
//  PYMemorandum
//
//  Created by perry on 14-8-15.
//  Copyright (c) 2014年 Perry. All rights reserved.
//

#import "LoginVC.h"

@interface LoginVC ()

//@property (nonatomic, strong) UITableView *m

@end

@implementation LoginVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"登录", @"");
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backAction:)];
//    self.navigationItem.leftBarButtonItem = backBarButton;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"注册", @"注册") style:UIBarButtonItemStylePlain target:self action:@selector(enterRegisterAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)enterRegisterAction:(UIButton *)sender {
    [self performSegueWithIdentifier:@"LoginToRegister" sender:nil];
}

- (IBAction)loginAction:(id)sender {
    NSString *userID = UserDefaultsObjectForKey(kCurrentUserID);
    if (userID && userID.length>0) {
        User *currentUser = [[PYCoreDataController sharedInstance] userWithUserID:userID];
        [app setActiveUser:currentUser];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
