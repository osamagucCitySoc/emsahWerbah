//
//  AppDelegate.m
//  emsahWerbah
//
//  Created by OsamaMac on 5/1/14.
//  Copyright (c) 2014 OsamaMac. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    [FollowersExchangePurchase sharedInstance];
    
    [Parse setApplicationId:@"t2G3HhGYtMEFe3PPFgit5nvoRHLUi2AUV4Arvira"
                  clientKey:@"OgCadknxeo23hzuZzzNhrWzrbr3sCjwUZXUxjRba"];
    
    NSString *post = @"";
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[post length]];
    
    NSURL *url = [NSURL URLWithString:@"http://osamalogician.com/arabDevs/emsahWerbah/getAds.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:90.0];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:postData];
    
    NSURLResponse* response;
    NSError* error = nil;
    
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    [[NSUserDefaults standardUserDefaults]setObject:[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding] forKey:@"ads"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    @try {
        if([store stringForKey:@"hints"] == nil)
        {
            [store setString:@"0" forKey:@"hints"];
            [store synchronize];
        }
        
        if([store stringForKey:@"secs"] == nil)
        {
            [store setString:@"0" forKey:@"secs"];
            [store synchronize];
        }
        
        if([store stringForKey:@"giffft"] == nil)
        {
            [store setString:@"3" forKey:@"secs"];
            [store setString:@"3" forKey:@"giffft"];
            [store synchronize];
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"مبروك" message:@"بمناسبة التحميل أعطينا لك ٣ ثواني تستخدمهم في مسح الصور هدية" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    @catch (NSException *exception) {}
    @finally {}
    
    
    
    
    
    NSArray* dataSource = [[NSArray alloc]initWithObjects:@"Players",@"Flags",@"Land-Marks",@"Brand-Marks", nil];
    
    for (int i = 0; i < 4; i++)
    {
        NSArray* solved = [[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",[dataSource objectAtIndex:i],@"SOLVED"]] componentsSeparatedByString:@"##"];
        if(solved == nil)
        {
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:[NSString stringWithFormat:@"%@%@",[dataSource objectAtIndex:i],@"SOLVED"]];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    }
    
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"blurplayer"] == nil)
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"blurplayer"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"blurplayerrem"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"blurlandmark"] == nil)
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"blurlandmark"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"blurlandmarkrem"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
}


@end
