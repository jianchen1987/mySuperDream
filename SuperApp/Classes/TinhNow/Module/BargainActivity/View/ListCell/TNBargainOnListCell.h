//
//  TNBargainOnListCell.h
//  SuperApp
//
//  Created by 张杰 on 2020/10/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainRecordModel.h"
#import "TNCollectionViewCell.h"
NS_ASSUME_NONNULL_BEGIN


@interface TNBargainOnListCellModel : NSObject
/// 数据源
@property (strong, nonatomic) NSArray<TNBargainRecordModel *> *list;
/// table高度 根据数量计算
@property (nonatomic, assign) CGFloat tableHeight;
@end


@interface TNBargainOnListCell : TNCollectionViewCell
/// 数据源
@property (strong, nonatomic) NSArray<TNBargainRecordModel *> *dataArr;
/// 是否显示展示显示更多按钮
@property (nonatomic, assign) BOOL isShowExtend;
/// 是否展开了
@property (nonatomic, assign) BOOL isExtend;
/// 展开按钮回调
@property (nonatomic, copy) void (^extendClickCallBack)(BOOL isExtend);

/// 点击继续助力 埋点回调
@property (nonatomic, copy) void (^continueBargainClickTrackEventCallBack)(void);
@end

NS_ASSUME_NONNULL_END
