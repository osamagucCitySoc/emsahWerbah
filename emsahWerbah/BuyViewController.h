//
//  BuyViewController.h
//  emsahWerbah
//
//  Created by Housein Jouhar on 5/24/14.
//  Copyright (c) 2014 OsamaMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "followersExchangePurchase.h"
#import "UICKeyChainStore.h"

@interface BuyViewController : UIViewController
{
    UICKeyChainStore *store;
}

@property (strong, nonatomic) NSArray* products;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@end
