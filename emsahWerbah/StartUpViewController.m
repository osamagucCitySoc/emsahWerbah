//
//  StartUpViewController.m
//  emsahWerbah
//
//  Created by Housein Jouhar on 5/24/14.
//  Copyright (c) 2014 OsamaMac. All rights reserved.
//

#import "StartUpViewController.h"

@interface StartUpViewController ()

@end

@implementation StartUpViewController

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
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"ads"]isEqualToString:@"1"])
    {
    interstitial_ = [[GADInterstitial alloc] init];
    interstitial_.adUnitID = @"ca-app-pub-2433238124854818/4683057194";
    [interstitial_ setDelegate:self];
    [interstitial_ loadRequest:[GADRequest request]];
    }
    
    store = [UICKeyChainStore keyChainStore];
    dataSource = [[NSArray alloc]initWithObjects:@"Players",@"Flags",@"Land-Marks",@"Brand-Marks", nil];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:184.0/255 green:46.0/255 blue:63.0/255 alpha:1.0]];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    NSString *played;
    
    for (int i = 0; i < 4; i++)
    {
        NSArray* solved = [[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",[dataSource objectAtIndex:i],@"SOLVED"]] componentsSeparatedByString:@"##"];
        
        played = [NSString stringWithFormat:@"%i",(solved.count-1)];

        if(!played || [played length] <= 0)
        {
            played = @"0";
        }
        
        played = [played stringByAppendingString:@"/25"];
        
        if (i == 0)
        {
            _playersLabel.text = played;
        }
        else if (i == 1)
        {
            _flagsLabel.text = played;
        }
        else if (i == 2)
        {
            _landMarksLabel.text = played;
        }
        else
        {
            _brandMarksLabel.text = played;
        }
    }
    
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productCanceled:) name:IAPHelperProductFailedNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)openLandMarks:(id)sender {
    [[NSUserDefaults standardUserDefaults]setObject:[dataSource objectAtIndex:2] forKey:@"path"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self performSegueWithIdentifier:@"playSeg" sender:self];
}

- (IBAction)openPlayers:(id)sender {
    [[NSUserDefaults standardUserDefaults]setObject:[dataSource objectAtIndex:0] forKey:@"path"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self performSegueWithIdentifier:@"playSeg" sender:self];
}

- (IBAction)openFlags:(id)sender {
    [[NSUserDefaults standardUserDefaults]setObject:[dataSource objectAtIndex:1] forKey:@"path"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self performSegueWithIdentifier:@"playSeg" sender:self];
}

- (IBAction)openBrandMarks:(id)sender {
    [[NSUserDefaults standardUserDefaults]setObject:[dataSource objectAtIndex:3] forKey:@"path"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self performSegueWithIdentifier:@"playSeg" sender:self];
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


#pragma mark int delegate
-(void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    NSLog(@"%@",[error debugDescription]);
}
-(void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    [interstitial_ presentFromRootViewController:self];
}

@end
