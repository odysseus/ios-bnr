//
//  ImageViewController.m
//  HomePwner
//
//  Created by Ryan Case on 9/26/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@end

@implementation ImageViewController

@synthesize image;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGSize sz = [[self image] size];
    [scrollView setContentSize:sz];
    [imageView setFrame:CGRectMake(0, 0, sz.width, sz.height)];
    [imageView setImage:[self image]];
}

@end
