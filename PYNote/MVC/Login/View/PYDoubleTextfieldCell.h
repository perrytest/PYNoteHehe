//
//  PYDoubleTextfieldCell.h
//  PYNote
//
//  Created by 杨鹏远 on 16/6/3.
//  Copyright © 2016年 perry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PYDoubleTextfieldCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITextField *leftInputTF;
@property (strong, nonatomic) IBOutlet UITextField *rightInputTF;

@end
