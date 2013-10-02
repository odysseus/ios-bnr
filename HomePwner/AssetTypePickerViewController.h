//
//  AssetTypePickerViewController.h
//  HomePwner
//
//  Created by Ryan Case on 10/1/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookupPickerDelegate.h"

@class BNRItem;

@interface AssetTypePickerViewController : UITableViewController
{
    IBOutlet UIView *assetPickerFooterView;
}

@property (nonatomic, strong) BNRItem *item;
@property (nonatomic, unsafe_unretained) NSObject <LookupPickerDelegate> *delegate;

- (UIView *)assetPickerFooterView;
- (IBAction)newAssetType:(id)sender;


@end
