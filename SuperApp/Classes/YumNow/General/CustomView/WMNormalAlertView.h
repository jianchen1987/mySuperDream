//
//  WMNormalAlertView.h
//  SuperApp
//
//  Created by wmz on 2022/10/21.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class WMNormalAlertConfig;


@interface WMNormalAlertView : HDActionAlertView
///初始化
- (instancetype)initWithConfig:(WMNormalAlertConfig *)config;

@end

typedef void (^WMAlertViewButtonHandler)(WMNormalAlertView *alertView, HDUIButton *button);


@interface WMNormalAlertConfig : NSObject
/// title
@property (nonatomic, copy, nullable) NSString *title;
/// content
@property (nonatomic, copy) NSString *content;
/// contentAligment
@property (nonatomic, assign) NSTextAlignment contentAligment;
/// confirm
@property (nonatomic, copy) NSString *confirm;
/// confirm
@property (nonatomic, copy) NSString *cancel;
/// confirmHandle
@property (nonatomic, copy) WMAlertViewButtonHandler confirmHandle;
/// cancelHandle
@property (nonatomic, copy) WMAlertViewButtonHandler cancelHandle;

@end

NS_ASSUME_NONNULL_END
