//
//  ViewController.m
//  emsahWerbah
//
//  Created by OsamaMac on 5/1/14.
//  Copyright (c) 2014 OsamaMac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize imageView,products,circle,timerLabel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) { // if iOS 7
        // self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    blurAddingString = @"";
    
    bannerView_2 = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    bannerView_2.adUnitID = @"ca-app-pub-2433238124854818/9113256795";
    bannerView_2.rootViewController = self;
    [self.bannerView addSubview:bannerView_2];
    
    // Initiate a generic request to load it with an ad.
    
    [bannerView_2 loadRequest:[GADRequest request]];
    
    
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"ads"]isEqualToString:@"1"])
    {
        
        bannerView_ = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
        bannerView_.adUnitID = @"ca-app-pub-2433238124854818/9113256795";
        bannerView_.rootViewController = self;
        [bannerView_ loadRequest:[GADRequest request]];
        [self.view addSubview:bannerView_];
    }
    remain = [[NSMutableArray alloc]init];
    for(int i = 1 ; i <= 25 ; i++)
    {
        [remain addObject:[NSString stringWithFormat:@"%i",i]];
    }
    
    NSArray* solved = [[[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"path" ],@"SOLVED"]] componentsSeparatedByString:@"##"];
    
    
    
    [remain removeObjectsInArray:solved];
    
    store = [UICKeyChainStore keyChainStore];
    
    gift = NO;
    [self initUI];
    [self reload];
    
    if ([[UIScreen mainScreen] bounds].size.height < 490)
    {
        [_emsahButton setHidden:YES];
        [_solutionButton setHidden:YES];
        [_optionsButton setHidden:NO];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:IAPHelperProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productCanceled:) name:IAPHelperProductFailedNotification object:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)return;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"giftt"];
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"mask"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)return;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (IBAction)openOptions:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"خيارات" delegate:self cancelButtonTitle:@"إلغاء" destructiveButtonTitle:nil otherButtonTitles:@"عرفت الحل",@"امسح واكتشف",@"Reset",nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [actionSheet setTag:2];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark INITING THE UI depending on the gift or not
-(void)initUI
{
    //timerLabel.alpha = 0.0f;
    
    timerLabel.text = [@"عدد الثواني المتبقي لديك: " stringByAppendingString:[store stringForKey:@"secs"]];
    circle.alpha = 0.0f;
    circle.color = [UIColor whiteColor];
    
    if(!gift)
    {
        currentPath = [[NSUserDefaults standardUserDefaults]objectForKey:@"path"];
        currentImage = @"0";
        if([remain count] == 0)
        {
            remain = [[NSMutableArray alloc]init];
            for(int i = 1 ; i <= 25 ; i++)
            {
                [remain addObject:[NSString stringWithFormat:@"%i",i]];
            }
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:currentPath];
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"path"],@"SOLVED"]];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }else
        {
            int r = arc4random() % remain.count;
            if(r >= remain.count)
                r = remain.count-1;
            currentImage = [remain objectAtIndex:r];
        }
        
        NSError *error = nil;
        NSString *fullPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@%@",currentPath,currentImage] ofType:@"txt"];
        info = [[NSString stringWithContentsOfFile:fullPath encoding:NSUTF8StringEncoding error:&error] componentsSeparatedByString:@"\n"];
        
        currentDisplayedInfo = 0;
        
        [self.hinstAvLabel setText:[@"عدد المساعدات المتبقية لديك: " stringByAppendingString:[store stringForKey:@"hints"]]];
        
        [self.secondsAvLabel setText:[store stringForKey:@"secs"]];
        
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"mask"];
        
        
        if([[[NSUserDefaults standardUserDefaults]objectForKey:@"path"]isEqualToString:@"Players"])
        {
            blurAddingString = [[NSUserDefaults standardUserDefaults] objectForKey:@"blurplayer"];
            if(![blurAddingString isEqualToString:@""])
            {
                int rem = [[[NSUserDefaults standardUserDefaults] objectForKey:@"blurplayerrem"] intValue];
                if(rem < 1)
                {
                    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"blurplayerrem"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    blurAddingString = @"";
                }
            }
        }else if([[[NSUserDefaults standardUserDefaults]objectForKey:@"path"]isEqualToString:@"Land-Marks"])
        {
            blurAddingString = [[NSUserDefaults standardUserDefaults] objectForKey:@"blurlandmark"];
            if(![blurAddingString isEqualToString:@""])
            {
                int rem = [[[NSUserDefaults standardUserDefaults] objectForKey:@"blurlandmarkrem"] intValue];
                if(rem < 1)
                {
                    [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"blurlandmarkrem"];
                    [[NSUserDefaults standardUserDefaults]synchronize];
                    blurAddingString = @"";
                }
            }
        }
        
        
        NSArray *imagesDicts = @[ @{@"sharp" : [NSString stringWithFormat:@"%@%@.jpg",currentPath,currentImage], @"blured" : [NSString stringWithFormat:@"%@%@-blur%@.jpg",currentPath,currentImage,blurAddingString]}];
        
        for (NSDictionary *dictionary in imagesDicts) {
            UIImage *sharpImage = [UIImage imageNamed:[dictionary objectForKey:@"sharp"]];
            [imageView setImage:sharpImage];
            UIImage *bluredImage = [UIImage imageNamed:[dictionary objectForKey:@"blured"]];
            NSString *radiusString = [dictionary objectForKey:@"radius"];
            scratchImageView = [[MDScratchImageView alloc] initWithFrame:imageView.frame];
            scratchImageView.delegate = self;
            if (nil == radiusString) {
                scratchImageView.image = bluredImage;
            } else {
                [scratchImageView setImage:bluredImage radius:[radiusString intValue]];
                scratchImageView.image = bluredImage;
            }
            [self.view addSubview:scratchImageView];
            [scratchImageView setUserInteractionEnabled:NO];
        }
        
        [self.view bringSubviewToFront:timerLabel];
        [self.view bringSubviewToFront:circle];
    }else
    {
        
        
        NSString *post = @"";
        NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[post length]];
        
        
        NSURL *url = [NSURL URLWithString:@"http://osamalogician.com/arabDevs/autoTweet/getCodes.php"];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:90.0];
        [request setHTTPMethod:@"POST"];
        
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody:postData];
        
        connection = [[NSURLConnection alloc]initWithRequest:request delegate:self    startImmediately:NO];
        
        [connection scheduleInRunLoop:[NSRunLoop mainRunLoop]
                              forMode:NSDefaultRunLoopMode];
        [connection start];
        
        [self.emsahButton setAlpha:0.0f];
        [self.optionsButton setAlpha:0.0f];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MDScratchImageViewDelegate

- (void)mdScratchImageView:(MDScratchImageView *)scratchImageVieww didChangeMaskingProgress:(CGFloat)maskingProgress {
	NSLog(@"%s %p progress == %.2f", __PRETTY_FUNCTION__, scratchImageVieww, maskingProgress);
}

#pragma buy methods
- (void)reload {
    products = nil;
    [[FollowersExchangePurchase sharedInstance] requestProductsWithCompletionHandler:^(BOOL success, NSArray *productss) {
        if (success) {
            NSMutableArray* tempProducts = [[NSMutableArray alloc]initWithObjects:@"",@"", nil];
            for (SKProduct* product in productss) {
                if([product.productIdentifier isEqualToString:@"arabdevs.emsahWerbah.6"])
                {
                    [tempProducts replaceObjectAtIndex:0 withObject:product];
                }else if([product.productIdentifier isEqualToString:@"arabdevs.emsahWerbah.6s"])
                {
                    [tempProducts replaceObjectAtIndex:1 withObject:product];
                }else if([product.productIdentifier isEqualToString:@"arabdevs.emsahWerbah.50land"] && [[[NSUserDefaults standardUserDefaults]objectForKey:@"path"] isEqualToString:@"Land-Marks"])
                {
                    [tempProducts addObject:product];
                }else if([product.productIdentifier isEqualToString:@"arabdevs.emsahWerbah.70land"] && [[[NSUserDefaults standardUserDefaults]objectForKey:@"path"] isEqualToString:@"Land-Marks"])
                {
                    [tempProducts addObject:product];
                }else if([product.productIdentifier isEqualToString:@"arabdevs.emsahWerbah.50player"] && [[[NSUserDefaults standardUserDefaults]objectForKey:@"path"] isEqualToString:@"Players"])
                {
                    [tempProducts addObject:product];
                }else if([product.productIdentifier isEqualToString:@"arabdevs.emsahWerbah.70player"] && [[[NSUserDefaults standardUserDefaults]objectForKey:@"path"] isEqualToString:@"Players"])
                {
                    [tempProducts addObject:product];
                }
            }
            products = [[NSArray alloc]initWithArray:tempProducts];
        }
    }];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(actionSheet.tag == 1)
    {
        if(buttonIndex == 1)
        {
            currentImage = @"0";
            
            [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"path" ],@"SOLVED"]];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            [scratchImageView removeFromSuperview];
            [self.navigationController popViewControllerAnimated:YES];
        }else if(buttonIndex == 2 && buttonIndex != actionSheet.cancelButtonIndex)
        {
            SKProduct *product = products[3];
            [[FollowersExchangePurchase sharedInstance] buyProduct:product];
        }else if(buttonIndex == 3 && buttonIndex != actionSheet.cancelButtonIndex)
        {
            SKProduct *product = products[2];
            [[FollowersExchangePurchase sharedInstance] buyProduct:product];
        }
    }
    
    if(buttonIndex == 0)
    {
        if (actionSheet.tag == 1)
        {
            [self startHints];
        }
        else if (actionSheet.tag == 2)
        {
            [self knewTheSolution];
        }
    }
    else if(buttonIndex == 1)
    {
        if (actionSheet.tag == 2)
        {
            [self startElMaseh];
        }
    }
    
}

-(void)knewTheSolution
{
    if(!gift)
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"عرفت الحل؟"
                                  message:@"رجاء قم بكتابة الحل هنا:"
                                  delegate:self
                                  cancelButtonTitle:@"إلغاء"
                                  otherButtonTitles:@"تم", nil];
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [alertView setTag:3];
        [alertView show];
    }else
    {
        if(dataSourcee && dataSourcee.count > 0)
        {
            UIPasteboard *pb = [UIPasteboard generalPasteboard];
            [pb setString:[[dataSourcee objectAtIndex:0] objectForKey:@"code"]];
            if([[[dataSourcee objectAtIndex:0] objectForKey:@"type"] isEqualToString:@"3"])
            {
                OLGhostAlertView* alert = [[OLGhostAlertView alloc]initWithTitle:@"للتبيلغ" message:@"قم بارسال إيميل ل info@arabdevs.com تحتوي كود الربح و التغريدة المراد الإعلان عنها" timeout:10 dismissible:YES];
                [alert show];
            }
        }
        
        [scratchImageView removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
        
        /*[UIView animateWithDuration:5.f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
         [scratchImageView setAlpha:0.f];
         } completion:^(BOOL finished) {
         [scratchImageView removeFromSuperview];
         [self.navigationController popViewControllerAnimated:YES];
         }];*/
    }
}

-(void)startElMaseh
{
    if([[store stringForKey:@"secs"] isEqualToString:@"0"])
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"عفوا" message:@"هل تريد شراء باقة مسح الصور؟" delegate:self cancelButtonTitle:@"لا" otherButtonTitles:@"نعم", nil];
        [alert setTag:2];
        [alert show];
    }else
    {
        
        OLGhostAlertView* alert = [[OLGhostAlertView alloc]initWithTitle:@"امسح بسرعة" message:@"" timeout:2 dismissible:YES];
        [alert show];
        [self.circle setValue:0.0f];
        [self.timerLabel setText:@"0.0"];
        [self.timerLabel setAlpha:1.0f];
        [self.circle setAlpha:1.0f];
        timeLeft = [[store stringForKey:@"secs"] floatValue];
        [scratchImageView setUserInteractionEnabled:YES];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"mask"];
        [NSTimer scheduledTimerWithTimeInterval:0.1
                                         target:self
                                       selector:@selector(updateProgress:)
                                       userInfo:nil
                                        repeats:YES];
    }
}

-(void)startHints
{
    if([[store stringForKey:@"hints"] isEqualToString:@"0"])
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"باقة المساعدات" message:@"هل تريد شراء باقة المساعدات؟" delegate:self cancelButtonTitle:@"لا" otherButtonTitles:@"نعم", nil];
        [alert setTag:1];
        [alert show];
    }else
    {
        OLGhostAlertView* alert;
        if(currentDisplayedInfo >= 4)
        {
            alert = [[OLGhostAlertView alloc]initWithTitle:@"عذراً" message:@"لقد إستنفذت كل المساعدات النصية الخاصة بهذه الصورة" timeout:5 dismissible:YES];
        }else if(currentDisplayedInfo == 3)
        {
            NSString* answer = [info objectAtIndex:currentDisplayedInfo];
            NSArray* answerParts = [answer componentsSeparatedByString:@" "];
            
            alert = [[OLGhostAlertView alloc]initWithTitle:@"الإجابة :" message:[NSString stringWithFormat:@"%@ %i %@ %i %@",@"تتكون الإجابة من",answer.length,@"حرف. مقسمة على",[answerParts count],@"كلمة"]timeout:30 dismissible:YES];
            int hints = [[store stringForKey:@"hints"]intValue];
            hints -= 1;
            [store setString:[NSString stringWithFormat:@"%i",hints] forKey:@"hints"];
            [store synchronize];
            
            [self.hinstAvLabel setText:[@"عدد المساعدات المتبقية لديك: " stringByAppendingString:[store stringForKey:@"hints"]]];
            [self.hinstAvLabel setNeedsDisplay];
            currentDisplayedInfo++;
        }else
        {
            alert = [[OLGhostAlertView alloc]initWithTitle:@"المساعدة هي" message:[info objectAtIndex:currentDisplayedInfo] timeout:30 dismissible:YES];
            
            int hints = [[store stringForKey:@"hints"]intValue];
            hints -= 1;
            [store setString:[NSString stringWithFormat:@"%i",hints] forKey:@"hints"];
            [store synchronize];
            
            [self.hinstAvLabel setText:[@"عدد المساعدات المتبقية لديك: " stringByAppendingString:[store stringForKey:@"hints"]]];
            [self.hinstAvLabel setNeedsDisplay];
            currentDisplayedInfo++;
        }
        [alert show];
    }
}

- (void)productCanceled:(NSNotification *)notification {
    isRealBuy = NO;
}

- (IBAction)knewSolution:(id)sender {
    [self knewTheSolution];
}

- (IBAction)hintsPressed:(id)sender {
    UIActionSheet* sheet ;
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"path"]);
    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"path"]isEqualToString:@"Players"] || [[[NSUserDefaults standardUserDefaults]objectForKey:@"path"]isEqualToString:@"Land-Marks"])
    {
        sheet = [[UIActionSheet alloc] initWithTitle:@"مساعدة" delegate:self cancelButtonTitle:@"إلغاء" destructiveButtonTitle:nil otherButtonTitles:@"معلومة عن الصورة", @"Reset",@"تقليل تشفير ١٠ صور ل ٧٠٪",@"تقليل تشفير ١٠ صور ل ٥٠٪",nil];
    }else
    {
        sheet = [[UIActionSheet alloc]initWithTitle:@"مساعدة" delegate:self cancelButtonTitle:@"إلغاء" destructiveButtonTitle:nil otherButtonTitles:@"معلومة عن الصورة", @"Reset",nil];
    }
    [sheet setTag:1];
    [sheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)emsah:(id)sender {
    [self startElMaseh];
}

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
                    [self.hinstAvLabel setText:[@"عدد المساعدات المتبقية لديك: " stringByAppendingString:[NSString stringWithFormat:@"%i",hints]]];
                    [self.hinstAvLabel setNeedsDisplay];
                    [alert show];
                }else if([productIdentifier isEqualToString:@"arabdevs.emsahWerbah.6s"])
                {
                    float hints = [[store stringForKey:@"secs"]floatValue];
                    hints += 3.00;
                    [store setString:[NSString stringWithFormat:@"%0.2f",hints] forKey:@"secs"];
                    [store synchronize];
                    [self.secondsAvLabel setText:[NSString stringWithFormat:@"%0.2f",hints]];
                    [self.secondsAvLabel setNeedsDisplay];
                    [alert show];
                }
                else if([productIdentifier isEqualToString:@"arabdevs.emsahWerbah.70player"])
                {
                    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"path"]isEqualToString:@"Players"])
                    {
                        blurAddingString = @"-70";
                        [[NSUserDefaults standardUserDefaults] setObject:blurAddingString forKey:@"blurplayer"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        int rem = [[[NSUserDefaults standardUserDefaults] objectForKey:@"blurplayerrem"] intValue];
                        rem = 10;
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i",rem] forKey:@"blurplayerrem"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                    }
                    [alert show];
                    [self initUI];
                }else if([productIdentifier isEqualToString:@"arabdevs.emsahWerbah.50player"])
                {
                    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"path"]isEqualToString:@"Players"])
                    {
                        blurAddingString = @"-50";
                        [[NSUserDefaults standardUserDefaults] setObject:blurAddingString forKey:@"blurplayer"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        int rem = [[[NSUserDefaults standardUserDefaults] objectForKey:@"blurplayerrem"] intValue];
                        rem = 10;
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i",rem] forKey:@"blurplayerrem"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                    }
                    [alert show];
                    [self initUI];
                }else if([productIdentifier isEqualToString:@"arabdevs.emsahWerbah.70land"])
                {
                    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"path"]isEqualToString:@"Land-Marks"])
                    {
                        blurAddingString = @"-70";
                        [[NSUserDefaults standardUserDefaults] setObject:blurAddingString forKey:@"blurlandmark"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        int rem = [[[NSUserDefaults standardUserDefaults] objectForKey:@"blurlandmarkrem"] intValue];
                        rem = 10;
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i",rem] forKey:@"blurlandmarkrem"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                    }
                    [alert show];
                    [self initUI];
                }else if([productIdentifier isEqualToString:@"arabdevs.emsahWerbah.50land"])
                {
                    if([[[NSUserDefaults standardUserDefaults]objectForKey:@"path"]isEqualToString:@"Land-Marks"])
                    {
                        blurAddingString = @"-50";
                        [[NSUserDefaults standardUserDefaults] setObject:blurAddingString forKey:@"blurlandmark"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        int rem = [[[NSUserDefaults standardUserDefaults] objectForKey:@"blurlandmarkrem"] intValue];
                        rem = 10;
                        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%i",rem] forKey:@"blurlandmarkrem"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                    }
                    [alert show];
                    [self initUI];
                }
                *stop = YES;
            }
        }
    }];
    
}


-(void)updateProgress:(NSTimer *) timer
{
    
    if([[NSUserDefaults standardUserDefaults]boolForKey:@"touchEnd"])
    {
        [timer invalidate];
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"mask"];
        [scratchImageView setUserInteractionEnabled:NO];
        [[NSUserDefaults standardUserDefaults] setObject:@NO forKey:@"touchEnd"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        //timerLabel.alpha = 0.0f;
        timerLabel.text = [@"عدد الثواني المتبقي لديك: " stringByAppendingString:[store stringForKey:@"secs"]];
        circle.alpha = 0.0f;
    }else
    {
        float ff = [[store stringForKey:@"secs"] floatValue];
        ff -= 0.1;
        
        [self.circle setValue:(ff/timeLeft)];
        [self.timerLabel setText:[NSString stringWithFormat:@"   %0.2f",ff]];
        
        if(ff <= 0)
        {
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"mask"];
            [store setString:@"0" forKey:@"secs"];
            [store synchronize];
            [timer invalidate];
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"mask"];
            [scratchImageView setUserInteractionEnabled:NO];
            //timerLabel.alpha = 0.0f;
            timerLabel.text = [@"عدد الثواني المتبقي لديك: " stringByAppendingString:[store stringForKey:@"secs"]];
            circle.alpha = 0.0f;
        }else
        {
            [store setString:[NSString stringWithFormat:@"%0.2f",ff] forKey:@"secs"];
            [store synchronize];
            [self.secondsAvLabel setText:[NSString stringWithFormat:@"%0.2f",ff]];
            [self.secondsAvLabel setNeedsDisplay];
        }
    }
}

#pragma alert delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            SKProduct *product = products[0];
            [[FollowersExchangePurchase sharedInstance] buyProduct:product];
        }
    }else if(alertView.tag == 2)
    {
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            SKProduct *product = products[1];
            [[FollowersExchangePurchase sharedInstance] buyProduct:product];
        }
    }else if(alertView.tag == 3)
    {
        if(buttonIndex != alertView.cancelButtonIndex)
        {
            NSString* enteredAnswer = [[alertView textFieldAtIndex:0] text];
            if([enteredAnswer isEqualToString:[info objectAtIndex:3]])
            {
                [remain removeObject:currentImage];
                
                NSString* newSol =  [[NSUserDefaults standardUserDefaults]objectForKey:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"path" ],@"SOLVED"]];
                newSol = [newSol stringByAppendingFormat:@"##%@",currentImage];
                [[NSUserDefaults standardUserDefaults]setObject:newSol forKey:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"path" ],@"SOLVED"]];
                
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                if(remain.count == 0 && !gift)
                {
                    gift = YES;
                    OLGhostAlertView* alert = [[OLGhostAlertView alloc] initWithTitle:@"مبروك" message:@"لقد حللت كل صور المجموعه وسيكون هناك المزيد في التحديثات القادمة" timeout:5 dismissible:YES];
                    [alert show];
                    [scratchImageView removeFromSuperview];
                    [self initUI];
                }else if(remain.count == 0 && gift)
                {
                    
                    [UIView animateWithDuration:5.f delay:0.f options:UIViewAnimationOptionCurveEaseIn animations:^{
                        [scratchImageView setAlpha:0.f];
                    } completion:^(BOOL finished) {
                        [scratchImageView removeFromSuperview];
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                }else
                {
                    [scratchImageView removeFromSuperview];
                    [self initUI];
                    [self showSuccessMsg];
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"إجابة خاطئة" message:@"حاول مرة أُخرى." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"حسناً", nil];
                [alert show];
            }
        }
    }
}

-(void)showSuccessMsg
{
    [UILabel animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        if ([[UIScreen mainScreen] bounds].size.height < 490)
        {
            [_successLabel setFrame:CGRectMake(_successLabel.frame.origin.x, 386, _successLabel.frame.size.width, _successLabel.frame.size.height)];
        }
        else
        {
            [_successLabel setFrame:CGRectMake(_successLabel.frame.origin.x, 474, _successLabel.frame.size.width, _successLabel.frame.size.height)];
        }
    } completion:^(BOOL finished) {
        [self hideSuccessMsg];
    }];
}

-(void)hideSuccessMsg
{
    [UILabel beginAnimations:nil context:NULL];
    [UILabel setAnimationDuration:0.3];
    [UILabel setAnimationDelay:2.0];
    if ([[UIScreen mainScreen] bounds].size.height < 490)
    {
        [_successLabel setFrame:CGRectMake(_successLabel.frame.origin.x, 416, _successLabel.frame.size.width, _successLabel.frame.size.height)];
    }
    else
    {
        [_successLabel setFrame:CGRectMake(_successLabel.frame.origin.x, 504, _successLabel.frame.size.width, _successLabel.frame.size.height)];
    }
    [UILabel commitAnimations];
}


#pragma mark connection delegate
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError* error2;
    
    NSString* whichImage = @"";
    
    dataSourcee = [NSJSONSerialization
                   JSONObjectWithData:data
                   options:kNilOptions
                   error:&error2];
    
    if([dataSourcee count] == 0)
    {
        whichImage = @"good-luck.png";
        [self.solutionButton setTitle:@"مرة أخرى" forState:UIControlStateNormal];
    }else
    {
        int type = [[[dataSourcee objectAtIndex:0] objectForKey:@"type"] intValue];
        if(type == 1) // itunes Card
        {
            whichImage = @"itunes-card.png";
        }else if(type == 2) // app code
        {
            whichImage = @"app-code.png";
        }else if(type == 3) // Commercial
        {
            whichImage = @"free-ad.png";
        }
        
        [self.solutionButton setTitle:@"نسخ الكود" forState:UIControlStateNormal];
    }
    
    
    NSArray *imagesDicts = @[ @{@"sharp" : whichImage, @"blured" : @"gift.png"}];
    for (NSDictionary *dictionary in imagesDicts) {
        UIImage *sharpImage = [UIImage imageNamed:[dictionary objectForKey:@"sharp"]];
        [imageView setImage:sharpImage];
        UIImage *bluredImage = [UIImage imageNamed:[dictionary objectForKey:@"blured"]];
        NSString *radiusString = [dictionary objectForKey:@"radius"];
        scratchImageView = [[MDScratchImageView alloc] initWithFrame:imageView.frame];
        scratchImageView.delegate = self;
        if (nil == radiusString) {
            scratchImageView.image = bluredImage;
        } else {
            [scratchImageView setImage:bluredImage radius:[radiusString intValue]];
            scratchImageView.image = bluredImage;
        }
        [self.view addSubview:scratchImageView];
        [scratchImageView setUserInteractionEnabled:YES];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"giftt"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"mask"];
    }
}

@end
