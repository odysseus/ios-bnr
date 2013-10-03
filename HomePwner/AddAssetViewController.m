//
//  AddAssetViewController.m
//  HomePwner
//
//  Created by Ryan Case on 10/2/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "AddAssetViewController.h"
#import "BNRItemStore.h"

@interface AddAssetViewController ()

@end

@implementation AddAssetViewController

- (IBAction)submitAssetType:(id)sender
{
    NSString *newAssetTypeString = newAssetType.text;
    if (![[[BNRItemStore sharedStore] allAssetTypes] containsObject:newAssetTypeString]) {
        [[BNRItemStore sharedStore] addNewAssetTypeWithType:newAssetTypeString];
    }
    [[self view] endEditing:YES];
    [[self navigationController] popViewControllerAnimated:YES];
}

@end
