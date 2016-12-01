//
//  AccountAddViewController.m
//  PYNote
//
//  Created by kingnet on 16/5/13.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "AccountAddViewController.h"
#import "PYTextfieldCell.h"
#import "PYDoubleTextfieldCell.h"
#import "AppListViewController.h"

#import "PYAccountModel.h"
#import "ReactiveCocoa.h"
#import "Account.h"
#import "RelateApp.h"
#import "PYAppProxy+Convert.h"

#import "CardIO.h"

@interface AccountAddViewController () <CardIOPaymentViewControllerDelegate, AppListSelectDelegate>

@property (nonatomic, strong) UIBarButtonItem *doneButton;

@property (nonatomic, retain) PYAccountModel *account;

@property (nonatomic, retain) NSArray *relatedAppArray;

@end

static NSString *cellTFIdentifierNormal = @"kNormalCellIdentifier";
static NSString *cellTFIdentifierSingle = @"kCellTextFieldIdentifier";
static NSString *cellTFIdentifierDouble = @"DoubleCellTextFieldIdentifier";

@implementation AccountAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"添加账号", @"");
    
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    UINib *cellNib1 = [UINib nibWithNibName:NSStringFromClass([PYTextfieldCell class]) bundle:nil];
    UINib *cellNib2 = [UINib nibWithNibName:NSStringFromClass([PYDoubleTextfieldCell class]) bundle:nil];
    [self.tableView registerNib:cellNib1 forCellReuseIdentifier:cellTFIdentifierSingle];
    [self.tableView registerNib:cellNib2 forCellReuseIdentifier:cellTFIdentifierDouble];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellTFIdentifierNormal];
    
    self.account = [[PYAccountModel alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)addAccoutToCoreData {
    NSManagedObjectContext *context = [PYCoreDataController sharedInstance].managedObjectContext;
    Account *insertAccout = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:context];
    [self.account convertInfoToAccout:&insertAccout];
    for (PYAppProxy *appProxy in self.account.appList) {
        RelateApp *insertApp = [NSEntityDescription insertNewObjectForEntityForName:@"RelateApp" inManagedObjectContext:context];
        [appProxy convertInfoToRelateApp:&insertApp];
        [insertAccout addAppListObject:insertApp];
    }
    User *currentUser = [app activeUser];
    [currentUser addAccountsObject:insertAccout];
    [[PYCoreDataController sharedInstance] saveContext];
}


#pragma mark - Accessor

- (UIBarButtonItem *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addAccoutDoneAction:)];
    }
    return _doneButton;
}

#pragma mark - Action

- (void)addAccoutDoneAction:(UIButton *)sender {
    // add account
    if (self.account.account && self.account.account.length>0) {
        self.account.accountId = [PYTools getUniqueId];
        TTDEBUGLOG(@"save account id:%@", self.account.accountId);
        [self addAccoutToCoreData];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 7;
            break;
        case 1:
            return 2;
            break;
        default:
            break;
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            if (indexPath.row == 6) {
                PYDoubleTextfieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTFIdentifierDouble forIndexPath:indexPath];
                
                cell.leftInputTF.secureTextEntry = YES;
                cell.leftInputTF.placeholder = NSLocalizedString(@"请输入密码", @"");
                cell.rightInputTF.secureTextEntry = NO;
                cell.rightInputTF.placeholder = NSLocalizedString(@"密码备注", @"");
                RAC(self.account, pwd) = [cell.leftInputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
                RAC(self.account, pwd_notice) = [cell.rightInputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
                
                return cell;
            }
            
            PYTextfieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTFIdentifierSingle forIndexPath:indexPath];
            
            cell.inputTF.secureTextEntry = NO;
            cell.inputTF.placeholder = nil;
            switch (indexPath.row) {
                case 0:
                    cell.inputTF.placeholder = NSLocalizedString(@"请输入账号", @"");
                    cell.inputTF.text = self.account.account;
                    RAC(self.account, account) = [[cell.inputTF rac_textSignal] takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 1:
                    cell.inputTF.placeholder = NSLocalizedString(@"请输入姓名", @"");
                    cell.inputTF.text = self.account.name;
                    RAC(self.account, name) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 2:
                    cell.inputTF.placeholder = NSLocalizedString(@"请输入昵称", @"");
                    cell.inputTF.text = self.account.nick;
                    RAC(self.account, nick) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 3:
                    cell.inputTF.placeholder = NSLocalizedString(@"请输入账号关键字", @"");
                    cell.inputTF.text = self.account.keyword;
                    RAC(self.account, keyword) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 4:
                    cell.inputTF.placeholder = NSLocalizedString(@"请输入手机号", @"");
                    cell.inputTF.text = self.account.phone;
                    RAC(self.account, phone) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 5:
                    cell.inputTF.placeholder = NSLocalizedString(@"请输入email", @"");
                    cell.inputTF.text = self.account.email;
                    RAC(self.account, email) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                default:
                    break;
            }
            return cell;
        }
            break;
        case 1: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTFIdentifierNormal forIndexPath:indexPath];
            
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"相关app", @"");
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"扫描银行卡", @"");
                    break;
                default:
                    break;
            }
            return cell;
        }
            break;
            
        default:
            break;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTFIdentifierNormal forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    // enter app list
                    AppListViewController *appListVC = [self.storyboard instantiateViewControllerWithIdentifier:@"AppListPage"];
                    appListVC.delegate = self;
                    [self.navigationController pushViewController:appListVC animated:YES];
                }
                    
                    break;
                case 1: {
                    //
                    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
                    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
                    [self presentViewController:scanViewController animated:YES completion:nil];
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

#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    TTDEBUGLOG(@"Scan succeeded with info: %@", info);
    // Do whatever needs to be done to deliver the purchased items.
    [self dismissViewControllerAnimated:YES completion:nil];
    self.account.accountType = AccountType_BankCard;
    self.account.account = info.cardNumber;
    [self.tableView reloadData];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
//
//    self.account.account = [NSString stringWithFormat:@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", info.redactedCardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    TTDEBUGLOG(@"User cancelled scan");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - AppListSelectDelegate

- (void)didSelectedAppList:(NSArray <PYAppProxy *> *)appList {
    NSSet *list = [NSSet setWithArray:appList];
    self.account.appList = list;
}

@end
