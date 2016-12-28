//
//  TitleSettingViewController.m
//  PYNote
//
//  Created by kingnet on 16/12/19.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "TitleSettingViewController.h"
#import "PYTextfieldCell.h"
#import "PYDoubleTextfieldCell.h"
#import "ReactiveCocoa.h"

static NSString *cellTFIdentifierDouble = @"DoubleCellTextFieldIdentifier";

@interface TitleSettingViewController ()


@end

@implementation TitleSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneAction:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    UINib *cellNib1 = [UINib nibWithNibName:NSStringFromClass([PYTextfieldCell class]) bundle:nil];
    [self.tableView registerNib:cellNib1 forCellReuseIdentifier:NormalSingleTFCellID];
    UINib *cellNib2 = [UINib nibWithNibName:NSStringFromClass([PYDoubleTextfieldCell class]) bundle:nil];
    [self.tableView registerNib:cellNib2 forCellReuseIdentifier:cellTFIdentifierDouble];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action

- (void)doneAction:(UIBarButtonItem *)sender {
    if (self.changedBlock) {
        self.changedBlock(self.textValue, self.noticeValue);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hasNotice) {
        PYDoubleTextfieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTFIdentifierDouble forIndexPath:indexPath];
        cell.leftInputTF.placeholder = [NSString stringWithFormat:NSLocalizedString(@"Input_Some", @""), self.title];
        cell.leftInputTF.secureTextEntry = self.secureTextEntry;
        cell.leftInputTF.text = self.textValue;
        cell.rightInputTF.text = self.noticeValue;
        RAC(self, textValue) = [[cell.leftInputTF rac_textSignal] takeUntil:[cell rac_prepareForReuseSignal]];
        RAC(self, noticeValue) = [[cell.rightInputTF rac_textSignal] takeUntil:[cell rac_prepareForReuseSignal]];
        return cell;
    } else {
        PYTextfieldCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalSingleTFCellID forIndexPath:indexPath];
        cell.inputTF.placeholder = [NSString stringWithFormat:NSLocalizedString(@"Input_Some", @""), self.title];
        cell.inputTF.secureTextEntry = self.secureTextEntry;
        cell.inputTF.text = self.textValue;
        RAC(self, textValue) = [[cell.inputTF rac_textSignal] takeUntil:[cell rac_prepareForReuseSignal]];
        return cell;
    }
    
    return nil;
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
