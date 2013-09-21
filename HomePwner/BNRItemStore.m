//
//  BNRItemStore.m
//  HomePwner
//
//  Created by Ryan Case on 9/19/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"

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
    BNRItem *p = [BNRItem randomItem];
    [allItems addObject:p];
    return p;
}

- (void)removeItem:(BNRItem *)item;
{
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

@end














