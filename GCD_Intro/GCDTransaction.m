//
//  GCDTransaction.m
//  GCD_Intro
//
//  Created by Matthew Henderson on 10/20/12.
//  Copyright (c) 2012 Matthew Henderson. All rights reserved.
//

#import "GCDTransaction.h"

@implementation GCDTransaction
-(void)determineTransactionAmount{
    int sum = 0;
    for (int i=0; i<100000; i++) {
        sum += arc4random() % 2;
    }
    if (sum > 5000) {
        self.amount = arc4random() % 9;
    }else{
        self.amount = arc4random() % 11;
    }
}
@end
