//
//  ItemsViewController.h
//  HomePwner
//
//  Created by Ryan Case on 9/19/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ItemsViewController : UITableViewController
    <UIPopoverControllerDelegate>
{
    IBOutlet UIView *itemsFooterView;
    UIPopoverController *imagePopover;
}

- (UIView *)itemsFooterView;
- (IBAction)addNewItem:(id)sender;
- (void)showImage:(id)sender atIndexPath:(NSIndexPath *)ip;

@end
