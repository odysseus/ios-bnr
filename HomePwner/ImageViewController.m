//
//  ImageViewController.m
//  HomePwner
//
//  Created by Ryan Case on 9/26/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "ImageViewController.h"

@implementation ImageViewController
@synthesize image;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [imageView setImage:[self image]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    scrollView.minimumZoomScale = 1.0;
    scrollView.maximumZoomScale = 6.0;
    scrollView.delegate = self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

@end
