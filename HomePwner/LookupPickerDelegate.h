//
//  LookupProtocol.h
//  HomePwner
//
//  Created by Ryan Case on 10/2/13.
//  Copyright (c) 2013 Ryan Case. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LookupPickerDelegate <NSObject>

- (void)didChangeSelection:(NSObject*)id;

@end
