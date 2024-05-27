//
//  HDBaseHtmlVC.h
//  ViPayMerchant
//
//  Created by 谢 on 2018/7/9.
//  Copyright © 2018年 混沌网络科技. All rights reserved.
//

#import "SAViewController.h"
#import <WebKit/WebKit.h>

typedef NS_ENUM(NSUInteger, UrlType) {
    UrlTypeInside,
    UrlTypeOut,
};


@interface HDBaseHtmlVC : SAViewController <WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, copy) NSString *backfunctionName;
@property (nonatomic, copy) NSString *closefunctionName;
@property (nonatomic, copy) NSString *rightButtonfunctionName;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, copy) NSString *viewWillEnter;
@property (nonatomic, copy) NSString *viewWillLeave;
@property (nonatomic, copy) NSString *titleClickedFuncName; ///< 标题点击回调

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign) UrlType urlType;

/**
 存放所有服务
 */
@property (nonatomic, strong) NSMutableArray *allServiceArray;

@end
