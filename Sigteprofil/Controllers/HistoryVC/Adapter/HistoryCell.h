//
//  SimpleTableCell.h
//  SimpleTable
//
//  Created by Simon Ng on 28/4/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HistoryCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *label_navn_dato;
@property (strong, nonatomic) IBOutlet UILabel *label_under;
@property (strong, nonatomic) IBOutlet UILabel *label_middle;
@property (strong, nonatomic) IBOutlet UILabel *label_over;
@property (strong, nonatomic) IBOutlet UILabel *label_note;
@property (strong, nonatomic) IBOutlet UIButton *btn_note;


@end
