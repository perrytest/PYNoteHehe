//
//  AccountAppCell.m
//  PYNote
//
//  Created by kingnet on 16/12/15.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "AccountAppCell.h"

@interface AccountAppCell ()

@property (nonatomic, strong) IBOutlet UIImageView *iconImageView;
@property (nonatomic, strong) IBOutlet UILabel *titleLabel;

@end

@implementation AccountAppCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = @"添加";
}

- (void)loadUIWithApp:(PYAppProxy *)appProxy {
    if (appProxy) {
        self.titleLabel.text = appProxy.localizedName;
        self.iconImageView.image = [appProxy appIconWithFormat:2];
        self.iconImageView.layer.cornerRadius = 0.0f;
    } else {
        self.titleLabel.text = @"添加";
        self.iconImageView.image = [UIImage imageNamed:@"Icon_app"];
        self.iconImageView.layer.cornerRadius = 14.0f;
    }
}

@end
