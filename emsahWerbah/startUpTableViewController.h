//
//  startUpTableViewController.h
//  emsahWerbah
//
//  Created by OsamaMac on 5/8/14.
//  Copyright (c) 2014 OsamaMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "followersExchangePurchase.h"
#import "UICKeyChainStore.h"

@interface startUpTableViewController : UITableViewController <UIActionSheetDelegate>
{
    NSArray* dataSource;
    UICKeyChainStore *store;
}

@property (strong, nonatomic) NSArray* products;

@end
