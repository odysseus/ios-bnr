//
//  DatePickerViewController.h
//  HomePwner
//
//  Created by Ryan Case on 9/21/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BNRItem;

@interface DatePickerViewController : UIViewController
{
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIDatePicker *myPicker;
}

// This is where we set the passed item from DetailViewController.m
@property (nonatomic, strong) BNRItem *dateItem;

@end
