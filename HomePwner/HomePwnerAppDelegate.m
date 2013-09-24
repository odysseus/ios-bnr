//
//  HomePwnerAppDelegate.m
//  HomePwner
//
//  Created by Ryan Case on 9/19/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "HomePwnerAppDelegate.h"
#import "ItemsViewController.h"
#import "BNRItemStore.h"

@implementation HomePwnerAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    ItemsViewController *itemsViewController = [[ItemsViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc]
                                             initWithRootViewController:itemsViewController];
    
    // Root View Controller
    [[self window] setRootViewController:navController];
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    BOOL success = [[BNRItemStore sharedStore] saveChanges];
    if (success) {
        NSLog(@"Saved all of the BNRItems");
    } else {
        NSLog(@"Could not save any of the BNRItems");
    }
}

@end
