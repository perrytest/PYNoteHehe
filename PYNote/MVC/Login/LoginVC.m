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


@interface LoginVC ()

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
    [self.tableView registerNib:cellNib1 forCellReuseIdentifier:NormalSingleTFCellID];
    
    self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width-60)/2, 20, 60, 60)];
    self.iconImageView.image = [UIImage imageNamed:@"Icon-60"];
    UITapGestureRecognizer *swipeGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarGestureAction:)];
    swipeGesture.numberOfTapsRequired = 2;
    [self.iconImageView addGestureRecognizer:swipeGesture];
    self.iconImageView.userInteractionEnabled = YES;
    
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

- (void)avatarGestureAction:(id)sender {
    TTDEBUGLOG(@"show all user");
    NSArray <User *> *users = [[PYCoreDataController sharedInstance] allUserList];
    if (users.count>0) {
        DeclareWeakSelf
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"选择登录用户", @"") message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:nil];
        [actionSheet addAction:cancelAction];
        [users enumerateObjectsUsingBlock:^(User * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIAlertAction *userAction = [UIAlertAction actionWithTitle:obj.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                weakSelf.userString = obj.name;
                NSString *avatarFilePath = [obj avatarPath];
                if (avatarFilePath) {
                    UIImage *_image = [UIImage imageWithContentsOfFile:avatarFilePath];
                    weakSelf.iconImageView.image = _image;
                } else {
                    weakSelf.iconImageView.image = [UIImage imageNamed:@"Icon-60"];
                }
            }];
            [actionSheet addAction:userAction];
        }];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }
    
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
        NSString *avatarFilePath = [currentUser avatarPath];
        if (avatarFilePath) {
            UIImage *_image = [UIImage imageWithContentsOfFile:avatarFilePath];
            self.iconImageView.image = _image;
        }
    }
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PYTextfieldCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalSingleTFCellID forIndexPath:indexPath];
    
    cell.inputTF.secureTextEntry = NO;
    cell.inputTF.placeholder = nil;
    switch (indexPath.row) {
        case 0: {
            cell.inputTF.placeholder = NSLocalizedString(@"请输入姓名/身份证/手机号/email", @"");
            RACChannelTerminal *textFieldTerminal = [cell.inputTF rac_newTextChannel];
            RACChannelTerminal *modelTerminal = RACChannelTo(self, userString);
            [modelTerminal subscribe:textFieldTerminal];
            [[textFieldTerminal skip:1] subscribe:modelTerminal];
        }
            break;
        case 1: {
            cell.inputTF.placeholder = NSLocalizedString(@"请输入密码", @"");
            cell.inputTF.secureTextEntry = YES;
            RACChannelTerminal *textFieldTerminal = [cell.inputTF rac_newTextChannel];
            RACChannelTerminal *modelTerminal = RACChannelTo(self, password);
            [modelTerminal subscribe:textFieldTerminal];
            [[textFieldTerminal skip:1] subscribe:modelTerminal];
        }
            break;
        default:
            break;
    }
    return cell;
}

@end
