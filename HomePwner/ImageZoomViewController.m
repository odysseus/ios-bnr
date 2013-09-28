//
//  ImageZoomViewController.m
//  HomePwner
//
//  Created by Ryan Case on 9/27/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "ImageZoomViewController.h"

@interface ImageZoomViewController ()

@end

@implementation ImageZoomViewController

@synthesize image;

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [imageView setImage:[self image]];
    [self.view addSubview:scrollView];
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
