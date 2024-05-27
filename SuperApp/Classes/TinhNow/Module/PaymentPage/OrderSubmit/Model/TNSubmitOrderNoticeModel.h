//
//  TNSubmitOrderNoticeModel.h
//  SuperApp
//
//  Created by 张杰 on 2021/4/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNNoticeModel : TNModel
/// 是否开启 1-是，0否
@property (nonatomic, assign) BOOL isOpen;
/// 展示文本
@property (nonatomic, copy) NSString *noticeMsg;

/// 是否已经弹窗过  如果payOrderPop弹窗的类型  用来记录
@property (nonatomic, assign) BOOL isShow;
@end


@interface TNSubmitOrderNoticeModel : TNModel
/// 海外购条款
@property (strong, nonatomic) TNNoticeModel *overseasKnow;
/// 置顶显示文本
@property (strong, nonatomic) TNNoticeModel *payOrderTop;
/// 弹窗显示文本
@property (strong, nonatomic) TNNoticeModel *payOrderPop;
@end

NS_ASSUME_NONNULL_END
