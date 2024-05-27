//
//  WMHomeCustomViewModel.h
//  SuperApp
//
//  Created by wmz on 2022/4/28.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAViewModel.h"
#import "WMHomeCustomDTO.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMHomeCustomViewModel : SAViewModel
///通知Model
@property (nonatomic, strong) WMHomeNoticeModel *noticeModel;
///通知数组
@property (nonatomic, copy) NSArray<WMHomeNoticeModel *> *noticeArray;
///请求通知
- (void)requestNotice;
///重新缓存
- (void)reSaveNoticeArray;
///版本更新
- (void)versionUpdate;
@end

NS_ASSUME_NONNULL_END
