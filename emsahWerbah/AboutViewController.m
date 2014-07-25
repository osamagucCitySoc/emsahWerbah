//
//  AboutViewController.m
//  twitterExampleIII
//
//  Created by Housein Jouhar on 6/15/13.
//  Copyright (c) 2013 MacBook. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)ourApps:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"تطبيقاتنا" delegate:self cancelButtonTitle:@"إلغاء" destructiveButtonTitle:nil otherButtonTitles:@"تطبيق 'غردلي'",@"تطبيق 'ضيفني أضيفك'",@"تطبيق 'إنستاعربي'",@"المزيد..",nil];
    [actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    actionSheet.tag = 1;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)followUs:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:///follow/ArabDevs"]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///follow/ArabDevs"]];
    }
    else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter://user?screen_name=ArabDevs"]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=ArabDevs"]];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/ArabDevs"]];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex  {
    switch (buttonIndex) {
        case 0:
        {
            if (actionSheet.tag == 1)
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/ghrdly/id671151269?ls=1&mt=8"]];
            }
        }
            break;
        case 1:
        {
            if (actionSheet.tag == 1)
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/dyfny-adyfk/id663980256?ls=1&mt=8"]];
            }
        }
            break;
        case 2:
        {
            if (actionSheet.tag == 1)
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/us/app/instaarabic-ansta-rby/id682522511?ls=1&mt=8"]];
            }
        }
            break;
        case 3:
        {
            if (actionSheet.tag == 1)
            {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.arabdevs.com/apps.html"]];
            }
        }
            break;
    }
}


-(void)viewWillAppear:(BOOL)animated {
    screenBound = [[UIScreen mainScreen] bounds];
    screenSize = screenBound.size;
    screenHeight = screenSize.height;
    self.navigationController.navigationBar.hidden = NO;
    float appVer = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] floatValue];
    
    _verLabel.text = [@"الإصدار:" stringByAppendingFormat:@" %.1f",appVer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *ver = [[UIDevice currentDevice] systemVersion];
    if ([ver floatValue] < 7.0)
    {
        for (UIView *view in [self.view subviews])
        {
            if (view.tag == 999)
            {
                [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y - 60, view.frame.size.width, view.frame.size.height)];
            }
        }
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"YYYY"];
    
    _rightsLabel.text = [@"جميع الحقوق محفوظة للمطورين العرب " stringByAppendingFormat:@"%@",[dateFormatter stringFromDate:[NSDate date]]];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
