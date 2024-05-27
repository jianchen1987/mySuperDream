//
//  WMOrderFeedBackUploadInfoView.h
//  SuperApp
//
//  Created by wmz on 2022/11/18.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAPhotoManager.h"
#import "SAView.h"
#import "WMEnum.h"
#import "WMOrderFeedBackReasonRspModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMOrderFeedBackUploadInfoView : SAView
///选中的原因model
@property (nonatomic, strong, nullable) WMOrderFeedBackReasonRspModel *selectReasonModel;
/// contentTV
@property (nonatomic, strong) HDTextView *contentTV;
/// contentBg
@property (nonatomic, strong) UIView *contentBg;
///选择的照片
@property (nonatomic, copy) NSArray<HXPhotoModel *> *selectedPhotos;
///标志
@property (nonatomic, assign) BOOL flag;
/// type
@property (nonatomic, copy) WMOrderFeedBackPostShowType type;

@end

NS_ASSUME_NONNULL_END
