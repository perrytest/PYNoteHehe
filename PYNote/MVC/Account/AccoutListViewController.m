//
//  AccoutListViewController.m
//  PYNote
//
//  Created by kingnet on 16/5/13.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "AccoutListViewController.h"
#import "Account.h"

@interface AccoutListViewController ()

@property (nonatomic, strong) UIBarButtonItem *addButton;

@property (nonatomic, strong) NSArray *accountList;

@end

@implementation AccoutListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.title = NSLocalizedString(@"账号", @"");
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[PYCoreDataController sharedInstance] saveContext];
}

#pragma mark - Public

- (void)reloadData {
    [self reloadAccountList];
    
    if (self.accountList.count>0) {
        NSArray *rightButtons = @[self.addButton, self.editButtonItem];
        [self.navigationItem setRightBarButtonItems:rightButtons];
    } else {
        self.navigationItem.rightBarButtonItem = self.addButton;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Private

- (void)reloadAccountList {
    NSArray *array = [[app.activeUser.accounts objectEnumerator] allObjects];
    [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        Account * account1 = (Account *)obj1;
        Account * account2 = (Account *)obj2;
        
        NSComparisonResult result = [account1.keyword compare:account2.keyword];
        return result;
    }];
    self.accountList = [NSArray arrayWithArray:array];
}

#pragma mark - Accessor

- (UIBarButtonItem *)addButton {
    if (!_addButton) {
        _addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAccoutAction:)];
    }
    return _addButton;
}

#pragma mark - Action

- (void)addAccoutAction:(UIButton *)sender {
    // add account
    [self performSegueWithIdentifier:@"AccountToAdd" sender:nil];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.accountList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AccountListCellIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AccountListCellIdentifier"];
    }
    Account *account = [self.accountList objectAtIndex:indexPath.row];
    if (account.keyword && account.keyword.length>0) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", account.keyword];
    } else {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", account.account];
    }
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView beginUpdates];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        Account *account = [self.accountList objectAtIndex:indexPath.row];
        [app.activeUser removeAccountsObject:account];
        [self reloadAccountList];
        [tableView endUpdates];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    Account *account = [self.accountList objectAtIndex:indexPath.row];
    [SVProgressHUD showInfoWithStatus:account.user.name];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView*)tableView didEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    TTDEBUGLOG(@"didEndEditingRowAtIndexPath");
    
}

@end
