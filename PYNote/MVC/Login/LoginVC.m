//
//  LoginVC.m
//  PYMemorandum
//
//  Created by perry on 14-8-15.
//  Copyright (c) 2014年 Perry. All rights reserved.
//

#import "LoginVC.h"
#import "PYTextfieldCell.h"
#import "ReactiveCocoa.h"

static NSString *cellTFIdentifierNormal = @"NormalCellTextFieldIdentifier";

@interface LoginVC () <UITabBarDelegate>

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, copy) NSString *userString;
@property (nonatomic, copy) NSString *password;


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
    self.navigationItem.hidesBackButton = YES;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"注册", @"注册") style:UIBarButtonItemStylePlain target:self action:@selector(enterRegisterAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    
    UINib *cellNib1 = [UINib nibWithNibName:NSStringFromClass([PYTextfieldCell class]) bundle:nil];
    [self.tableView registerNib:cellNib1 forCellReuseIdentifier:cellTFIdentifierNormal];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width-60)/2, 20, 60, 60)];
    self.iconImageView.image = [UIImage imageNamed:@"Icon-60"];
    
    
    self.tableView.tableHeaderView = ({
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
        
        [headerView addSubview:self.iconImageView];
        
        headerView;
    });
    
    
    [self loadLoginButton];
    
    [self loadCurrentUser];
}

#pragma mark - Style

- (void)loadLoginButton {
    UIButton *loginBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 30, self.view.width-40*2, 40)];
    [loginBtn.layer setCornerRadius:20];
    [loginBtn setTitle:NSLocalizedString(@"登  录", nil) forState:UIControlStateNormal];
    [loginBtn setTitleColor:Color_FC10 forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:Font_FS06];
    [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    RACSignal *combinSignal = [RACSignal combineLatest:@[RACObserve(self, userString), RACObserve(self, password)] reduce:^id(NSString *user, NSString *pwd){
        return @(user.length && pwd.length);
    }];
    RAC(loginBtn, enabled) = combinSignal;
    [combinSignal subscribeNext:^(id x) {
        if ([x boolValue]) {
            [loginBtn setBackgroundColor:Color_FC06];
        } else {
            [loginBtn setBackgroundColor:[UIColor lightGrayColor]];
        }
        
    }];
    
    self.tableView.tableFooterView = ({
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
        [footerView addSubview:loginBtn];
        footerView;
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSArray *users = [[PYCoreDataController sharedInstance] allUserList];
    TTDEBUGLOG(@"all user count:%lu", (unsigned long)users.count);
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

#pragma mark - Action

- (void)backAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)enterRegisterAction:(UIButton *)sender {
    [self performSegueWithIdentifier:@"LoginToRegister" sender:nil];
}

- (void)loginAction:(id)sender {
    if (self.userString && self.userString.length>0 && self.password && self.password.length>0) {
        User *loginUser = [[PYCoreDataController sharedInstance] searchUser:self.userString];
        if (loginUser && loginUser.userId) {
            if ([loginUser checkLoginPassword:self.password]) {
                loginUser.lastAt = [NSDate date];
                [loginUser refreshAuthToken];
                [app setActiveUser:loginUser];
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"用户名和密码不正确", nil)];
            }
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"用户名不存在", nil)];
        }
    }
}

#pragma mark - Private

- (void)loadCurrentUser {
    NSString *userID = UserDefaultsObjectForKey(kCurrentUserID);
    if (userID && userID.length>0) {
        User *currentUser = [[PYCoreDataController sharedInstance] userWithUserID:userID];
        self.userString = currentUser.name;
    }
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PYTextfieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTFIdentifierNormal forIndexPath:indexPath];
    
    cell.inputTF.secureTextEntry = NO;
    cell.inputTF.placeholder = nil;
    switch (indexPath.row) {
        case 0: {
            cell.inputTF.placeholder = NSLocalizedString(@"请输入姓名/身份证/手机号/email", @"");
            cell.inputTF.text = self.userString;
            RAC(self, userString) = [[cell.inputTF rac_textSignal] takeUntil:[cell rac_prepareForReuseSignal]];
//            RAC(cell.inputTF, text) = [RACObserve(self, userString) takeUntil:[cell rac_prepareForReuseSignal]];
        }
            break;
        case 1:
            cell.inputTF.placeholder = NSLocalizedString(@"请输入密码", @"");
            cell.inputTF.secureTextEntry = YES;
            cell.inputTF.text = self.password;
            RAC(self, password) = [[cell.inputTF rac_textSignal] takeUntil:[cell rac_prepareForReuseSignal]];
//            RAC(cell.inputTF, text) = [RACObserve(self, password) takeUntil:[cell rac_prepareForReuseSignal]];
            break;
        default:
            break;
    }
    return cell;
}

@end
