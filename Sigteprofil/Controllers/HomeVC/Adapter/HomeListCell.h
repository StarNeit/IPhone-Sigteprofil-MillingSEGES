//
//  SimpleTableCell.h
//  SimpleTable
//
//  Created by Simon Ng on 28/4/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeListCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *tv_grain_name;
@property (strong, nonatomic) IBOutlet UIButton *btn_edit_grain;
@property (strong, nonatomic) IBOutlet UIView *view_back;

@end
