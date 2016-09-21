//
//  AppListViewController.m
//  PYNote
//
//  Created by kingnet on 16/9/19.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "AppListViewController.h"
#import "PYAppManager.h"
#import "PYAppProxy.h"



@interface AppListViewController ()

@property (nonatomic, strong) NSArray *installArray;

@property (nonatomic, strong) NSIndexPath *selectIndexPath;

@end

@implementation AppListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSArray *installedArray = [[PYAppManager shareAppManager] installedArray];
    self.installArray = [NSArray arrayWithArray:installedArray];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.installArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AppListCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"AppListCell"];
    }
    PYAppProxy *model = [self.installArray objectAtIndex:indexPath.row];
    cell.imageView.image = [model appIconWithFormat:1];
    cell.textLabel.text = model.localizedName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"version:%@", model.shortVersionString];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectIndexPath = indexPath;
    PYAppProxy *model = [self.installArray objectAtIndex:indexPath.row];
    [[PYAppManager shareAppManager] openAppWithBundleId:model.applicationIdentifier];
//    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"App_Delete_Title", @""), model.localizedName];
//    NSString *messager = [NSString stringWithFormat:NSLocalizedString(@"App_Delete_Messager", @""), model.localizedName];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:messager delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"Delete", @""), nil];
//    [alertView show];
}


#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        PYAppProxy *model = [self.installArray objectAtIndex:self.selectIndexPath.row];
        [[PYAppManager shareAppManager] uninstallAppWithBundleId:model.applicationIdentifier];
    }
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
