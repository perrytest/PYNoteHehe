//
//  UserInfoViewController.m
//  PYNote
//
//  Created by kingnet on 16/12/1.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "UserInfoViewController.h"
#import <Photos/Photos.h>


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
    
    self.tableView.tableFooterView = ({
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 80)];
        
        UIButton *logoutButton = [[UIButton alloc] initWithFrame:CGRectMake((self.view.width-120)/2, 20, 120, 40)];
        [logoutButton setTitle:NSLocalizedString(@"退出登录", @"") forState:UIControlStateNormal];
        [logoutButton setTitleColor:Color_FC08 forState:UIControlStateNormal];
        logoutButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [logoutButton addTarget:self action:@selector(logoutAction:) forControlEvents:UIControlEventTouchUpInside];
        [footerView addSubview:logoutButton];
        
        footerView;
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
            NSString *avatarFilePath = [[PYTools getResourceRootDirectoryPath] stringByAppendingPathComponent:self.user.avator];
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

- (void)logoutAction:(UIButton *)sender {
    [app logout];
    [self.navigationController popViewControllerAnimated:NO];
    [app.rootVC showLoginPage:YES];
}

#pragma mark - Private

- (void)writeAvatarData {
    if (self.user.avator && self.user.avator.length>0) {
        NSString *avatarFilePath = [[PYTools getResourceRootDirectoryPath] stringByAppendingPathComponent:self.user.avator];
        if ([[NSFileManager defaultManager] fileExistsAtPath:avatarFilePath]) {
            [[NSFileManager defaultManager] removeItemAtPath:avatarFilePath error:NULL];
        }
    }
    NSString *avatarFileName = [NSString stringWithFormat:@"%@_avatar.png", self.user.userId];
    NSString *avatarFilePath = [[PYTools getResourceRootDirectoryPath] stringByAppendingPathComponent:avatarFileName];
    [self.avatarData writeToFile:avatarFilePath atomically:YES];
    self.user.avator = avatarFileName;
    [[PYCoreDataController sharedInstance] saveContext];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommonCellIdentify" forIndexPath:indexPath];
    return cell;
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
