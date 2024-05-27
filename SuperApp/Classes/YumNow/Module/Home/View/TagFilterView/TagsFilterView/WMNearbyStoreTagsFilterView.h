//
//  WMNearbyStoreTagsFilterView.h
//  SuperApp
//
//  Created by seeu on 2020/8/7.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAView.h"
#import "WMModel.h"

NS_ASSUME_NONNULL_BEGIN

@class WMNearbyStoreTagsModel;


@interface WMNearbyStoreTagsFilterView : SAView <HDCustomViewActionViewProtocol>

- (instancetype)initWithFrame:(CGRect)frame selectedTags:(NSArray<NSString *> *)tags;
/// tags changed
//@property (nonatomic, copy) void (^selectedTagsChanged)(NSArray<NSString *> *selectedTags);
/// 完成按钮
@property (nonatomic, copy) void (^completeButtonClickedHandler)(NSArray<NSString *> *selectedTags);
/// 取消按钮点击
@property (nonatomic, copy) void (^clearButtonClickedHandler)(void);

@end

NS_ASSUME_NONNULL_END
