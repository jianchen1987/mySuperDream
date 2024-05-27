//
//  PNPacketPayPasswordAlertView.h
//  SuperApp
//
//  Created by xixi_wen on 2022/12/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketBuildRspModel.h"
#import "PNPacketPayPasswordAlertViewModel.h"
#import <HDUIKit/HDUIKit.h>

@class PNPacketPayPasswordAlertView;

NS_ASSUME_NONNULL_BEGIN

@protocol PNPacketPayPasswordAlertViewDelegate <NSObject>

- (void)pwd_textFieldDidFinishedEditing:(NSString *)text businessObj:(id _Nullable)businessObj view:(PNPacketPayPasswordAlertView *)alertView;

@end


@interface PNPacketPayPasswordAlertView : HDActionAlertView

@property (nonatomic, weak) id<PNPacketPayPasswordAlertViewDelegate> pwdDelegate;

@property (nonatomic, strong) PNPacketPayPasswordAlertViewModel *model;

- (instancetype)init;

- (void)clearText;

@end

NS_ASSUME_NONNULL_END
