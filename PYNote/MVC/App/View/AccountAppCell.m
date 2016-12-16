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
    self.backgroundColor = [UIColor yellowColor];
}

@end
