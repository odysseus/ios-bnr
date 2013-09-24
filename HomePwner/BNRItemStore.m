//
//  BNRItemStore.m
//  HomePwner
//
//  Created by Ryan Case on 9/19/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"
#import "BNRImageStore.h"

@implementation BNRItemStore

+ (BNRItemStore *)sharedStore;
{
    static BNRItemStore *sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    return sharedStore;
}

+ (id)allocWithZone:(NSZone *)zone;
{
    return [self sharedStore];
}

- (id)init
{
    self = [super init];
    if (self) {
        NSString *path = [self itemArchivePath];
        allItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        
        // If the array hadn't been saved previously, create a new empty one
        if (!allItems)
            allItems = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)allItems
{
    return allItems;
}

- (BNRItem *)createItem
{
    BNRItem *p = [[BNRItem alloc] init];
    [allItems addObject:p];
    return p;
}

- (void)removeItem:(BNRItem *)item;
{
    [[BNRImageStore sharedStore] deleteImageForKey:[item imageKey]];
    [allItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(int)from toIndex:(int)to;
{
    if (from == to) {
        return;
    }
    // First get pointed to object being moved so we can move it
    BNRItem *p = [allItems objectAtIndex:from];
    
    // Remove p from the array
    [allItems removeObjectAtIndex:from];
    
    // Then move it to a new position
    [allItems insertObject:p atIndex:to];
}

// Constructs a path to a file where BNRItems can be saved
- (NSString *)itemArchivePath;
{
    NSArray *documentDirectories =
    NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                        NSUserDomainMask, YES);
    
    // Get one and only document directory from that list
    // There is only one, despite being in a array, because the function is shared
    // with OSX, where there might be multiple matching directories, on iOS there
    // will only be one, like a singleton, or a highlander
    NSString *documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"items.archive"];
}

// Save all items in the BNRItemStore, which will save new items and changes to old
// ones all in one fell swoop
- (BOOL)saveChanges
{
    // returns success or failure
    NSString *path = [self itemArchivePath];
    
    return [NSKeyedArchiver archiveRootObject:allItems
                                       toFile:path];
}

@end














