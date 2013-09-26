//
//  HomePwnerItemCell.h
//  HomePwner
//
//  Created by Ryan Case on 9/24/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePwnerItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) id controller;
@property (weak, nonatomic) UITableView *tableView;

- (IBAction)showImage:(id)sender;

@end
