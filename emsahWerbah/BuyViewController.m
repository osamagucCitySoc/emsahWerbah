//
//  BuyViewController.m
//  emsahWerbah
//
//  Created by Housein Jouhar on 5/24/14.
//  Copyright (c) 2014 OsamaMac. All rights reserved.
//

#import "BuyViewController.h"

@interface BuyViewController ()

@end

@implementation BuyViewController

@synthesize products;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self reload];
    store = [UICKeyChainStore keyChainStore];
    
    _scrollView.contentSize = CGSizeMake(320, 504);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buyPhoto:(id)sender {
    SKProduct *product = products[1];
    [[FollowersExchangePurchase sharedInstance] buyProduct:product];
}

- (IBAction)buyHelp:(id)sender {
    SKProduct *product = products[0];
    [[FollowersExchangePurchase sharedInstance] buyProduct:product];
}

#pragma mark buying
- (void)productPurchased:(NSNotification *)notification {
    NSString * productIdentifier = notification.object;
    [products enumerateObjectsUsingBlock:^(SKProduct * product, NSUInteger idx, BOOL *stop) {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"تم الشراء" message:@"تم الشراء شكرا لك." delegate:nil cancelButtonTitle:@"موافق" otherButtonTitles:nil];
        if ([product.productIdentifier isEqualToString:productIdentifier]) {
            if ([product.productIdentifier isEqualToString:productIdentifier]) {
                if([productIdentifier isEqualToString:@"arabdevs.emsahWerbah.6"])
                {
                    int hints = [[store stringForKey:@"hints"]intValue];
                    hints += 6;
                    [store setString:[NSString stringWithFormat:@"%i",hints] forKey:@"hints"];
                    [store synchronize];
                    [alert show];
                }else if([productIdentifier isEqualToString:@"arabdevs.emsahWerbah.6s"])
                {
                    float hints = [[store stringForKey:@"secs"]floatValue];
                    hints += 3.00;
                    [store setString:[NSString stringWithFormat:@"%0.2f",hints] forKey:@"secs"];
                    [store synchronize];
                    [alert show];
                }
                *stop = YES;
            }
        }
    }];
}

- (void)reload {
    products = nil;
    [[FollowersExchangePurchase sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *productss) {
        if (success) {
            products = productss;
        }
    }];
}

- (void)productCanceled:(NSNotification *)notification {
    isRealBuy = NO;
}


@end
