//
//  TNOrderListViewModel.m
//  SuperApp
//
//  Created by 张杰 on 2022/3/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNOrderListViewModel.h"
#import "SAPaymentDTO.h"
#import "TNOrderDTO.h"
#import "TNOrderListMoreProductCell.h"
#import "TNOrderListSingleProductCell.h"
#import "TNStoreDTO.h"
#import "TNStoreInfoRspModel.h"


@interface TNOrderListViewModel ()
///
@property (strong, nonatomic) TNOrderDTO *orderDTO;
/// 支付状态查询DTO
@property (nonatomic, strong) SAPaymentDTO *paymentStateDTO;
///< 门店DTO
@property (nonatomic, strong) TNStoreDTO *storeDTO;
@end


@implementation TNOrderListViewModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.pageSize = 20;
        self.currentPage = 1;
    }
    return self;
}
- (void)getNewData {
    self.currentPage = 1;
    [self queryOrderListDataWithPageNum:self.currentPage];
}
- (void)loadMoreData {
    self.currentPage += 1;
    [self queryOrderListDataWithPageNum:self.currentPage];
}

- (void)queryOrderListDataWithPageNum:(NSInteger)pageNum {
    @HDWeakify(self);
    [self.orderDTO queryOrderListDataWithOperateNo:[SAUser shared].operatorNo state:self.state pageSize:self.pageSize pageNum:pageNum success:^(TNOrderListRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        if (self.currentPage == 1) {
            [self.dataSource removeAllObjects];
        }
        self.hasNextPage = rspModel.hasNextPage;
        if (!HDIsArrayEmpty(rspModel.list)) {
            [self processOrdersDataWithRspModel:rspModel];
        }
        //更正页码
        if (self.pageSize > 20) {
            self.currentPage = self.pageSize / 20;
            self.pageSize = 20;
        }
        self.refreshFlag = !self.refreshFlag;
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        !self.failedGetDataBlock ?: self.failedGetDataBlock();
    }];
}
- (void)processOrdersDataWithRspModel:(TNOrderListRspModel *)rspModel {
    for (TNOrderModel *model in rspModel.list) {
        if (model.orderItems.count > 3) {
            //多余三条数据展示
            TNOrderListMoreProductCellModel *cellModel = [[TNOrderListMoreProductCellModel alloc] init];
            cellModel.orderModel = model;
            cellModel.productPicArr = [model.orderItems mapObjectsUsingBlock:^id _Nonnull(TNOrderProductItemModel *_Nonnull obj, NSUInteger idx) {
                return obj.thumbnail;
            }];
            [self.dataSource addObject:cellModel];
        } else {
            TNOrderListSingleProductCellModel *cellModel = [[TNOrderListSingleProductCellModel alloc] init];
            cellModel.orderModel = model;
            [self.dataSource addObject:cellModel];
        }
    }
}
- (void)confirmOrderWithOrderNo:(NSString *)orderNo completion:(void (^)(void))completion {
    [self.view showloading];
    @HDWeakify(self);
    [self.orderDTO confirmOrderWithOrderNo:orderNo success:^{
        @HDStrongify(self);
        [self.view dismissLoading];
        !completion ?: completion();
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}
- (void)queryOrderPaymentStateWithOrderNo:(NSString *)orderNo completion:(void (^)(SAQueryPaymentStateRspModel *_Nullable))completion {
    [self.view showloading];
    @HDWeakify(self);
    [self.paymentStateDTO queryOrderPaymentStateWithOrderNo:orderNo success:^(SAQueryPaymentStateRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !completion ?: completion(rspModel);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !completion ?: completion(nil);
    }];
}
- (void)cancelOrderWithOrderNo:(NSString *)orderNo completion:(void (^)(void))completion {
    [self.view showloading];
    @HDWeakify(self);
    [self.orderDTO cancelOrderWithOrderNo:orderNo success:^{
        @HDStrongify(self);
        [self.view dismissLoading];
        !completion ?: completion();
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}
- (void)rebuymOrderWithOrderNo:(NSString *)orderNo completion:(void (^)(NSArray *_Nonnull))completion {
    [self.view showloading];
    @HDWeakify(self);
    [self.orderDTO rebuyOrderWithOrderNo:orderNo success:^(NSArray *_Nonnull skuIds) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !completion ?: completion(skuIds);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}
- (void)nearBuyOrderWithOrderNo:(NSString *)orderNo completion:(void (^)(NSString *_Nonnull))completion {
    [self.view showloading];
    @HDWeakify(self);
    [self.orderDTO queryNearByRouteWithOrderNo:orderNo storeNo:orderNo success:^(NSString *_Nullable route) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !completion ?: completion(route);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)createOutPayOrderNoWithOrderNo:(NSString *)orderNo completion:(void (^)(NSString *_Nonnull))completion {
    [self.view showloading];
    @HDWeakify(self);
    NSString *returnUrl = [NSString stringWithFormat:@"SuperApp://SuperApp/CashierResult?businessLine=%@&orderNo=", SAClientTypeTinhNow];
    [self.orderDTO createPayOrderWithReturnUrl:returnUrl orderNo:orderNo success:^(NSString *_Nonnull outPayOrderNo) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !completion ?: completion(outPayOrderNo);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

- (void)queryStoreDetailWithStoreNo:(NSString *)storeNo completion:(void (^)(NSString *merchantNo))completion {
    [self.view showloading];
    @HDWeakify(self);
    [self.storeDTO queryStoreInfoWithStoreNo:storeNo operatorNo:SAUser.shared.operatorNo success:^(TNStoreInfoRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self.view dismissLoading];
        !completion ?: completion(rspModel.merchantNo);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self.view dismissLoading];
    }];
}

/** @lazy orderDTO */
- (TNOrderDTO *)orderDTO {
    if (!_orderDTO) {
        _orderDTO = [[TNOrderDTO alloc] init];
    }
    return _orderDTO;
}
/** @lazy dataSource */
- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
- (SAPaymentDTO *)paymentStateDTO {
    if (!_paymentStateDTO) {
        _paymentStateDTO = [[SAPaymentDTO alloc] init];
    }
    return _paymentStateDTO;
}

/** @lazy storeDTO */
- (TNStoreDTO *)storeDTO {
    if (!_storeDTO) {
        _storeDTO = [[TNStoreDTO alloc] init];
    }
    return _storeDTO;
}

@end
