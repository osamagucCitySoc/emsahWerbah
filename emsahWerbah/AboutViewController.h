//
//  AboutViewController.h
//  twitterExampleIII
//
//  Created by Housein Jouhar on 6/15/13.
//  Copyright (c) 2013 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Twitter/Twitter.h>
#import <Social/Social.h>

@interface AboutViewController : UIViewController<UIActionSheetDelegate>
{
    CGRect screenBound;
    CGSize screenSize;
    CGFloat screenHeight;
}
@property (strong, nonatomic) IBOutlet UILabel *verLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightsLabel;


@end
