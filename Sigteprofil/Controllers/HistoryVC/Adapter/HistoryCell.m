//
//  SimpleTableCell.m
//  SimpleTable
//
//  Created by Simon Ng on 28/4/12.
//  Copyright (c) 2012 Appcoda. All rights reserved.
//

#import "HistoryCell.h"

@implementation HistoryCell

@synthesize label_navn_dato = _label_navn_dato;
@synthesize label_under = _label_under;
@synthesize label_middle = _label_middle;
@synthesize label_over = _label_over;
@synthesize label_note = _label_note;
@synthesize btn_note = _btn_note;




- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
