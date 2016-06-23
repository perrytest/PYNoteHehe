//
//  RegistVC.m
//  PYMemorandum
//
//  Created by perry on 14-8-15.
//  Copyright (c) 2014年 Perry. All rights reserved.
//

#import "RegistVC.h"
#import "PYTextfieldCell.h"


#import "ReactiveCocoa.h"

static NSString *cellTFIdentifier = @"kCellTextFieldIdentifier";

@interface RegistVC ()

@property (nonatomic, strong) UIBarButtonItem *doneButton;

@property (nonatomic, retain) PYUserModel *user;

@end


@implementation RegistVC



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"注册", @"");
    
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([PYTextfieldCell class]) bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:cellTFIdentifier];
    
    self.user = [[PYUserModel alloc] init];
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
    if (self.user.name && self.user.name.length>0 && self.user.pwd_s && self.user.pwd_s.length>0) {
        self.user.userId = [PYTools getUniqueId];
        TTDEBUGLOG(@"save account id:%@", self.user.userId);
        self.user.token = NSStringFromInteger([[NSDate date] timeIntervalSince1970]);
        [[PYCoreDataController sharedInstance] saveContext];
    }
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PYTextfieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTFIdentifier forIndexPath:indexPath];
    
    cell.inputTF.secureTextEntry = NO;
    cell.inputTF.placeholder = nil;
    switch (indexPath.row) {
        case 0:
            cell.titleLabel.text = NSLocalizedString(@"姓名", @"");
            cell.inputTF.placeholder = NSLocalizedString(@"请输入姓名", @"");
            RAC(self.user, name) = [[cell.inputTF rac_textSignal] takeUntil:[cell rac_prepareForReuseSignal]];
            RAC(cell.inputTF, text) = [RACObserve(self.user, name) takeUntil:[cell rac_prepareForReuseSignal]];
            break;
        case 1:
            cell.titleLabel.text = NSLocalizedString(@"昵称", @"");
            cell.inputTF.placeholder = NSLocalizedString(@"请输入昵称", @"");
            RAC(self.user, nameNick) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
            RAC(cell.inputTF, text) = [RACObserve(self.user, nameNick) takeUntil:[cell rac_prepareForReuseSignal]];
            break;
        case 2:
            cell.titleLabel.text = NSLocalizedString(@"密码", @"");
            cell.inputTF.secureTextEntry = YES;
            RAC(self.user, pwd_s) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
            RAC(cell.inputTF, text) = [RACObserve(self.user, pwd_s) takeUntil:[cell rac_prepareForReuseSignal]];
            break;
        case 3:
            cell.titleLabel.text = NSLocalizedString(@"身份证", @"");
            RAC(self.user, cardId) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
            RAC(cell.inputTF, text) = [RACObserve(self.user, cardId) takeUntil:[cell rac_prepareForReuseSignal]];
            break;
        case 4:
            cell.titleLabel.text = NSLocalizedString(@"手机号码", @"");
            RAC(self.user, phone) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
            RAC(cell.inputTF, text) = [RACObserve(self.user, phone) takeUntil:[cell rac_prepareForReuseSignal]];
            break;
        case 5:
            cell.titleLabel.text = NSLocalizedString(@"email", @"");
            cell.inputTF.placeholder = NSLocalizedString(@"请输入email", @"");
            RAC(self.user, email) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
            RAC(cell.inputTF, text) = [RACObserve(self.user, email) takeUntil:[cell rac_prepareForReuseSignal]];
            break;
        case 6:
            cell.titleLabel.text = NSLocalizedString(@"QQ", @"");
            cell.inputTF.placeholder = NSLocalizedString(@"请输入QQ", @"");
            RAC(self.user, qq) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
            RAC(cell.inputTF, text) = [RACObserve(self.user, qq) takeUntil:[cell rac_prepareForReuseSignal]];
            break;
        case 7:
            cell.titleLabel.text = NSLocalizedString(@"地址", @"");
            cell.inputTF.placeholder = NSLocalizedString(@"请输入地址", @"");
            RAC(self.user, address) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
            RAC(cell.inputTF, text) = [RACObserve(self.user, address) takeUntil:[cell rac_prepareForReuseSignal]];
            break;
        case 8:
            cell.titleLabel.text = NSLocalizedString(@"座右铭", @"");
            cell.inputTF.placeholder = NSLocalizedString(@"请输入座右铭", @"");
            RAC(self.user, motto) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
            RAC(cell.inputTF, text) = [RACObserve(self.user, motto) takeUntil:[cell rac_prepareForReuseSignal]];
            break;
        case 9:
            cell.titleLabel.text = NSLocalizedString(@"备注", @"");
            cell.inputTF.placeholder = NSLocalizedString(@"请输入座右铭", @"");
            RAC(self.user, notice) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
            RAC(cell.inputTF, text) = [RACObserve(self.user, notice) takeUntil:[cell rac_prepareForReuseSignal]];
            break;
        default:
            break;
    }
    return cell;
}

@end
