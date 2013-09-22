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

@interface DetailViewController ()

@end

@implementation DetailViewController

@synthesize item;

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
    
    NSString *imageKey = [item imageKey];
    
    if (imageKey) {
        // Get image for image key from image store
        UIImage *imageToDisplay =
        [[BNRImageStore sharedStore] imageForKey:imageKey];
        
        // Use that image to put on the screen in imageView
        [imageView setImage:imageToDisplay];
    } else {
        // Clear the imageView
        [imageView setImage:nil];
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
//    [imagePicker setAllowsEditing:YES];
    
    // Place image picker on the screen
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (IBAction)backgroundTapped:(id)sender
{
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
        [imageView setImage:nil];
        [imageView setNeedsDisplay];
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
    [imageView setImage:image];
    
    // Dismiss the image picker
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end




















