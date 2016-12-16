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
#import "PYCoreDataController+Other.h"


@interface AccountInfoViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *appCollectionView;
@property (nonatomic, strong) NSArray *appList;

@end

@implementation AccountInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
        [_appCollectionView registerClass:[AccountAppCell class] forCellWithReuseIdentifier:@"AppCollectionCell"];
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
    }
    
    [needDeleteList enumerateObjectsUsingBlock:^(RelateApp * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[PYCoreDataController sharedInstance] deleteRelateAppData:obj];
    }];
}

#pragma mark - Action

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
            cell.detailTextLabel.text = nil;
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = ([self.account accountType] == AccountType_BankCard)?NSLocalizedString(@"账号", @""):NSLocalizedString(@"卡号", @"");
                    RAC(cell.detailTextLabel, text) = [RACObserve(self.account, account) takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"姓名", @"");
                    RAC(cell.detailTextLabel, text) = [RACObserve(self.account, name) takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 2:
                    cell.textLabel.text = NSLocalizedString(@"昵称", @"");
                    RAC(cell.detailTextLabel, text) = [RACObserve(self.account, nick) takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 3:
                    cell.textLabel.text = NSLocalizedString(@"关键字", @"");
                    RAC(cell.detailTextLabel, text) = [RACObserve(self.account, keyword) takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 4:
                    cell.textLabel.text = NSLocalizedString(@"手机号", @"");
                    RAC(cell.detailTextLabel, text) = [RACObserve(self.account, phone) takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 5:
                    cell.textLabel.text = NSLocalizedString(@"email", @"");
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
        case 1: {
            if (indexPath.row == 1) {
                GestureLockVC *gestureLockVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GestureLockPage"];
                gestureLockVC.type = GestureLockTypeSetPwd;
                gestureLockVC.successBlock = ^(NSString *pwd) {
                    self.account.pwd_g = pwd;
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                };
                [self.navigationController pushViewController:gestureLockVC animated:YES];
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.appList.count+1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AccountAppCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AppCollectionCell" forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor yellowColor];
//    PYAppProxy *appProxy = [self.account.appList objec]
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
