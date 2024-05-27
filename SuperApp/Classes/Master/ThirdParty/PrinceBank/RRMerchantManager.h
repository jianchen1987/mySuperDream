//
//  RRMerchantManager.h
//  RRMerchantSDK-ObjC
//
//  Created by Oung Safhone on 10/10/2023.
//

#import <Foundation/Foundation.h>

@interface RRMerchantManager : NSObject {
    NSString *appID;
}

@property (class, readonly) RRMerchantManager *shared;

- (void)setAppID:(NSString *)appName;
- (void)openPrinceBankWithOrder:(NSString *)order;
- (void)handlePayWithURL:(NSURL *)url complete:(void (^)(NSString *status))complete;

@end
