//
//  ViewController.h
//  emsahWerbah
//
//  Created by OsamaMac on 5/1/14.
//  Copyright (c) 2014 OsamaMac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MDScratchImageView.h"
#import "followersExchangePurchase.h"
#import "OLGhostAlertView.h"
#import "MACircleProgressIndicator.h"
#import "followersExchangePurchase.h"
#import "UICKeyChainStore.h"
#import "GADBannerView.h"

@interface ViewController : UIViewController<MDScratchImageViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate, NSURLConnectionDataDelegate,NSURLConnectionDelegate>

{
    float timeLeft;
    MDScratchImageView *scratchImageView;
    NSString* currentImage;
    NSString* currentPath;
    NSArray* info;
    int currentDisplayedInfo;
    BOOL gift;
    NSURLConnection* connection;
    NSURLConnection* getDetailsConnection;
    NSArray* dataSourcee;
    UICKeyChainStore *store;
    NSMutableArray* remain;
    
    GADBannerView *bannerView_;
    GADBannerView *bannerView_2;
    
    NSString* blurAddingString;

}

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *busyInd;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) NSArray* products;
@property (strong, nonatomic) IBOutlet MACircleProgressIndicator *circle;
@property (strong, nonatomic) IBOutlet UILabel *timerLabel;
@property (strong, nonatomic) IBOutlet UILabel *hinstAvLabel;
@property (strong, nonatomic) IBOutlet UILabel *secondsAvLabel;
@property (weak, nonatomic) IBOutlet UIView *bannerView;
- (IBAction)hintsPressed:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *solutionButton;
@property (strong, nonatomic) IBOutlet UIButton *emsahButton;
@property (strong, nonatomic) IBOutlet UIButton *optionsButton;
@property (strong, nonatomic) IBOutlet UILabel *successLabel;


@end
