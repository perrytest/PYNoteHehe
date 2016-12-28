//
//  RegistVC.m
//  PYMemorandum
//
//  Created by perry on 14-8-15.
//  Copyright (c) 2014年 Perry. All rights reserved.
//

#import "RegistVC.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

#import "GestureLockVC.h"
#import "PYTextfieldCell.h"
#import "PYDoubleTextfieldCell.h"

#import "PYUserModel.h"

#import "ReactiveCocoa.h"


static NSString *cellTFIdentifierNormal = @"kNormalCellIdentifier";
static NSString *cellTFIdentifierDouble = @"DoubleCellTextFieldIdentifier";

@interface RegistVC () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, copy) NSData *avatarData;

@property (nonatomic, strong) UIBarButtonItem *doneButton;

@property (nonatomic, retain) PYUserModel *user;

@end


@implementation RegistVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = NSLocalizedString(@"注册", @"");
    
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    UINib *cellNib1 = [UINib nibWithNibName:NSStringFromClass([PYTextfieldCell class]) bundle:nil];
    UINib *cellNib2 = [UINib nibWithNibName:NSStringFromClass([PYDoubleTextfieldCell class]) bundle:nil];
    [self.tableView registerNib:cellNib1 forCellReuseIdentifier:NormalSingleTFCellID];
    [self.tableView registerNib:cellNib2 forCellReuseIdentifier:cellTFIdentifierDouble];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellTFIdentifierNormal];
    
    self.tableView.tableHeaderView = ({
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
        
        [headerView addSubview:self.avatarButton];
        
        headerView;
    });
    
    
    self.user = [[PYUserModel alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)addUserToCoreData {
    NSManagedObjectContext *context = [PYCoreDataController sharedInstance].managedObjectContext;
    User *insertUser = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    [self.user convertInfoToUser:&insertUser];
    [insertUser refreshAuthToken];
    [app setActiveUser:insertUser];
}

#pragma mark - Accessor

- (UIBarButtonItem *)doneButton {
    if (!_doneButton) {
        _doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addUserDoneAction:)];
    }
    return _doneButton;
}

- (UIButton *)avatarButton {
    if (_avatarButton == nil) {
        _avatarButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width-60)/2, 20, 60, 60)];
        [_avatarButton setBackgroundImage:[UIImage imageNamed:@"Icon_avatar"] forState:UIControlStateNormal];
        _avatarButton.layer.cornerRadius = 30.0;
        _avatarButton.clipsToBounds = YES;
        [_avatarButton addTarget:self action:@selector(avartarClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarButton;
}

#pragma mark - Action

- (void)addUserDoneAction:(UIButton *)sender {
    // add User
    
    if ([self.user isUserRegistValid]) {
        self.user.userId = [PYTools getUniqueId];
        [PYTools makeResourceDirectoryForUser:self.user.userId];
        TTDEBUGLOG(@"save user id:%@", self.user.userId);
        self.user.creatAt = [NSDate date];
        self.user.lastAt = [NSDate date];
        
        if (self.avatarData && self.avatarData.length>0) {
            NSString *avatarFileName = [NSString stringWithFormat:@"%@_avatar.png", self.user.userId];
            NSURL *avatarFilePath = [[PYTools URLForResourceDirectoryForUser:self.user.userId] URLByAppendingPathComponent:avatarFileName];
            [self.avatarData writeToURL:avatarFilePath atomically:YES];
            self.user.avator = avatarFileName;
        }
        
        [self addUserToCoreData];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        if (![self.user isUserValid]) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"请输入用户名和密码", nil)];
        } else {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"用户已存在", nil)];
        }
    }
}

- (void)avartarClickAction:(UIButton *)sender {
    UIActionSheet *avatarSettingSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"从相册选择", nil), NSLocalizedString(@"拍照", nil), nil];
    [avatarSettingSheet showInView:self.view];
    
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 10;
            break;
        case 1:
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
            if (indexPath.row == 2) {
                PYDoubleTextfieldCell *cell = [tableView dequeueReusableCellWithIdentifier:cellTFIdentifierDouble forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.leftInputTF.secureTextEntry = YES;
                cell.leftInputTF.placeholder = NSLocalizedString(@"请输入密码", @"");
                cell.rightInputTF.secureTextEntry = NO;
                cell.rightInputTF.placeholder = NSLocalizedString(@"密码备注", @"");
                RAC(self.user, pwd_s) = [cell.leftInputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
                RAC(self.user, pwd_notice) = [cell.rightInputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
                
                return cell;
            }
            
            PYTextfieldCell *cell = [tableView dequeueReusableCellWithIdentifier:NormalSingleTFCellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.inputTF.secureTextEntry = NO;
            cell.inputTF.placeholder = nil;
            switch (indexPath.row) {
                case 0:
                    cell.inputTF.placeholder = NSLocalizedString(@"请输入姓名", @"");
                    RAC(self.user, name) = [[cell.inputTF rac_textSignal] takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 1:
                    cell.inputTF.placeholder = NSLocalizedString(@"请输入昵称", @"");
                    RAC(self.user, nameNick) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 3:
                    cell.inputTF.placeholder = NSLocalizedString(@"请输入身份证", @"");
                    RAC(self.user, cardId) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 4:
                    cell.inputTF.placeholder = NSLocalizedString(@"请输入手机号码", @"");
                    RAC(self.user, phone) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 5:
                    cell.inputTF.placeholder = NSLocalizedString(@"请输入email", @"");
                    RAC(self.user, email) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 6:
                    cell.inputTF.placeholder = NSLocalizedString(@"请输入QQ", @"");
                    RAC(self.user, qq) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 7:
                    cell.inputTF.placeholder = NSLocalizedString(@"请输入地址", @"");
                    RAC(self.user, address) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 8:
                    cell.inputTF.placeholder = NSLocalizedString(@"请输入座右铭", @"");
                    RAC(self.user, motto) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 9:
                    cell.inputTF.placeholder = NSLocalizedString(@"请输入备注留言", @"");
                    RAC(self.user, notice) = [cell.inputTF.rac_textSignal takeUntil:[cell rac_prepareForReuseSignal]];
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
                    if (self.user.pwd_g && self.user.pwd_g.length>0) {
                        cell.textLabel.text = NSLocalizedString(@"重新设置手势密码", @"");
                    } else {
                        cell.textLabel.text = NSLocalizedString(@"添加手势密码", @"");
                    }
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
                    GestureLockVC *gestureLockVC = [self.storyboard instantiateViewControllerWithIdentifier:@"GestureLockPage"];
                    gestureLockVC.title = NSLocalizedString(@"设置手势密码", @"");
                    gestureLockVC.type = GestureLockTypeSetPwd;
                    gestureLockVC.successBlock = ^(NSString *pwd) {
                        self.user.pwd_g = pwd;
                    };
                    [self.navigationController pushViewController:gestureLockVC animated:YES];
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

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //判断按键
    if (buttonIndex==2) {
        return;
    }
    UIImagePickerController *pick = [[UIImagePickerController alloc] init];
    pick.delegate = self;
    pick.allowsEditing = YES;
    if(buttonIndex == 1 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusAuthorized || [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusNotDetermined) {
            pick.sourceType = UIImagePickerControllerSourceTypeCamera;
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法访问您的相机。" message:@"您可以在“设置-隐私-相机”中启用访问" delegate:self cancelButtonTitle:NSLocalizedString(@"Sure", nil) otherButtonTitles:nil];
            [alertView show];
            return;
        }
    }
    else if(buttonIndex == 0 && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        @try {
            if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusRestricted || [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied) {
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法访问您的相机。" message:@"您可以在“设置-隐私-相机”中启用访问" delegate:self cancelButtonTitle:NSLocalizedString(@"Sure", nil) otherButtonTitles:nil];
                [alertView show];
                return;
            } else {
                pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
        }
        @catch (NSException *exception) {
            pick.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        @finally {
            
        }
    } else {
        return;
    }
    [self presentViewController:pick animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [UIApplication sharedApplication].statusBarHidden = NO;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self performSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:)];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = nil;
    image = [info objectForKey:UIImagePickerControllerEditedImage];
    [UIApplication sharedApplication].statusBarHidden = NO;
    UIImage *image_ = [self resizeImage:image];
    self.avatarData = UIImagePNGRepresentation(image_);
    [self.avatarButton setBackgroundImage:image_ forState:UIControlStateNormal];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

-(UIImage*)resizeImage:(UIImage*)image
{
    float size = 300/PYMainScale;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(size, size), NO, 0.0);
    [image drawInRect:CGRectMake(0,0,size,size)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
