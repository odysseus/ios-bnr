//
//  BNRItemStore.h
//  HomePwner
//
//  Created by Ryan Case on 9/19/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BNRItem;

@interface BNRItemStore : NSObject
{
    NSMutableArray *allItems;
    NSMutableArray *allAssetTypes;
    NSManagedObjectContext *context;
    NSManagedObjectModel *model;
}

+ (BNRItemStore *)sharedStore;

- (NSArray *)allItems;
- (BNRItem *)createItem;
- (void)removeItem:(BNRItem *)item;
- (void)moveItemAtIndex:(int)from toIndex:(int)to;
- (NSString *)itemArchivePath;
- (BOOL)saveChanges;
- (void)loadAllItems;
- (NSArray *)allAssetTypes;
- (void)addNewAssetTypeWithType:(NSString *)typeString;

@end
