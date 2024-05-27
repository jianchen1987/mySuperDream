//
//  PNAddAndEditReciverInfoViewModel.h
//  SuperApp
//
//  Created by 张杰 on 2022/6/17.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNInterTransferReciverModel.h"
#import "PNInterTransferRelationModel.h"
#import "PNViewModel.h"
NS_ASSUME_NONNULL_BEGIN


@interface PNAddAndEditReciverInfoViewModel : PNViewModel
///  表单数据源
@property (strong, nonatomic) NSMutableArray<HDTableViewSectionModel *> *dataArr;
/// 关系列表
@property (strong, nonatomic) NSArray<PNInterTransferRelationModel *> *relationList;
/// 表单上传模型
@property (strong, nonatomic) PNInterTransferReciverModel *uploadModel;
/// 刷新标记
@property (nonatomic, assign) BOOL refreshFlag;
/// 报错按钮是否可点击
@property (nonatomic, assign) BOOL saveBtnEnabled;
/// 是否是编辑模式
@property (nonatomic, assign) BOOL isEditStyle;

@property (nonatomic, assign) PNInterTransferThunesChannel channel;

/// 删除或者保存收款人后 回调给上个页面
@property (nonatomic, copy) void (^callBack)(void);

/// 初始化数据
- (void)initDataArr;

/// 查询关系列表
- (void)queryRelationList;

/// 保存或者更新收款人
- (void)saveOrUpdateReciverInfoToServiceCompletion:(void (^)(void))completion;

/// 删除收款人
- (void)deleteReciverInfoToServiceCompletion:(void (^)(void))completion;
@end

NS_ASSUME_NONNULL_END
