//
//  AccountAddViewController.m
//  PYNote
//
//  Created by kingnet on 16/5/13.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "AccountAddViewController.h"
#import "PYTextfieldCell.h"
#import "PYAccountModel.h"
#import "ReactiveCocoa.h"

@interface AccountAddViewController ()

@property (nonatomic, strong) UIBarButtonItem *doneButton;

@property (nonatomic, retain) PYAccountModel *account;

@end

static NSString *cellTFIdentifier = @"kCellTextFieldIdentifier";

@implementation AccountAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"添加账号", @"");
    
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([PYTextfieldCell class]) bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:cellTFIdentifier];
    self.account = [[PYAccountModel alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    }
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PYTextfieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTFIdentifier forIndexPath:indexPath];
    
    cell.inputTF.secureTextEntry = NO;
    cell.inputTF.placeholder = nil;
    switch (indexPath.row) {
        case 0:
            cell.titleLabel.text = NSLocalizedString(@"账号", @"");
            cell.inputTF.placeholder = NSLocalizedString(@"请输入账号", @"");
            RAC(self.account, account) = [[cell.inputTF rac_textSignal] takeUntil:[cell rac_prepareForReuseSignal]];
            RAC(cell.inputTF, text) = [RACObserve(self.account, account) takeUntil:[cell rac_prepareForReuseSignal]];
            break;
        case 1:
            cell.titleLabel.text = NSLocalizedString(@"姓名", @"");
            RAC(self.account, name) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
            RAC(cell.inputTF, text) = [RACObserve(self.account, name) takeUntil:[cell rac_prepareForReuseSignal]];
            break;
        case 2:
            cell.titleLabel.text = NSLocalizedString(@"昵称", @"");
            RAC(self.account, nick) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
            RAC(cell.inputTF, text) = [RACObserve(self.account, nick) takeUntil:[cell rac_prepareForReuseSignal]];
            break;
        case 3:
            cell.titleLabel.text = NSLocalizedString(@"账号标注", @"");
            cell.inputTF.text = self.account.keyword;
            RAC(self.account, keyword) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
            RAC(cell.inputTF, text) = [RACObserve(self.account, keyword) takeUntil:[cell rac_prepareForReuseSignal]];
            break;
        case 4:
            cell.titleLabel.text = NSLocalizedString(@"电话号码", @"");
            RAC(self.account, phone) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
            RAC(cell.inputTF, text) = [RACObserve(self.account, phone) takeUntil:[cell rac_prepareForReuseSignal]];
            break;
        case 5:
            cell.titleLabel.text = NSLocalizedString(@"email", @"");
            RAC(self.account, email) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
            RAC(cell.inputTF, text) = [RACObserve(self.account, email) takeUntil:[cell rac_prepareForReuseSignal]];
            break;
        case 6:
            cell.titleLabel.text = NSLocalizedString(@"密码", @"");
            cell.inputTF.secureTextEntry = YES;
            cell.inputTF.placeholder = NSLocalizedString(@"请输入密码", @"");
            RAC(self.account, pwd) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
            RAC(cell.inputTF, text) = [RACObserve(self.account, pwd) takeUntil:[cell rac_prepareForReuseSignal]];
            break;
        case 7:
            cell.titleLabel.text = NSLocalizedString(@"密码备注", @"");
            RAC(self.account, pwd_notice) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
            RAC(cell.inputTF, text) = [RACObserve(self.account, pwd_notice) takeUntil:[cell rac_prepareForReuseSignal]];
            break;
        default:
            break;
    }
    return cell;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
