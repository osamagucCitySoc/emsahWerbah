//
//  IAPHelper.m
//  twitterExampleIII
//
//  Created by ousamaMacBook on 6/19/13.
//  Copyright (c) 2013 MacBook. All rights reserved.
//

#import "IAPHelper.h"

@interface IAPHelper () <SKProductsRequestDelegate,SKPaymentTransactionObserver>
@end

NSString *const IAPHelperProductPurchasedNotification = @"IAPHelperProductPurchasedNotification";
NSString *const IAPHelperProductRestoreNotification = @"IAPHelperProductRestoredNotification";
NSString *const IAPHelperProductFailedNotification = @"IAPHelperProductFailedNotification";

@implementation IAPHelper
{
    SKProductsRequest * _productsRequest;
    RequestProductsCompletionHandler _completionHandler;
    NSSet * _productIdentifiers;
    NSMutableSet * _purchasedProductIdentifiers;
}

@synthesize validateConnection;

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
    if ((self = [super init])) {
        //delegate for purchasing
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        // Store product identifiers
        _productIdentifiers = productIdentifiers;
        
        // Check for previously purchased products
        _purchasedProductIdentifiers = [NSMutableSet set];
        for (NSString * productIdentifier in _productIdentifiers) {
            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
            if (productPurchased) {
                [_purchasedProductIdentifiers addObject:productIdentifier];
                NSLog(@"Previously purchased: %@", productIdentifier);
                if([productIdentifier isEqualToString:@"arabdevs.menoDag.11"])
                {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"phonePartSearch"];
                }else if([productIdentifier isEqualToString:@"arabdevs.menoDag.22"])
                {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"nameSearch"];
                }else if([productIdentifier isEqualToString:@"arabdevs.menoDag.33"])
                {
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"noADS"];
                }
                
                [[NSUserDefaults standardUserDefaults]synchronize];
            } else {
                //NSLog(@"Not purchased: %@", productIdentifier);
            }
        }
    }
    return self;
}

- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler {
    
    // 1
    _completionHandler = [completionHandler copy];
    
    // 2
    _productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers];
    _productsRequest.delegate = self;
    [_productsRequest start];
    
}


#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSLog(@"Loaded list of products...");
    _productsRequest = nil;
    
    NSArray * skProducts = response.products;
    for (SKProduct * skProduct in skProducts) {
        NSLog(@"Found product: %@ %@ %0.2f",
              skProduct.productIdentifier,
              skProduct.localizedTitle,
              skProduct.price.floatValue);
    }
    @try {
        _completionHandler(YES, skProducts);
        _completionHandler = nil;
    }
    @catch (NSException *exception) {}
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    
    NSLog(@"Failed to load list of products.");
    _productsRequest = nil;
    
    _completionHandler(NO, nil);
    _completionHandler = nil;
    
}

#pragma mark - purchasing methods

- (BOOL)productPurchased:(NSString *)productIdentifier {
    return [_purchasedProductIdentifiers containsObject:productIdentifier];
}

- (void)buyProduct:(SKProduct *)product {
    NSLog(@"Buying %@...", product.productIdentifier);
    SKPayment * payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

#pragma mark - purchasing delegates
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            default:
                break;
        }
    };
}


- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    if([self verifyReceipt:transaction])
    {
        NSLog(@"completeTransaction...");
        [self provideContentForProductIdentifier:transaction.payment.productIdentifier];
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"لم يتم الشراء" message:@"إما إنك تخترقنا فأنصحك أن تنسى، أو هناك خطأ راسلنا" delegate:nil cancelButtonTitle:@"تم" otherButtonTitles:nil];
        [alert show];
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"restoreTransaction...%@",transaction.originalTransaction.payment.productIdentifier);
    
    [self provideContentForProductIdentifierRestored:transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }else
    {
        [self provideContentForProductIdentifierCanceled:transaction.originalTransaction.payment.productIdentifier];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)provideContentForProductIdentifier:(NSString *)productIdentifier {
    if([productIdentifier isEqualToString:@"arabdevs.menoDag.11"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"phonePartSearch"];
    }else if([productIdentifier isEqualToString:@"arabdevs.menoDag.22"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"nameSearch"];
    }else if([productIdentifier isEqualToString:@"arabdevs.menoDag.33"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"noADS"];
    }
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductPurchasedNotification object:productIdentifier userInfo:nil];
}

- (void)provideContentForProductIdentifierRestored:(NSString *)productIdentifier {
    if([productIdentifier isEqualToString:@"arabdevs.menoDag.11"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"phonePartSearch"];
        [_purchasedProductIdentifiers addObject:productIdentifier];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductRestoreNotification object:productIdentifier userInfo:nil];
    }else if([productIdentifier isEqualToString:@"arabdevs.menoDag.22"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"nameSearch"];
        [_purchasedProductIdentifiers addObject:productIdentifier];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductRestoreNotification object:productIdentifier userInfo:nil];
    }else if([productIdentifier isEqualToString:@"arabdevs.menoDag.33"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"noADS"];
        [_purchasedProductIdentifiers addObject:productIdentifier];
        [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductRestoreNotification object:productIdentifier userInfo:nil];
    }
}


- (void)provideContentForProductIdentifierCanceled:(NSString *)productIdentifier {
    [[NSNotificationCenter defaultCenter] postNotificationName:IAPHelperProductFailedNotification object:productIdentifier userInfo:nil];
}

- (void)restoreCompletedTransactions {
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}


- (BOOL)verifyReceipt:(SKPaymentTransaction *)transaction {
    NSString* string = [[NSString alloc]initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",string);
    NSString *post = [NSString stringWithFormat:@"purchase=%@",string];
    
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:NO];
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[post length]];
    
    NSURL *url = [NSURL URLWithString:@"http://osamalogician.com/validateMe2.php"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:90.0];
    [request setHTTPMethod:@"POST"];
    
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    [request setHTTPBody:postData];
    
    NSURLResponse* response;
    NSError* error = nil;
    
    //Capturing server response
    NSData* result = [NSURLConnection sendSynchronousRequest:request  returningResponse:&response error:&error];
    return [[[NSString alloc]initWithData:result encoding:NSUTF8StringEncoding]isEqual:@"OK"];
    /*NSString *jsonObjectString = [self encode:(uint8_t *)transaction.transactionReceipt.bytes length:transaction.transactionReceipt.length];
     NSLog(@"%@",jsonObjectString);
     NSString *completeString = [NSString stringWithFormat:@"http://osamalogician.com/validateMe2.php?receipt=%@", jsonObjectString];
     NSURL *urlForValidation = [NSURL URLWithString:completeString];
     NSMutableURLRequest *validationRequest = [[NSMutableURLRequest alloc] initWithURL:urlForValidation];
     [validationRequest setHTTPMethod:@"GET"];
     NSData *responseData = [NSURLConnection sendSynchronousRequest:validationRequest returningResponse:nil error:nil];
     NSString *responseString = [[NSString alloc] initWithData:responseData encoding: NSUTF8StringEncoding];
     NSInteger response = [responseString integerValue];
     return (response == 0);*/
}

- (NSString *)encode:(const uint8_t *)input length:(NSInteger)length {
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData *data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t *output = (uint8_t *)data.mutableBytes;
    
    for (NSInteger i = 0; i < length; i += 3) {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger index = (i / 3) * 4;
        output[index + 0] =                    table[(value >> 18) & 0x3F];
        output[index + 1] =                    table[(value >> 12) & 0x3F];
        output[index + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[index + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

@end
