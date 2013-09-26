//
//  HomePwnerItemCell.m
//  HomePwner
//
//  Created by Ryan Case on 9/24/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "HomePwnerItemCell.h"

@implementation HomePwnerItemCell

@synthesize nameLabel, valueLabel, thumbnailView, serialLabel, controller, tableView;

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
    // Get the name of this method
    NSString *selector = NSStringFromSelector(_cmd);
    // Append "atIndexPath:"
    selector = [selector stringByAppendingString:@"atIndexPath:"];
    // String is now "showImage:atIndexPath:"
    // Make a new selector from this string
    SEL newSelector = NSSelectorFromString(selector);
    // Fetch the index path for this cell
    NSIndexPath *indexPath = [[self tableView] indexPathForCell:self];
    // Verify that the index path and selector exist
    if (indexPath) {
        if ([[self controller] respondsToSelector:newSelector]) {
            // Send the message to the controller
            [[self controller] performSelector:newSelector
                                    withObject:sender
                                    withObject:indexPath];
        }
    }
}
@end
