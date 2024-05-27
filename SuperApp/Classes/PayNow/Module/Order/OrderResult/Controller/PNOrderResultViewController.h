//
//  OrderResultVC.h
//  SuperApp
//
//  Created by Quin on 2021/11/18.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "HDPayOrderRspModel.h"
#import "PNViewController.h"
#import "PayOrderTableCellModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^callBackBlock)(void);


@interface PNOrderResultViewController : PNViewController
@property (nonatomic, strong) NSMutableArray<PayOrderTableCellModel *> *dataSource;
@property (nonatomic, assign) PNOrderResultPageType type; // 1结果页 否则详情页
@property (nonatomic, strong) HDPayOrderRspModel *rspModel;
// 右上角完成按钮点击回调
@property (nonatomic, copy) void (^clickedDoneBtnHandler)(void); ///< 点击完成

@end

NS_ASSUME_NONNULL_END
