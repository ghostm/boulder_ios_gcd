//
//  GCDAccount.m
//  GCD_Intro
//
//  Created by Matthew Henderson on 10/20/12.
//  Copyright (c) 2012 Matthew Henderson. All rights reserved.
//

#import "GCDAccount.h"
#import "GCDTransaction.h"

@implementation GCDAccount
-(id)initWithName:(NSString*)name andStartingBalance:(NSInteger)balance{
    self = [super init];
    if (self) {
        self.name = name;
        self.balance = balance;
        NSString* queueName = [NSString stringWithFormat:@"com.gcdintro.%@", self.name];
        self.queue = dispatch_queue_create([queueName UTF8String], DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

-(BOOL)processTransaction:(GCDTransaction*)transaction{
    __block BOOL canDebitAccount = NO;
    dispatch_sync(self.queue, ^{
        if (transaction.amount > self.balance) return;
        self.balance -= transaction.amount;
        canDebitAccount = YES;
    });
    return canDebitAccount;
}


@end
