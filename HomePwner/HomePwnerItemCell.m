//
//  HomePwnerItemCell.m
//  HomePwner
//
//  Created by Ryan Case on 9/24/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "HomePwnerItemCell.h"

@implementation HomePwnerItemCell

@synthesize nameLabel, valueLabel, thumbnailView, serialLabel, tableView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// Linking with the controller to display a larger version of the thumbnail
// Also an example of working with selector methods
- (IBAction)showImage:(id)sender
{
    // This method is intentionally messy to show three different ways of processing
    // the button press through the controller.
    
    // Option 1: Import the controller up top and process the button press normally by
    // calling [self controller] and then passing in the method and arguments
    
//    [[self controller] showImage:sender atIndexPath:[[self tableView] indexPathForCell:self]];
    
    // Option 2: Using various selector manipulation methods, construct a string with the selector
    // name, convert it, and pass it to the controller directly, without importing the header file.
    // This allows greater flexibility with the code (Not tied to a controller class) at the expense
    // of being more error prone, because the compiler can't ensure everything is copasetic.
    
//    // Get the name of this method
//    NSString *selector = NSStringFromSelector(_cmd);
//    // Append "atIndexPath:"
//    selector = [selector stringByAppendingString:@"atIndexPath:"];
//    // String is now "showImage:atIndexPath:"
//    // Make a new selector from this string
//    SEL newSelector = NSSelectorFromString(selector);
//    NSLog(@"%@", selector);
//    // Fetch the index path for this cell
//    NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
//    // Verify that the index path and selector exist
//    if (indexPath) {
//        if ([[self controller] respondsToSelector:newSelector]) {
//            // Send the message to the controller
//            [[self controller] performSelector:newSelector
//                                    withObject:sender
//                                    withObject:indexPath];
//        }
//    }
    
    // Option 3: Use the inherited methods from the BaseCell class to send a message to the
    // controller by passing a sting for the selector. The process here is almost identical
    // to the performSelector method, but the functionality is built into the class, and it
    // doesn't generate a memory warning. To be honest approach #2 and #3 seem like solutions
    // in search of a real problem, but maybe in larger apps the controller passing
    // functionality is more useful

    // Generate the selector string
    NSString *selector = NSStringFromSelector(_cmd);
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    // Get the index path
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
    // Create an array of the arguments
    NSArray *args = [NSArray arrayWithObjects: sender, indexPath, nil];
    [self sendSelectorToController:selector withParams:args];
}

@end




















