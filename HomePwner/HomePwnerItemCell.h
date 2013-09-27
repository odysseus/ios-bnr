//
//  HomePwnerItemCell.h
//  HomePwner
//
//  Created by Ryan Case on 9/24/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"

@interface HomePwnerItemCell : BaseCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) UITableView *tableView;

- (IBAction)showImage:(id)sender;

@end
