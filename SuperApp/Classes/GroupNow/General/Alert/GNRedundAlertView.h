//
//  GNRedundAlertView.h
//  SuperApp
//
//  Created by wmz on 2023/1/13.
//  Copyright © 2023 chaos network technology. All rights reserved.
//

#import <HDUIKit/HDUIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class GNNormalAlertConfig;


@interface GNRedundAlertView : HDActionAlertView
///初始化
- (instancetype)initWithConfig:(GNNormalAlertConfig *)config;

@end

typedef void (^GNAlertViewButtonHandler)(GNRedundAlertView *alertView, HDUIButton *button);


@interface GNNormalAlertConfig : NSObject
/// title
@property (nonatomic, copy) NSString *title;
/// content
@property (nonatomic, copy) NSString *content;
/// confirm
@property (nonatomic, copy) NSString *confirm;
/// confirmHandle
@property (nonatomic, copy) GNAlertViewButtonHandler confirmHandle;
/// confirmHandle
@property (nonatomic, copy) GNAlertViewButtonHandler cancelHandle;

@end
NS_ASSUME_NONNULL_END
