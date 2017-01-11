//
//  AccountInfoViewController.m
//  PYNote
//
//  Created by kingnet on 16/12/6.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "AccountInfoViewController.h"
#import "ReactiveCocoa.h"
#import "Account.h"
#import "GestureLockVC.h"
#import "PYCoreDataController+Account.h"
#import "AccountAppCell.h"
#import "PYAppManager.h"
#import "RelateApp.h"
#import "PYAppProxy+Convert.h"
#import "PYCoreDataController+Other.h"
#import "TitleSettingViewController.h"
#import "AppListViewController.h"


@interface AccountInfoViewController () <UICollectionViewDataSource, UICollectionViewDelegate, AppListSelectDelegate>

@property (nonatomic, strong) UICollectionView *appCollectionView;
@property (nonatomic, strong) NSArray *appList;

@end

@implementation AccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"拷贝", @"") style:UIBarButtonItemStylePlain target:self action:@selector(copyBarAction:)];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    
    self.title = self.account.accountTitle;
    [self loadRelatedAppList];    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.account && [self.account hasChanges]) {
        [[PYCoreDataController sharedInstance] saveContext];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - getter/setter

- (UICollectionView *)appCollectionView {
    if (_appCollectionView == nil) {
        UICollectionViewFlowLayout *_flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.sectionInset = UIEdgeInsetsMake(0, 10.0, 0, 10.0);
        _flowLayout.minimumInteritemSpacing = 10.0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.itemSize = CGSizeMake(60.0, 80.0);
        _appCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 80.0+10.0*2) collectionViewLayout:_flowLayout];
        _appCollectionView.bounces = YES;
        _appCollectionView.delegate= self;
        _appCollectionView.dataSource = self;
        _appCollectionView.showsHorizontalScrollIndicator = NO;
        _appCollectionView.backgroundColor = [UIColor clearColor];
        // Register cell class
        UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([AccountAppCell class]) bundle:nil];
        [_appCollectionView registerNib:cellNib forCellWithReuseIdentifier:@"AppCollectionCell"];
    }
    return _appCollectionView;
}

#pragma mark - Private

- (void)loadRelatedAppList {
    NSMutableArray <RelateApp *> *needDeleteList = [[NSMutableArray alloc] init];
    NSMutableArray <PYAppProxy *> *appProxyArray = [[NSMutableArray alloc] init];
    [self.account.appList enumerateObjectsUsingBlock:^(RelateApp * _Nonnull obj, BOOL * _Nonnull stop) {
        PYAppProxy *appProxy = [[PYAppManager shareAppManager] appProxyWithBundleId:obj.bundleId];
        if (appProxy) {
            [appProxyArray addObject:appProxy];
        } else {
            [needDeleteList addObject:obj];
        }
    }];
    self.appList = [NSArray arrayWithArray:appProxyArray];
    if (self.appList.count>0) {
        self.tableView.tableHeaderView = ({
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 80.0+10.0*2)];
            
            [headerView addSubview:self.appCollectionView];
            
            headerView;
        });
    } else {
        self.tableView.tableHeaderView = nil;
    }
    
    [needDeleteList enumerateObjectsUsingBlock:^(RelateApp * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[PYCoreDataController sharedInstance] deleteRelateAppData:obj];
    }];
}

- (NSString *)titleForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = nil;
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0:
                    title = ([self.account accountType] == AccountType_BankCard)?NSLocalizedString(@"卡号", @""):NSLocalizedString(@"账号", @"");;
                    break;
                case 1:
                    title = NSLocalizedString(@"姓名", @"");
                    break;
                case 2:
                    title = NSLocalizedString(@"昵称", @"");
                    break;
                case 3:
                    title = NSLocalizedString(@"关键字", @"");
                    break;
                case 4:
                    title = NSLocalizedString(@"手机号", @"");
                    break;
                case 5:
                    title = NSLocalizedString(@"email", @"");
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            if (indexPath.row == 0) {
                title = NSLocalizedString(@"账号密码", @"");
            }
        }
            break;
        default:
            break;
    }
    return title;
}

- (NSString *)propertyForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *property = nil;
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0:
                    property = @"account";
                    break;
                case 1:
                    property = @"name";
                    break;
                case 2:
                    property = @"nick";
                    break;
                case 3:
                    property = @"keyword";
                    break;
                case 4:
                    property = @"phone";
                    break;
                case 5:
                    property = @"email";
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            if (indexPath.row == 0) {
                property = @"pwd";
            }
        }
            break;
        default:
            break;
    }
    return property;
}

#pragma mark - Action

- (void)copyBarAction:(id)sender {
    NSString *copyString = [NSString stringWithFormat:@"%@|%@", self.account.account, self.account.pwd];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = copyString;
    [SVProgressHUD showInfoWithStatus:NSLocalizedString(@"Copy_OK", @"")];
}

- (void)didSelectedForSettingAtIndexPath:(NSIndexPath *)indexPath {
    TitleSettingViewController *settingVC = [self.storyboard instantiateViewControllerWithIdentifier:@"TitleSettingPage"];
    settingVC.title = [self titleForRowAtIndexPath:indexPath];
    if (indexPath.section == 1 && indexPath.row == 0) {
        settingVC.secureTextEntry = YES;
        settingVC.hasNotice = YES;
        settingVC.noticeValue = self.account.pwd_notice;
    }
    NSString *property = [self propertyForRowAtIndexPath:indexPath];
    settingVC.textValue = [self.account valueForKey:property];
    
    settingVC.changedBlock = ^(NSString *value1, NSString *notice) {
        [self.account setValue:value1 forKey:property];
        self.account.pwd_notice = notice;
    };
    
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)deleteAccountDataAction {
    [UIAlertView showWithTitle:PYProjectDisplayName
                       message:NSLocalizedString(@"确认永久此账号删除数据", @"")
             cancelButtonTitle:NSLocalizedString(@"Cancel", @"")
             otherButtonTitles:@[NSLocalizedString(@"Delete", @"")]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                          if (buttonIndex == 1) {
                              self.account = nil;
                              [app.activeUser removeAccountsObject:self.account];
                              [[PYCoreDataController sharedInstance] deleteAccountData:self.account];
                              
                              [self.navigationController popViewControllerAnimated:YES];
                          }
                      }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 6;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonRightDetailCell" forIndexPath:indexPath];
            cell.textLabel.font = Font_FS05;
            cell.detailTextLabel.font = Font_FS04;
            cell.detailTextLabel.textColor = HexColor(0x9b9fad);
            cell.textLabel.text = [self titleForRowAtIndexPath:indexPath];
            cell.detailTextLabel.text = nil;
            
            switch (indexPath.row) {
                case 0:
                    RAC(cell.detailTextLabel, text) = [RACObserve(self.account, account) takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 1:
                    RAC(cell.detailTextLabel, text) = [RACObserve(self.account, name) takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 2:
                    RAC(cell.detailTextLabel, text) = [RACObserve(self.account, nick) takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 3:
                    RAC(cell.detailTextLabel, text) = [RACObserve(self.account, keyword) takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 4:
                    RAC(cell.detailTextLabel, text) = [RACObserve(self.account, phone) takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 5:
                    RAC(cell.detailTextLabel, text) = [RACObserve(self.account, email) takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                default:
                    break;
            }
            return cell;
        }
            break;
        case 1: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonCellIdentify" forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.textColor = [UIColor blackColor];
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"更新密码", @"");
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"更新手势密码", @"");
                    break;
                default:
                    break;
            }
            return cell;
        }
            break;
        case 2: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonCellIdentify" forIndexPath:indexPath];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = Color_FC08;
            cell.textLabel.text = NSLocalizedString(@"删除此账号相关数据", @"");
            return cell;
        }
            break;
        default:
            break;
    }
    //预防异常情况
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonCellIdentify" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            [self didSelectedForSettingAtIndexPath:indexPath];
            break;
        case 1: {
            if (indexPath.row == 1) {
                GestureLockVC *gestureLockVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GestureLockPage"];
                gestureLockVC.type = GestureLockTypeSetPwd;
                gestureLockVC.successBlock = ^(NSString *pwd) {
                    self.account.pwd_g = pwd;
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                [self.navigationController pushViewController:gestureLockVC animated:YES];
            } else {
                [self didSelectedForSettingAtIndexPath:indexPath];
            }
        }
            break;
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    [self deleteAccountDataAction];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.appList.count+1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AccountAppCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AppCollectionCell" forIndexPath:indexPath];
    
//    cell.contentView.backgroundColor = [UIColor yellowColor];
    if (indexPath.row < self.appList.count) {
        PYAppProxy *appProxy = [self.appList objectAtIndex:indexPath.row];
        [cell loadUIWithApp:appProxy];
    } else {
        [cell loadUIWithApp:nil];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.appList.count) {
        PYAppProxy *appProxy = [self.appList objectAtIndex:indexPath.row];
        [[PYAppManager shareAppManager] openAppWithBundleId:appProxy.applicationIdentifier];
    } else {
        AppListViewController *appListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AppListPage"];
        appListVC.delegate = self;
        appListVC.originList = self.appList;
        [self.navigationController pushViewController:appListVC animated:YES];
    }
}

#pragma mark - AppListSelectDelegate

- (void)didSelectedAppList:(NSArray <PYAppProxy *> *)appList {
    NSManagedObjectContext *context = [PYCoreDataController sharedInstance].managedObjectContext;
    NSSet *appSet = self.account.appList;
    [self.account removeAppList:appSet];
    NSMutableSet *newAppSet = [[NSMutableSet alloc] initWithCapacity:appList.count];
    for (PYAppProxy *appProxy in appList) {
        RelateApp *insertApp = [NSEntityDescription insertNewObjectForEntityForName:@"RelateApp" inManagedObjectContext:context];
        [appProxy convertInfoToRelateApp:&insertApp];
        [newAppSet addObject:insertApp];
    }
    [self.account addAppList:newAppSet];
    [self loadRelatedAppList];
    [self.appCollectionView reloadData];
}

@end
