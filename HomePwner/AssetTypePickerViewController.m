//
//  AssetTypePickerViewController.m
//  HomePwner
//
//  Created by Ryan Case on 10/1/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "AssetTypePickerViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "AddAssetViewController.h"
#import "NewItemNavController.h"

@interface AssetTypePickerViewController ()

@end

@implementation AssetTypePickerViewController

@synthesize item;

- (id)init
{
    return [super initWithStyle:UITableViewStyleGrouped];
}
- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[self tableView] reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allAssetTypes] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)ip
{
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
    
    NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType = [allAssets objectAtIndex:[ip row]];
    
    // Use key-value coding to get the asset type's label
    NSString *assetLabel = [assetType valueForKey:@"label"];
    [[cell textLabel] setText:assetLabel];
    
    // Checkmark the one that is currently selected
    if (assetType == [item assetType]) {
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    } else {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    NSArray *allAssets = [[BNRItemStore sharedStore] allAssetTypes];
    NSManagedObject *assetType  = [allAssets objectAtIndex:[indexPath row]];
    
    // If this is being run on an iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // Use the delegate method for the popover view
        if ([[self delegate] respondsToSelector:@selector(didChangeSelection:)]) {
            [[self delegate] didChangeSelection:assetType];
        }
    } else {
        [item setAssetType:assetType];
        [[self navigationController] popViewControllerAnimated:YES];
    }
}

- (UIView *)assetPickerFooterView
{
    if (!assetPickerFooterView) {
        [[NSBundle mainBundle] loadNibNamed:@"AssetPickerFooterView" owner:self options:nil];
    }
    return assetPickerFooterView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.assetPickerFooterView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [[self assetPickerFooterView] bounds].size.height;
}

- (IBAction)newAssetType:(id)sender
{
    NSLog(@"Button pressed");
    AddAssetViewController *addAssetViewController = [[AddAssetViewController alloc] init];
    NewItemNavController *navController = [[NewItemNavController alloc] initWithRootViewController:addAssetViewController];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];

    [[self navigationController] pushViewController:addAssetViewController animated:YES];
}

@end




















