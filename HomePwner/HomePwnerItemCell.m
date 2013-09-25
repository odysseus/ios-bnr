//
//  HomePwnerItemCell.m
//  HomePwner
//
//  Created by Ryan Case on 9/24/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "HomePwnerItemCell.h"

@implementation HomePwnerItemCell

@synthesize nameLabel, valueLabel, thumbnailView, serialLabel;

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
