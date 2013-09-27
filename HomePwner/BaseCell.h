//
//  BaseCell.h
//  HomePwner
//
//  Created by Ryan Case on 9/27/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCell : UITableViewCell

@property (weak, nonatomic) UITableView *tableView;
@property (weak, nonatomic) id controller;

- (void)sendSelectorToController:(NSString *)selectorName withParams:(NSArray *)params;
@end
