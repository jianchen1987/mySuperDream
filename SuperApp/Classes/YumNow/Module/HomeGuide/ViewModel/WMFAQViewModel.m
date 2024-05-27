//
//  WMFAQViewModel.m
//  SuperApp
//
//  Created by wmz on 2021/11/25.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMFAQViewModel.h"


@interface WMFAQViewModel ()

@property (nonatomic, strong) WMFAQDTO *faqDTO;

@end


@implementation WMFAQViewModel

- (void)yumNowQueryGuideLinkWithKey:(NSString *)key block:(void (^_Nullable)(WMFAQRspModel *rspModel))block {
    [self.faqDTO yumNowQueryGuideLinkWithKey:key success:^(WMFAQRspModel *_Nonnull rspModel) {
        self.rspModel = rspModel;
        !block ?: block(rspModel);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        self.rspModel = nil;
        !block ?: block(nil);
    }];
}

- (void)yumNowQueryGuideContentWithKey:(NSString *)key code:(NSString *)code block:(void (^_Nullable)(WMFAQDetailRspModel *rspModel))block {
    [self.faqDTO yumNowQueryGuideContentWithKey:key code:code success:^(WMFAQDetailRspModel *_Nonnull rspModel) {
        self.rspDetailModel = rspModel;
        !block ?: block(rspModel);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        self.rspDetailModel = nil;
        !block ?: block(nil);
    }];
}

- (void)yumNowGuideFeedBackWithCode:(NSString *)code parrse:(BOOL)parse block:(void (^_Nullable)(BOOL success))block {
    [self.faqDTO yumNowGuideFeedBackWithCode:code parrse:parse success:^(SARspModel *_Nonnull rspModel) {
        !block ?: block(true);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        !block ?: block(false);
    }];
}

- (WMFAQDTO *)faqDTO {
    if (!_faqDTO) {
        _faqDTO = WMFAQDTO.new;
    }
    return _faqDTO;
}

@end
