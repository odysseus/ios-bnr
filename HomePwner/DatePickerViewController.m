//
//  DatePickerViewController.m
//  HomePwner
//
//  Created by Ryan Case on 9/21/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "DatePickerViewController.h"
#import "BNRItem.h"
#import "DetailViewController.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController

@synthesize dateItem;

// EXTRA wanted to display the current date that is associated with BNRItem passed
- (void)viewWillAppear:(BOOL)animated
{
    // Create a NSDateFormatter that will turn a date into a simple date string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    // Use filtered NSDate object to set dateLabel Contents
    // Convert time interval to NSDate
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:[dateItem dateCreated]];
    [dateLabel setText:[dateFormatter stringFromDate:date]];
}

// Save Date selected
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // Get the picker date and save it
    NSTimeInterval date = [[datePicker date] timeIntervalSinceReferenceDate];
    [dateItem setDateCreated:date];
}

@end
