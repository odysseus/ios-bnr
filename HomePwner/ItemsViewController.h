//
//  ItemsViewController.h
//  HomePwner
//
//  Created by Ryan Case on 9/19/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsViewController : UITableViewController
{
    IBOutlet UIView *headerView;
    IBOutlet UIView *footerView;
}

- (UIView *)headerView;
- (UIView *)footerView;
- (IBAction)addNewItem:(id)sender;
- (IBAction)toggleEditingMode:(id)sender;


@end
