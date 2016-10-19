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

@property (nonatomic, strong) UIBarButtonItem *doneButton;

@property (nonatomic, strong) NSArray *installArray;

//@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) NSMutableArray *selectedIndexPaths;

@end

@implementation AppListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"App列表", @"");
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     self.navigationItem.rightBarButtonItem = self.doneButton;
    
    NSArray *installedArray = [[PYAppManager shareAppManager] installedArray];
    self.installArray = [NSArray arrayWithArray:installedArray];
    
    self.selectedIndexPaths = [[NSMutableArray alloc] initWithCapacity:1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessor

- (UIBarButtonItem *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    }
    return _doneButton;
}

#pragma mark - Private

- (BOOL)isSelectedForIndexPath:(NSIndexPath *)selectIndexPath {
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
        if ([indexPath compare:selectIndexPath] == NSOrderedSame) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Action

- (void)doneAction:(id)sender {
    
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
    if ([self isSelectedForIndexPath:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self isSelectedForIndexPath:indexPath]) {
        //remove select indexPath
        [self.selectedIndexPaths removeObject:indexPath];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        //add select indexPath
        [self.selectedIndexPaths addObject:indexPath];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
//    self.selectIndexPath = indexPath;
//    PYAppProxy *model = [self.installArray objectAtIndex:indexPath.row];
//    [[PYAppManager shareAppManager] openAppWithBundleId:model.applicationIdentifier];
    
//    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"App_Delete_Title", @""), model.localizedName];
//    NSString *messager = [NSString stringWithFormat:NSLocalizedString(@"App_Delete_Messager", @""), model.localizedName];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:messager delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"Delete", @""), nil];
//    [alertView show];
    
    
}

//- (void)


//#pragma mark - UIAlertViewDelegate
//
//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
//    if (buttonIndex == 1) {
//        PYAppProxy *model = [self.installArray objectAtIndex:self.selectIndexPath.row];
//        [[PYAppManager shareAppManager] uninstallAppWithBundleId:model.applicationIdentifier];
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
