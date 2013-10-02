//
//  DetailViewController.h
//  HomePwner
//
//  Created by Ryan Case on 9/21/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LookupPickerDelegate.h"

@class BNRItem;

@interface DetailViewController : UIViewController
    <UITextFieldDelegate, UINavigationControllerDelegate,
    UIImagePickerControllerDelegate, UIPopoverControllerDelegate,
    LookupPickerDelegate>
{
    __weak IBOutlet UITextField *serialField;
    __weak IBOutlet UITextField *valueField;
    __weak IBOutlet UITextField *nameField;
    __weak IBOutlet UILabel *dateLabel;
    __weak IBOutlet UIButton *imageView;
    __weak IBOutlet UIButton *assetTypeButton;
    
    UIPopoverController *imagePickerPopover;
    UIPopoverController *assetTypePickerPopover;
}

@property (nonatomic, strong) BNRItem *item;
@property (nonatomic, copy) void (^dismissBlock)(void);

- (IBAction)changeDate:(id)sender;
- (IBAction)takePicture:(id)sender;
- (IBAction)backgroundTapped:(id)sender;
- (IBAction)removeImage:(id)sender;
- (IBAction)showZoomedPicture:(id)sender;
- (id)initForNewItem:(BOOL)isNew;
- (IBAction)showAssetTypePicker:(id)sender;

@end
