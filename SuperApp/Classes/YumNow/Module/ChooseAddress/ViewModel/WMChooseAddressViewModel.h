//
//  WMChooseAddressViewModel.h
//  SuperApp
//
//  Created by wmz on 2021/4/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "WMViewModel.h"
#import "SAAddressModel.h"
#import "SAShoppingAddressModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface WMChooseAddressViewModel : WMViewModel
// 历史记录本地存储逻辑
- (void)localSaveHistoryAddress:(SAAddressModel *)addressModel;
//历史记录清除
- (void)localClearHistoryAddress;
@end

NS_ASSUME_NONNULL_END
