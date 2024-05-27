//
//  WMStoreImageShareView.h
//  SuperApp
//
//  Created by Chaos on 2021/1/4.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "SASocialShareBaseGenerateImageView.h"
#import "WMStoreActivityMdoel.h"

NS_ASSUME_NONNULL_BEGIN

@class WMStoreDetailRspModel;


@interface WMStoreImageShareView : SASocialShareBaseGenerateImageView
@property (nonatomic ,strong) WMStoreActivityMdoel *activityModel;
+ (instancetype)storeImageShareWithModel:(WMStoreDetailRspModel *)detailModel activityModel:(WMStoreActivityMdoel*)activityModel;

@end

@interface WMStoreShareActivityItemView : SAView
@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) NSString *detail;
@end

NS_ASSUME_NONNULL_END
