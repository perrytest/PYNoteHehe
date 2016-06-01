//
//  AccountTextFieldCell.m
//  PYNote
//
//  Created by kingnet on 16/5/13.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "AccountTextFieldCell.h"
#import "ReactiveCocoa.h"

@interface AccountTextFieldCell ()

@end

@implementation AccountTextFieldCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse {
//    [self.inputTF rac_deallocDisposable];
}

@end
