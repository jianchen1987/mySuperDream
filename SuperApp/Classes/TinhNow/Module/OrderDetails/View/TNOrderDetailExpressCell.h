//
//  TNOrderDetailExpressCell.h
//  SuperApp
//
//  Created by 张杰 on 2022/8/26.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SATableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@interface TNOrderDetailExpressCellModel : NSObject
/// 是否是海外购
@property (nonatomic, assign) BOOL isOverseas;
/// 显示内容
@property (nonatomic, copy) NSString *content;
/// 时间
@property (nonatomic, copy) NSString *time;
/// 骑手电话
@property (nonatomic, copy) NSString *riderPhone;
/// 运单号
@property (nonatomic, copy) NSString *trackingNo;
/// 骑手操作员编号
@property (nonatomic, copy) NSString *riderOperatorNo;
///
@property (nonatomic, copy) NSString *orderNo;
@end


@interface TNOrderDetailExpressCell : SATableViewCell
///
@property (strong, nonatomic) TNOrderDetailExpressCellModel *model;
@end

NS_ASSUME_NONNULL_END
