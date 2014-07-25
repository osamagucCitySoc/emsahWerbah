//
//  StartUpViewController.h
//  emsahWerbah
//
//  Created by Housein Jouhar on 5/24/14.
//  Copyright (c) 2014 OsamaMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "followersExchangePurchase.h"
#import "UICKeyChainStore.h"
#import "GADInterstitial.h"

@interface StartUpViewController : UIViewController<GADInterstitialDelegate>
{
    NSArray* dataSource;
    UICKeyChainStore *store;
    GADInterstitial *interstitial_;
}

@property (strong, nonatomic) NSArray* products;
@property (strong, nonatomic) IBOutlet UILabel *landMarksLabel;
@property (strong, nonatomic) IBOutlet UILabel *playersLabel;
@property (strong, nonatomic) IBOutlet UILabel *flagsLabel;
@property (strong, nonatomic) IBOutlet UILabel *brandMarksLabel;


@end
