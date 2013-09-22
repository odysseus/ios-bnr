//
//  BNRItem.h
//  RandomPossessions
//
//  Created by Ryan Case on 9/13/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRItem : NSObject

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, strong) NSDate *dateCreated;
@property (nonatomic, weak) BNRItem *container;
@property (nonatomic, strong) BNRItem *containedItem;
@property (nonatomic, copy) NSString *imageKey;

// Setters and Getters that override the synthesized methods
- (void)setContainedItem:(BNRItem *)i;
- (void)dealloc;
- (id)init;
- (id)initWithItemName:(NSString *)name
        valueInDollars:(int)value
          serialNumber:(NSString *)serial;
- (id)initWithItemName:(NSString *)name
          serialNumber:(NSString *)serial;

+ (id)randomItem;

@end
