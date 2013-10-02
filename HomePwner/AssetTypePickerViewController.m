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
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        SEL didChangeSelection = @selector(didChangeSelection:);
        
        //tell my delegate
        if ([[self delegate ] respondsToSelector:didChangeSelection]) {
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
    // TODO: Finish implementing the Silver Challenge
    NSLog(@"Button pressed");
}

@end
