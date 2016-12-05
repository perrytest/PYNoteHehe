//
//  UserInfoViewController.m
//  PYNote
//
//  Created by kingnet on 16/12/1.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "UserInfoViewController.h"
#import <Photos/Photos.h>
#import "ReactiveCocoa.h"

@interface UserInfoViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, copy) NSData *avatarData;

@property (nonatomic, strong) User *user;

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.title = NSLocalizedString(@"个人信息", @"");
    
    self.user = [app activeUser];
    
    self.tableView.tableHeaderView = ({
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
        
        [headerView addSubview:self.avatarButton];
        
        headerView;
    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[PYCoreDataController sharedInstance] saveContext];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Accessor


- (UIButton *)avatarButton {
    if (_avatarButton == nil) {
        _avatarButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width-60)/2, 20, 60, 60)];
        [_avatarButton setBackgroundImage:[UIImage imageNamed:@"Icon_avatar"] forState:UIControlStateNormal];
        _avatarButton.layer.cornerRadius = 30.0;
        _avatarButton.clipsToBounds = YES;
        [_avatarButton addTarget:self action:@selector(avartarClickAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (self.user.avator && self.user.avator.length>0) {
            NSString *avatarFilePath = [[PYTools getResourceDirectoryPathForUser:self.user.userId] stringByAppendingPathComponent:self.user.avator];
            if ([[NSFileManager defaultManager] fileExistsAtPath:avatarFilePath]) {
                self.avatarData = [NSData dataWithContentsOfFile:avatarFilePath];
                UIImage *_image = [UIImage imageWithData:self.avatarData];
                [_avatarButton setBackgroundImage:_image forState:UIControlStateNormal];
            } else {
                self.user.avator = nil;
                [[PYCoreDataController sharedInstance] saveContext];
            }
        }
        
    }
    return _avatarButton;
}

#pragma mark - Action


- (void)avartarClickAction:(UIButton *)sender {
    UIActionSheet *avatarSettingSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"从相册选择", nil), NSLocalizedString(@"拍照", nil), nil];
    [avatarSettingSheet showInView:self.view];
    
}

- (void)logoutAction {
    [app logout];
    [self.navigationController popViewControllerAnimated:NO];
    [app.rootVC showLoginPage:YES];
}

#pragma mark - Private

- (void)writeAvatarData {
    if (self.user.avator && self.user.avator.length>0) {
        NSString *avatarFilePath = [[PYTools getResourceDirectoryPathForUser:self.user.userId] stringByAppendingPathComponent:self.user.avator];
        if ([[NSFileManager defaultManager] fileExistsAtPath:avatarFilePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:avatarFilePath error:NULL];
        }
    }
    NSString *avatarFileName = [NSString stringWithFormat:@"%@_avatar.png", self.user.userId];
    NSString *avatarFilePath = [[PYTools getResourceDirectoryPathForUser:self.user.userId] stringByAppendingPathComponent:avatarFileName];
    [self.avatarData writeToFile:avatarFilePath atomically:YES];
    self.user.avator = avatarFileName;
    [[PYCoreDataController sharedInstance] saveContext];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 9;
            break;
        case 1:
            return 2;
            break;
        case 2:
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
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonRightDetailCell" forIndexPath:indexPath];
            cell.textLabel.font = Font_FS05;
            cell.detailTextLabel.font = Font_FS04;
            cell.detailTextLabel.textColor = HexColor(0x9b9fad);
            cell.detailTextLabel.text = nil;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"姓名", @"");
                    RAC(cell.detailTextLabel, text) = [RACObserve(self.user, name) takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"昵称", @"");
                    RAC(cell.detailTextLabel, text) = [RACObserve(self.user, nameNick) takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 2:
                    cell.textLabel.text = NSLocalizedString(@"身份证", @"");
                    RAC(cell.detailTextLabel, text) = [RACObserve(self.user, cardId) takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 3:
                    cell.textLabel.text = NSLocalizedString(@"手机号码", @"");
                    RAC(cell.detailTextLabel, text) = [RACObserve(self.user, phone) takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 4:
                    cell.textLabel.text = NSLocalizedString(@"email", @"");
                    RAC(cell.detailTextLabel, text) = [RACObserve(self.user, email) takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 5:
                    cell.textLabel.text = NSLocalizedString(@"QQ", @"");
                    RAC(cell.detailTextLabel, text) = [RACObserve(self.user, qq) takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 6:
                    cell.textLabel.text = NSLocalizedString(@"地址", @"");
                    RAC(cell.detailTextLabel, text) = [RACObserve(self.user, address) takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 7:
                    cell.textLabel.text = NSLocalizedString(@"座右铭", @"");
                    RAC(cell.detailTextLabel, text) = [RACObserve(self.user, motto) takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                case 8:
                    cell.textLabel.text = NSLocalizedString(@"备注留言", @"");
                    RAC(cell.detailTextLabel, text) = [RACObserve(self.user, notice) takeUntil:[cell rac_prepareForReuseSignal]];
                    break;
                default:
                    break;
            }
            return cell;
        }
            break;
        case 1: {
            
        }
            break;
        case 2: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonCellIdentify" forIndexPath:indexPath];
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = NSLocalizedString(@"退出登录", @"");
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    cell.textLabel.textColor = Color_FC08;
                    break;
                case 1:
                    cell.textLabel.text = NSLocalizedString(@"注销用户删除数据", @"");
                    cell.textLabel.textAlignment = NSTextAlignmentCenter;
                    cell.textLabel.textColor = Color_FC08;
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
    //预防异常情况
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonCellIdentify" forIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 1: {
            switch (indexPath.row) {
                case 0:
                case 1: {
                    [self logoutAction];
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
    [self writeAvatarData];
    
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
