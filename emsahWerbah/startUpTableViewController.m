//
//  startUpTableViewController.m
//  emsahWerbah
//
//  Created by OsamaMac on 5/8/14.
//  Copyright (c) 2014 OsamaMac. All rights reserved.
//

#import "startUpTableViewController.h"

@interface startUpTableViewController ()

@end

@implementation startUpTableViewController

@synthesize products;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    dataSource = [[NSArray alloc]initWithObjects:@"Players",@"Flags",@"Land-Marks",@"Brand-Marks", nil];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
    {
        [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:184.0/255 green:46.0/255 blue:63.0/255 alpha:1.0]];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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


- (IBAction)buyNow:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"شراء:" delegate:self cancelButtonTitle:@"إلغاء" destructiveButtonTitle:nil otherButtonTitles:@"باقة المساعدات",@"باقة مسح الصور",nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex  {
  
    if(buttonIndex == 0)
    {
        SKProduct *product = products[0];
        [[FollowersExchangePurchase sharedInstance] buyProduct:product];
    }else if(buttonIndex == 1)
    {
        SKProduct *product = products[1];
        [[FollowersExchangePurchase sharedInstance] buyProduct:product];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"categoryCell" forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"categoryCell"];
    }
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"لاعبين كرة قدم";
    }
    else if (indexPath.row == 1)
    {
        cell.textLabel.text = @"أعلام بلدان";
    }
    else if (indexPath.row == 2)
    {
        cell.textLabel.text = @"معالم شهيرة";
    }
    else if (indexPath.row == 3)
    {
        cell.textLabel.text = @"شعارات تجارية";
    }
    
    NSString* played = [[NSUserDefaults standardUserDefaults]objectForKey:[dataSource objectAtIndex:indexPath.row]];
    if(!played || [played length] <= 0)
    {
        played = @"0";
    }

    played = [played stringByAppendingString:@"/25"];
    
    [[cell detailTextLabel]setText:played];
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults]setObject:[dataSource objectAtIndex:indexPath.row] forKey:@"path"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [self performSegueWithIdentifier:@"playSeg" sender:self];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


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
