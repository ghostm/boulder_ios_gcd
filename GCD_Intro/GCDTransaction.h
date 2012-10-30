//
//  GCDTransaction.h
//  GCD_Intro
//
//  Created by Matthew Henderson on 10/20/12.
//  Copyright (c) 2012 Matthew Henderson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GCDTransaction : NSObject
@property (assign) NSInteger amount;

//slow process
-(void)determineTransactionAmount;
@end
