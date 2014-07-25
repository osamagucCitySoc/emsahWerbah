//
//  FollowersExchangePurchase.m
//  twitterExampleIII
//
//  Created by ousamaMacBook on 6/19/13.
//  Copyright (c) 2013 MacBook. All rights reserved.
//

#import "FollowersExchangePurchase.h"

@implementation FollowersExchangePurchase


+ (FollowersExchangePurchase *)sharedInstance {
    static dispatch_once_t once;
    static FollowersExchangePurchase * sharedInstance;

    dispatch_once(&once, ^{
        NSMutableSet * productIdentifiers;
        productIdentifiers = [NSMutableSet setWithObjects:
                              @"arabdevs.emsahWerbah.6",
                              @"arabdevs.emsahWerbah.6s",
                              @"arabdevs.emsahWerbah.70player",
                              @"arabdevs.emsahWerbah.50player",
                              @"arabdevs.emsahWerbah.70land",
                              @"arabdevs.emsahWerbah.50land",
                              nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}



@end
