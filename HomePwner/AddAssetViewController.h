//
//  AddAssetViewController.h
//  HomePwner
//
//  Created by Ryan Case on 10/2/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAssetViewController : UIViewController
{
    __weak IBOutlet UITextField *newAssetType;
}

- (IBAction)submitAssetType:(id)sender;

@end
