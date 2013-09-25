//
//  DetailViewController.m
//  HomePwner
//
//  Created by Ryan Case on 9/21/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "DetailViewController.h"
#import "BNRItem.h"
#import "DatePickerViewController.h"
#import "BNRImageStore.h"
#import "BNRItemStore.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize item, dismissBlock;

// Override the initializer to throw an exception if the wrong init method is called
- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)bundle
{
    @throw [NSException exceptionWithName:@"Wrong initializer"
                                   reason:@"Use initForNewItem:"
                                 userInfo:nil];
    return nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Set the labels to the BNRItem values
    [nameField setText:[item itemName]];
    [serialField setText:[item serialNumber]];
    [valueField setText:[NSString stringWithFormat:@"%d", [item valueInDollars]]];
    
    // Setting the delegates, along with adding the UITextFieldDelegate Protocol in the header
    // and implementing the textFieldShouldReturn method allow the keyboard to be dismissed
    nameField.delegate = self;
    serialField.delegate = self;
    valueField.delegate = self;
    
    // Create a date formatter to create the date label
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    // Now use the date formatter and the dateCreated to set the dateLabel
    [dateLabel setText:[dateFormatter stringFromDate:[item dateCreated]]];
    
    // Setting the aspect mode property of the imageView button programatically so that
    // it displays the image inside it properly
    [imageView.imageView setContentMode:UIViewContentModeScaleAspectFit];
    
    NSString *imageKey = [item imageKey];
    
    if (imageKey) {
        // Get image for image key from image store
        UIImage *imageToDisplay =
        [[BNRImageStore sharedStore] imageForKey:imageKey];
        
        // Use that image to put on the screen in imageView
        [imageView setImage:imageToDisplay forState:UIControlStateNormal];
    } else {
        // Clear the imageView
        [imageView setImage:nil forState:UIControlStateNormal];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Clear first responder
    [[self view] endEditing:YES];
    
    // Record changes to item
    [item setItemName:[nameField text]];
    [item setSerialNumber:[serialField text]];
    [item setValueInDollars:[[valueField text] intValue]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *clr = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        clr = [UIColor colorWithRed:0.875 green:0.88 blue:0.91 alpha:1];
    } else {
        clr = [UIColor groupTableViewBackgroundColor];
    }
    [[self view] setBackgroundColor:clr];
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
}

- (void)setItem:(BNRItem *)i
{
    item = i;
    [[self navigationItem] setTitle:[item itemName]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)changeDate:(id)sender;
{
    // Create a new DateViewController instance
    DatePickerViewController *dpvc = [[DatePickerViewController alloc] init];
    
    // Passing the current item to the view controller
    [dpvc setDateItem:item];
    
    // Push this new Date View Controller onto the Navigation stack
    [[self navigationController] pushViewController:dpvc
                                           animated:YES];
}

- (IBAction)takePicture:(id)sender
{
    // This code prevents the app from crashing if the camera button is pressed when the
    // popup controller is already displayed.
    if ([imagePickerPopover isPopoverVisible]) {
        // If the popover is already up, get rid of it
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
        return;
    }
    
    // Initialize the UIImagePickerController
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // If our device has a camera we take a picture, otherwise choose from photo library
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    } else {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    
    // Bronze Challenge: Allow Editing
    // I don't like this approach because it requires the picture to be cropped to the
    // size of the imageView so I commented it out
    // [imagePicker setAllowsEditing:YES];
    
    // Place image picker on the screen
    // Check for iPad device before instantiating the popover controller
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        // Create a new popover controller that will display the imagePicker
        imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        [imagePickerPopover setDelegate:self];
        
        // Display the popover controller, sender is the camera bar button item
        [imagePickerPopover presentPopoverFromBarButtonItem:sender
                                   permittedArrowDirections:UIPopoverArrowDirectionAny
                                                   animated:YES];
    } else {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    NSLog(@"User dismissed popover");
    imagePickerPopover = nil;
}

- (IBAction)backgroundTapped:(id)sender
{
    NSLog(@"Background tapped");
    [[self view] endEditing:YES];
}

- (IBAction)removeImage:(id)sender
{
    // First fetch the image ket for the current item
    NSString *key = [item imageKey];
    // If there is no key, do nothing
    if (!key) {
        return;
    // If there is:
    } else {
        // Delete the image from the BNRImageStore
        [[BNRImageStore sharedStore] deleteImageForKey:key];
        // Remove the key from the BNRItem
        [item setImageKey:nil];
        // Set the imageView image to nil, which redraws the screen as well
        [imageView setImage:nil forState:UIControlStateNormal];
        [imageView setNeedsDisplay];
    }
}

- (IBAction)showZoomedPicture:(id)sender
{
    if ([item imageKey]) {
        UIViewController *zoomedPictureViewController = [[UIViewController alloc] init];
        zoomedPictureViewController.view.frame = self.view.frame;
        UIImage *image = [[BNRImageStore sharedStore] imageForKey:[item imageKey]];
        
        UIImageView *zoomedPictureView = [[UIImageView alloc] initWithImage:image];
        [zoomedPictureView setContentMode:UIViewContentModeScaleAspectFit];
        
        zoomedPictureView.frame = zoomedPictureViewController.view.frame;
        [zoomedPictureViewController.view addSubview:zoomedPictureView];
        
        [self.navigationController pushViewController:zoomedPictureViewController animated:YES];
    } else {
        return;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *oldKey = [item imageKey];
    
    // Did the item already have an image?
    if (oldKey) {
        
        // Delete the old image
        [[BNRImageStore sharedStore] deleteImageForKey:oldKey];
    }
    
    // Get picked image from info dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // Create a thumbnail for the row view display
    [item setThumbnailDataFromImage:image];
    
    // Bronze Challenge: choose the edited image instead of the original
//    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];

    
    // Create a unique identifier string
    CFUUIDRef newUniqueID = CFUUIDCreate(kCFAllocatorDefault);
    
    CFStringRef newUniqueIDString =
    CFUUIDCreateString (kCFAllocatorDefault, newUniqueID);
    
    // Use that unique ID to set our item's imageKey
    NSString *key = (__bridge NSString *)newUniqueIDString;
    [item setImageKey:key];
    
    // Store image in the BNRImageStore with this key
    [[BNRImageStore sharedStore] setImage:image
                                   forKey:[item imageKey]];
    
    // CFRelease is needed to prevent a memory leak when using Core Foundation objects
    CFRelease(newUniqueIDString);
    CFRelease(newUniqueID);
    
    // Put that image onto the screen in our image view
    [imageView setImage:image forState:UIControlStateNormal];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        // If on the phone, the image picker is presented modally. Dismiss it.
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        // If on the pad, the image picker is in the popover. Dismiss the popover.
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
    }
}

- (id)initForNewItem:(BOOL)isNew;
{
    self = [super initWithNibName:@"DetailViewController" bundle:nil];
    
    if (self) {
        if (isNew) {
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                    initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                         target:self
                                         action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneItem];
            
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                      initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                           target:self
                                           action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:cancelItem];
        }
    }
    return self;
}

- (void)save:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (void)cancel:(id)sender
{
    // If the user cancelled, then remove the BNRItem from the store
    [[BNRItemStore sharedStore] removeItem:item];
    // Then dismiss the view controller
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:dismissBlock];
}

- (BOOL)disablesAutomaticKeyboardDismissal
{
    return NO;
}

@end




















