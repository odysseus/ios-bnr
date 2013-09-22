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

@end




















