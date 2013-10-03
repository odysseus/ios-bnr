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
        // Read in Homepwner.xcdatamodeld
        // passing nil means the main bundle is searched
        model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *psc =
        [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        
        // Give the SQLite file a location to save and a URL to access it
        NSURL *storeURL = [NSURL fileURLWithPath:[self itemArchivePath]];
        
        NSError *error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:storeURL
                                     options:nil
                                       error:&error]) {
            // If the method fails, raise an exception
            [NSException raise:@"Open failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        // Create the managed object context
        context = [[NSManagedObjectContext alloc] init];
        [context setPersistentStoreCoordinator:psc];
        
        // The managed object context can manage undo, but we don't need it
        [context setUndoManager:nil];
        
        // Run the loadAllItems method to load the database
        [self loadAllItems];
    }
    return self;
}

// Fethes all the BNRItems, in an application with much more data, fetching everything
// is poor practice, instead you should selectively fetch data by passing an
// NSPredicate argument with the fetch request
- (void)loadAllItems
{
    // If it doesn't exist
    if (!allItems) {
        
        // Prep an NSFetchRequest to fetch the data
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        // You have to specify the entity (table) within the model to be returned
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"BNRItem"];
        [request setEntity:e];
        
        // NSSortDescriptor predictably specifies how it will be sorted
        NSSortDescriptor *sd = [NSSortDescriptor
                                sortDescriptorWithKey:@"orderingValue"
                                ascending:YES];
        [request setSortDescriptors:[NSArray arrayWithObject:sd]];
        
        // Get result if successful, raise error if not
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        
        // allItems is an NSMutableArray, whereas the value returned above is
        // an NSArray, so it has to be converted for assignment
        allItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

- (NSArray *)allItems
{
    return allItems;
}

- (BNRItem *)createItem
{
    double order;
    if ([allItems count] == 0) {
        order = 1.0;
    } else {
        order = [[allItems lastObject] orderingValue] + 1.0;
    }
    NSLog(@"Adding after %d items, order = %.2f", [allItems count], order);
    
    BNRItem *p = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem"
                                               inManagedObjectContext:context];
    
    [p setOrderingValue:order];
    
    [allItems addObject:p];
    return p;
}

- (void)removeItem:(BNRItem *)item;
{
    [[BNRImageStore sharedStore] deleteImageForKey:[item imageKey]];
    [context deleteObject:item];
    [allItems removeObjectIdenticalTo:item];
}

- (void)moveItemAtIndex:(int)from toIndex:(int)to
{
    if (from == to) {
        return;
    }
    BNRItem *p = [allItems objectAtIndex:from];
    
    [allItems removeObjectAtIndex:from];
    
    [allItems insertObject:p atIndex:to];
    
    // Computing a new orderValue for the object that was moved
    double lowerBound = 0.0;
    
    // Is there an object before it in the array?
    if (to > 0) {
        lowerBound = [[allItems objectAtIndex:to - 1] orderingValue];
    } else {
        lowerBound = [[allItems objectAtIndex:1] orderingValue] - 2.0;
    }
    
    double upperBound = 0.0;
    
    // Is there an object after it in the array?
    if (to < [allItems count] - 1) {
        upperBound = [[allItems objectAtIndex:to + 1] orderingValue];
    } else {
        upperBound = [[allItems objectAtIndex:to - 1] orderingValue] + 2.0;
    }
    
    double newOrderValue = (lowerBound + upperBound) / 2.0;
    
    NSLog(@"moving to order %f", newOrderValue);
    [p setOrderingValue:newOrderValue];
    
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
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

// Save all items in the BNRItemStore, which will save new items and changes to old
// ones all in one fell swoop
- (BOOL)saveChanges
{
    NSError *err = nil;
    BOOL successful = [context save:&err];
    if (!successful) {
        NSLog(@"Error saving: %@", [err localizedDescription]);
    }
    return successful;
}

- (NSArray *)allAssetTypes
{
    if (!allAssetTypes) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [[model entitiesByName]
                                  objectForKey:@"BNRAssetType"];
        
        [request setEntity:e];
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed"
                        format:@"Reason: %@", [error localizedDescription]];
        }
        allAssetTypes = [result mutableCopy];
    }
    
    // Is this the first time the program is being run?
    if ([allAssetTypes count] == 0) {
        NSManagedObject *type;
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                             inManagedObjectContext:context];
        [type setValue:@"Furniture" forKey:@"label"];
        [allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                             inManagedObjectContext:context];
        [type setValue:@"Jewelry" forKey:@"label"];
        [allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                             inManagedObjectContext:context];
        [type setValue:@"Electronics" forKey:@"label"];
        [allAssetTypes addObject:type];
        
    }
    return allAssetTypes;
}

- (void)addNewAssetTypeWithType:(NSString *)typeString
{
    if (!allAssetTypes)
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"BNRAssetType"];
        
        [request setEntity:e];
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        if (!result)
        {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        allAssetTypes = [result mutableCopy];
    }
    
    NSManagedObject *type;
    type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                         inManagedObjectContext:context];
    [type setValue:typeString forKey:@"label"];
    [allAssetTypes addObject:type];
}

@end














