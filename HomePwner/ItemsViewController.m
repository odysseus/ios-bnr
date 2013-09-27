//
//  ItemsViewController.m
//  HomePwner
//
//  Created by Ryan Case on 9/19/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "ItemsViewController.h"
#import "BNRItem.h"
#import "BNRItemStore.h"
#import "BNRImageStore.h"
#import "DetailViewController.h"
#import "NewItemNavController.h"
#import "HomePwnerItemCell.h"
#import "ImageViewController.h"

@interface ItemsViewController ()

@end

@implementation ItemsViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Homepwner"];
        
        // Create a button to add a new item
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                     target:self
                                                     action:@selector(addNewItem:)];
        // Set it as the right item in navigationItem
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load the nib file
    UINib *nib = [UINib nibWithNibName:@"HomePwnerItemCell" bundle:nil];
    
    // Register this NIB which contains the cell
    [[self tableView] registerNib:nib
           forCellReuseIdentifier:@"HomepwnerItemCell"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set the text on the cell with the description of the item at the n-th index of allItems
    BNRItem *p = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[indexPath row]];
    
    // Get the new or recycled cell
    HomePwnerItemCell *cell = [tableView
                               dequeueReusableCellWithIdentifier:@"HomepwnerItemCell"];
    
    // Configure the cell with the BNRItem
    [cell setController:self];
    [cell setTableView:tableView];
    [[cell nameLabel] setText:[p itemName]];
    [[cell serialLabel] setText:[p serialNumber]];
    [[cell valueLabel] setText: [NSString stringWithFormat:@"$%d", [p valueInDollars]]];
    [[cell thumbnailView] setImage:[p thumbnail]];
    if ([p valueInDollars] > 50) {
        [[cell valueLabel] setTextColor:[UIColor colorWithRed:0.0 green:0.5 blue:0.0 alpha:1.0]];
    } else {
        [[cell valueLabel] setTextColor:[UIColor colorWithRed:0.7 green:0.0 blue:0.0 alpha:1.0]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController = [[DetailViewController alloc] initForNewItem:NO];
    
    // Add the BNRItems array and find the specified BNRItem
    NSArray *items = [[BNRItemStore sharedStore] allItems];
    BNRItem *selectedItem = [items objectAtIndex:[indexPath row]];
    
    // Give the details view controller a pointer to the item
    [detailViewController setItem:selectedItem];
    
    [[self navigationController] pushViewController:detailViewController animated:YES];
}

// Add a new item by clicking the button at top
- (IBAction)addNewItem:(id)sender
{
    // Create a new BNRItem and add it to the store
    BNRItem *newItem = [[BNRItemStore sharedStore] createItem];
    
    DetailViewController *detailViewController =
    [[DetailViewController alloc] initForNewItem:YES];
    
    [detailViewController setItem:newItem];
    
    [detailViewController setDismissBlock:^{
        [[self tableView] reloadData];}
     ];
    
    NewItemNavController *navController = [[NewItemNavController alloc]
                                             initWithRootViewController:detailViewController];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentViewController:navController animated:YES completion:nil];
}

// Commits the deletion request
-   (void)tableView:(UITableView *)tableView
 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
  forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        BNRItemStore *ps = [BNRItemStore sharedStore];
        NSArray *items = [ps allItems];
        BNRItem *p = [items objectAtIndex:[indexPath row]];
        [ps removeItem:p];
        
        // We also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                         withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

-   (void)tableView:(UITableView *)tableView
 moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
        toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[BNRItemStore sharedStore] moveItemAtIndex:[sourceIndexPath row]
                                        toIndex:[destinationIndexPath row]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[self tableView] reloadData];
}

// Formatting, header and footer

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [[self footerView] bounds].size.height;
}

- (UIView *)footerView
{
    if (!footerView) {
        [[NSBundle mainBundle] loadNibNamed:@"FooterView" owner:self options:nil];
    }
    return footerView;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Items";
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

- (void)showImage:(id)sender atIndexPath:(NSIndexPath *)ip
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // Get the BNRItem from the index path
        BNRItem *i = [[[BNRItemStore sharedStore] allItems] objectAtIndex:[ip row]];
        // Make sure there's an image, if not don't display anything
        UIImage *img = [[BNRImageStore sharedStore] imageForKey:[i imageKey]];
        if (!img) {
            NSLog(@"No image found");
            return;
        }
        
        // The Popover controller refuses to display the images for reasons only god knows
        // pushing another view controller onto the stack is a good temporary solution
        UIViewController *zoomedPictureViewController = [[UIViewController alloc] init];
        zoomedPictureViewController.view.frame = self.view.frame;
        UIImage *image = img;
        
        UIImageView *zoomedPictureView = [[UIImageView alloc] initWithImage:image];
        [zoomedPictureView setContentMode:UIViewContentModeScaleAspectFit];
        
        zoomedPictureView.frame = zoomedPictureViewController.view.frame;
        [zoomedPictureViewController.view addSubview:zoomedPictureView];
        
        [self.navigationController pushViewController:zoomedPictureViewController animated:YES];
        
//        // Make a frame relative to the button pressed
//        CGRect rect = [[self view] convertRect:[sender bounds] fromView:sender];
//        
//        // Create a new ImageViewController and set its image
//        ImageViewController *ivc = [[ImageViewController alloc] init];
//        [ivc setImage:img];
//
//        
//        // Present a 600x600 popover for the rect
//        imagePopover = [[UIPopoverController alloc]
//                        initWithContentViewController:ivc];
//        [imagePopover setDelegate:self];
//        [imagePopover setPopoverContentSize:CGSizeMake(600, 600)];
//        [imagePopover presentPopoverFromRect:rect
//                                      inView:[self view]
//                    permittedArrowDirections:UIPopoverArrowDirectionAny
//                                    animated:YES];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    [imagePopover dismissPopoverAnimated:YES];
    imagePopover = nil;
}

@end
























