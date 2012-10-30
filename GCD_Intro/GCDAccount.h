//
//  GCDAccount.h
//  GCD_Intro
//
//  Created by Matthew Henderson on 10/20/12.
//  Copyright (c) 2012 Matthew Henderson. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GCDTransaction;
@interface GCDAccount : NSObject
@property (nonatomic, strong) NSString* name;
@property (strong) dispatch_queue_t queue;
@property (assign) NSInteger balance;

-(id)initWithName:(NSString*)name andStartingBalance:(NSInteger)balance;
-(BOOL)processTransaction:(GCDTransaction*)transaction;

@end
