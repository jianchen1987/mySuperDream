//
//  TNRefundCommonDictModel.h
//  SuperApp
//
//  Created by xixi on 2021/1/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNRefundCommonDictItemModel : TNModel
///
@property (nonatomic, strong) NSString *_id;
///
@property (nonatomic, strong) NSString *status;
///
@property (nonatomic, strong) NSString *version;
///
@property (nonatomic, assign) long long lastModifiedDate;
///
@property (nonatomic, strong) NSString *typeId;
///
@property (nonatomic, assign) long long createdDate;
///
@property (nonatomic, strong) NSString *treeCode;
///
@property (nonatomic, strong) NSString *value;
///
@property (nonatomic, strong) NSString *order;
///
@property (nonatomic, strong) NSString *name;
///
@property (nonatomic, strong) NSString *parentId;
@end


@interface TNRefundCommonDictModel : TNModel
/// 退款原因
@property (nonatomic, strong) NSArray<TNRefundCommonDictItemModel *> *REFUND_REASON;
/// 申请原因
@property (nonatomic, strong) NSArray<TNRefundCommonDictItemModel *> *APPLY_REASON;
/// 退款类型
@property (nonatomic, strong) NSArray<TNRefundCommonDictItemModel *> *REFUND_TYPE;
@end

NS_ASSUME_NONNULL_END
