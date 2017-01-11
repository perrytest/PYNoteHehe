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

@property (nonatomic, strong) NSArray<PYAppProxy *> *installArray;

//@property (nonatomic, strong) NSIndexPath *selectIndexPath;
@property (nonatomic, strong) NSMutableArray<NSIndexPath *> *selectedIndexPaths;

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
    [self setupSelectList];
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

- (void)setupSelectList {
    for (PYAppProxy *appProxy in self.originList) {
        [self.installArray enumerateObjectsUsingBlock:^(PYAppProxy * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([appProxy.applicationIdentifier isEqualToString:obj.applicationIdentifier]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:idx inSection:0];
                [self.selectedIndexPaths addObject:indexPath];
                *stop = YES;
            }
        }];
    }
}

- (BOOL)isSelectedForIndexPath:(NSIndexPath *)selectIndexPath {
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
        if ([indexPath compare:selectIndexPath] == NSOrderedSame) {
            return YES;
        }
    }
    return NO;
}

- (NSArray *)selectedAppModels {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSIndexPath *indexPath in self.selectedIndexPaths) {
        PYAppProxy *appProxy = self.installArray[indexPath.row];
        [array addObject:appProxy];
    }
    
    return [NSArray arrayWithArray:array];
}

#pragma mark - Action

- (void)doneAction:(id)sender {
    if (self.selectedIndexPaths.count>0) {
        NSMutableArray *selectAppList = [[NSMutableArray alloc] initWithCapacity:1];
        [self.selectedIndexPaths enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSIndexPath *indexPath = (NSIndexPath *)obj;
            PYAppProxy *appProxy = [self.installArray objectAtIndex:indexPath.row];
            [selectAppList addObject:appProxy];
        }];
        if (selectAppList.count>0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectedAppList:)]) {
                [self.delegate didSelectedAppList:selectAppList];
            }
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - UITableViewDelegate

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
    PYAppProxy *model = [self.installArray objectAtIndex:indexPath.row];
    TTDEBUGLOG(@"app info : %@", model);
//    [[PYAppManager shareAppManager] openAppWithBundleId:model.applicationIdentifier];
    
//    NSString *title = [NSString stringWithFormat:NSLocalizedString(@"App_Delete_Title", @""), model.localizedName];
//    NSString *messager = [NSString stringWithFormat:NSLocalizedString(@"App_Delete_Messager", @""), model.localizedName];
//    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:messager delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", @"") otherButtonTitles:NSLocalizedString(@"Delete", @""), nil];
//    [alertView show];
    
    
}


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
