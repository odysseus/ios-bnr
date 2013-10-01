//
//  BNRItem.h
//  HomePwner
//
//  Created by Ryan Case on 9/29/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface BNRItem : NSManagedObject

@property (nonatomic, retain) NSString *itemName;
@property (nonatomic, retain) NSString *serialNumber;
@property (nonatomic) int32_t valueInDollars;
@property (nonatomic, retain) NSString *imageKey;
@property (nonatomic) NSTimeInterval dateCreated;
@property (nonatomic, retain) NSData *thumbnailData;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic) double orderingValue;
@property (nonatomic, retain) NSManagedObject *assetType;

- (void)setThumbnailDataFromImage:(UIImage *)image;

@end
