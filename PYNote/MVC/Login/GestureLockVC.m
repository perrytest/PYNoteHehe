//
//  GestureLockVC.m
//  PYMemorandum
//
//  Created by perry on 14-8-15.
//  Copyright (c) 2014年 Perry. All rights reserved.
//

#import "GestureLockVC.h"
#import "CLLockView.h"
#import "CoreLockConst.h"

#import "LoginVC.h"

@interface GestureLockVC ()


@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property (strong, nonatomic) IBOutlet CLLockView *lockView;
@property (strong, nonatomic) IBOutlet UIButton *avatarButton;
@property (strong, nonatomic) IBOutlet UIButton *forgetBtn;

@property (nonatomic, copy) NSString *firstInputPWD;
@property (nonatomic, assign) NSInteger tryTimes;

@end

@implementation GestureLockVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置背景色
    self.view.backgroundColor = CoreLockViewBgColor;
    self.tryTimes = 0;
    self.limitTryTimes = 5;
    
    if (self.type == GestureLockTypeSetPwd) {
        self.backBtn.hidden = NO;
        self.forgetBtn.hidden = YES;
    } else {
        self.backBtn.hidden = YES;
        self.forgetBtn.hidden = NO;
        [self.forgetBtn setTitle:NSLocalizedString(@"忘记密码", @"") forState:UIControlStateNormal];
    }
    
    [self prepareLockView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
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

- (void)prepareLockView {
    __weak typeof(self) weakSelf = self;
    self.lockView.setPWDConfirmlock = ^(NSString *pwd) {
        weakSelf.tryTimes++;
        if (weakSelf.type == GestureLockTypeSetPwd) {
            if (weakSelf.firstInputPWD && weakSelf.firstInputPWD.length>0) {
                if ([pwd isEqualToString:weakSelf.firstInputPWD]) {
                    [weakSelf setPwdSuccess:pwd];
                } else {
                    weakSelf.firstInputPWD = nil;
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"密码不一致，请重新输入", nil)];
                }
            } else {
                weakSelf.firstInputPWD = pwd;
            }
        } else {
            if ([pwd isEqualToString:weakSelf.checkPwd]) {
                [weakSelf checkPwdSuccess:nil];
            } else {
                if (weakSelf.tryTimes>weakSelf.limitTryTimes) {
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"密码错误，请重新登录", nil)];
                    [weakSelf enterLoginPage:nil];
                } else {
                    [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"密码错误，请重新输入", nil)];
                }
            }
        }
        
    };
    self.lockView.setPWDErrorBlock = ^(NSUInteger currentCount) {
        TTDEBUGLOG(@"pwd wrong length:%lu", (unsigned long)currentCount);
        [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"密码太短，请重新输入", nil)];
    };
    
    [self.view addSubview:self.lockView];
}

#pragma mark - Action

- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)enterLoginPage:(id)sender {
    if (self.type == GestureLockTypeVerifyPwd) {
        LoginVC *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginPage"];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

- (IBAction)forgetPWDAction:(id)sender {
    LoginVC *loginVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginPage"];
    [self.navigationController pushViewController:loginVC animated:YES];
    if (self.forgetPwdBlock) self.forgetPwdBlock();
}

#pragma mark - Private

- (void)setPwdSuccess:(NSString *)pwd {
    TTDEBUGLOG(@"set password success");
    if (self.successBlock) self.successBlock(pwd);
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)checkPwdSuccess:(NSString *)pwd {
    TTDEBUGLOG(@"check password success");
    if (self.successBlock) self.successBlock(pwd);
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
