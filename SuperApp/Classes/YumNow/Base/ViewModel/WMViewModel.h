//
//  WMViewModel.h
//  SuperApp
//
//  Created by VanJay on 2020/6/16.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "HDAppTheme+YumNow.h"
#import "SAViewModel.h"
#import "WMViewControllerProtocol.h"

NS_ASSUME_NONNULL_BEGIN


@interface WMViewModel : SAViewModel
/// 3.0埋点
/// 搜索id
@property (nonatomic, copy) NSString *searchId;
///广告/活动 id
@property (nonatomic, copy) NSString *plateId;
///专题页id
@property (nonatomic, copy) NSString *topicPageId;
/// 活动类型
@property (nonatomic, copy) NSString *collectType;
/// 内容
@property (nonatomic, copy) NSString *collectContent;
///付费商家
@property (nonatomic, copy) NSString *payFlag;
///来源
@property (nonatomic, strong) NSString *pageSource;
///邀请码
@property (nonatomic, copy) NSString *shareCode;
@end

NS_ASSUME_NONNULL_END
