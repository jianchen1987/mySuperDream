//
//  WQCodeScanner.h
//  National Wallet
//
//  Created by 陈剑 on 2018/4/23.
//  Copyright © 2018年 chaos technology. All rights reserved.
//

#import "SAViewController.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WQCodeScannerType) {
    WQCodeScannerTypeAll = 0, // default, scan QRCode and barcode
    WQCodeScannerTypeQRCode,  // scan QRCode only
    WQCodeScannerTypeBarcode, // scan barcode only
};


@interface WQCodeScanner : SAViewController

@property (nonatomic, assign) WQCodeScannerType scanType;
@property (nonatomic, copy) NSString *titleStr;
@property (nonatomic, copy) NSString *tipStr;
@property (nonatomic, assign) BOOL shouldDealingResultByCaller; ///< 扫描到结果后的操作是否由调用者决定，默认为 NO

@property (nonatomic, copy) void (^resultBlock)(NSString *value);

@end
