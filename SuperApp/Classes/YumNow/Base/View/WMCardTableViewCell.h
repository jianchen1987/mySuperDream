//
//  WMCardTableViewCell.h
//  SuperApp
//
//  Created by wmz on 2022/3/4.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "HDMediator+YumNow.h"
#import "WMCardCellProtocol.h"
#import "WMCyclePagerView.h"
#import "WMHomeLayoutModel.h"
#import "WMTableViewCell.h"
#import "UICollectionView+RecordData.h"
#import "WMViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMCardTableViewCell
    : WMTableViewCell <WMCardCellProtocol, UICollectionViewDelegate, UICollectionViewDataSource, HDCyclePagerViewDelegate, HDCyclePagerViewDataSource, UICollectionViewDelegateFlowLayout>
/// layoutModel
@property (nonatomic, strong) WMHomeLayoutModel *layoutModel;
///< viewmodel
@property (nonatomic, strong) WMViewModel *viewModel;
/// 刷新卡片回调
@property (nonatomic, copy) void (^refreshCell)(void);
/// 刷新网络回调
@property (nonatomic, copy) void (^changeDataCell)(WMHomeLayoutModel *layoutModel);

@end


@interface WMItemCardCell : SACollectionViewCell <HDSkeletonLayerLayoutProtocol>

@end

NS_ASSUME_NONNULL_END
