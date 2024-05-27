//
//  SAWalletBillListViewModel.m
//  SuperApp
//
//  Created by seeu on 2021/10/21.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAWalletBillListViewModel.h"
#import "SAWalletBillListRspModel.h"
#import "SAWalletBillModel.h"
#import "SAWalletBillTableHeaderViewModel.h"
#import "SAWalletDTO.h"


@interface SAWalletBillListViewModel ()

/// 原始数据源
@property (nonatomic, strong) NSMutableArray<SAWalletBillModel *> *originDataSource;
/// DTO
@property (nonatomic, strong) SAWalletDTO *walletDTO;
@property (nonatomic, assign) NSInteger currentPageNo; ///<

@end


@implementation SAWalletBillListViewModel

- (instancetype)init {
    self = [super init];
    if (self) {
        self.billType = SABillTypeNormal;
    }
    return self;
}

- (void)requestNewDataCompletion:(void (^)(NSError *error, BOOL hasMore, SARspModel *rspModel))completion {
    self.currentPageNo = 1;
    [self getDataForPageNo:self.currentPageNo completion:completion];
}
- (void)loadMoreDataCompletion:(void (^)(NSError *error, BOOL hasMore, SARspModel *rspModel))completion {
    self.currentPageNo += 1;
    [self getDataForPageNo:self.currentPageNo completion:completion];
}

- (void)getDataForPageNo:(NSInteger)pageNo completion:(void (^)(NSError *error, BOOL hasMore, SARspModel *rspModel))completion {
    @HDWeakify(self);
    void (^processBlock)(SAWalletBillListRspModel *rspModel) = ^(SAWalletBillListRspModel *rspModel) {
        @HDStrongify(self);
        self.currentPageNo = rspModel.pageNum;
        NSArray<SAWalletBillModel *> *list = rspModel.list;
        if (pageNo == 1) {
            [self.originDataSource removeAllObjects];
            if (list.count) {
                [self.originDataSource addObjectsFromArray:list];
            }
            [self dealingWithOriginDataSourceCompletion:^{
                completion(nil, rspModel.hasNextPage, nil);
            }];

        } else {
            if (list.count) {
                [self.originDataSource addObjectsFromArray:list];
            }
            [self dealingWithOriginDataSourceCompletion:^{
                completion(nil, rspModel.hasNextPage, nil);
            }];
        }
    };

    if (SABillTypeNormal == self.billType) {
        [self.walletDTO queryWalletBillListWithPageSize:10 pageNum:pageNo success:processBlock failure:^(SARspModel *_Nonnull rspModel, CMResponseErrorType errorType, NSError *_Nonnull error) {
            completion(error, NO, nil);
        }];
    } else {
        [self.walletDTO queryWalletHistoryBillListWithPageSize:10 pageNum:pageNo success:processBlock
                                                       failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
                                                           completion(error, NO, rspModel);
                                                       }];
    }
}

#pragma mark - private methods
/// 异步处理数据
/// @param completion 处理完成
- (void)dealingWithOriginDataSourceCompletion:(void (^)(void))completion {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @autoreleasepool {
            // 获取所有月份（组标题）
            NSArray<NSString *> *monthDateArray = [self.originDataSource valueForKey:@"date"];

            // 月份去重，不改变顺序
            NSMutableArray<NSString *> *filterMonthDateArray = [NSMutableArray arrayWithCapacity:monthDateArray.count];
            for (NSString *monthDate in monthDateArray) {
                if (![filterMonthDateArray containsObject:monthDate]) {
                    [filterMonthDateArray addObject:monthDate];
                }
            }
            [filterMonthDateArray sortWithOptions:NSSortStable usingComparator:^NSComparisonResult(NSString *_Nonnull obj1, NSString *_Nonnull obj2) {
                return [obj2 compare:obj1 options:NSNumericSearch];
            }];
            // 移除原来的数据
            [self.dataSource removeAllObjects];
            [filterMonthDateArray enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                NSMutableArray<SAWalletBillModelDetail *> *monthDetailArray = [NSMutableArray array];
                HDTableViewSectionModel *sectionModel = HDTableViewSectionModel.new;

                SAWalletBillModel *currentMonthBillModel;
                for (SAWalletBillModel *monthBillModel in self.originDataSource) {
                    if ([obj isEqualToString:monthBillModel.date]) {
                        [monthDetailArray addObjectsFromArray:monthBillModel.details];
                        currentMonthBillModel = monthBillModel;
                    }
                }

                // 收入支出
                NSString *spendingStr = [NSString stringWithFormat:SALocalizedString(@"spending_some", @"支出：%@"), currentMonthBillModel.cashOutAmt.thousandSeparatorAmount];
                NSString *middleStr = @" | ";
                NSString *incomeStr = [NSString stringWithFormat:SALocalizedString(@"income_some", @"收入：%@"), currentMonthBillModel.cashInAmt.thousandSeparatorAmount];
                NSString *str = [NSString stringWithFormat:@"%@%@%@", spendingStr, middleStr, incomeStr];

                NSMutableAttributedString *text = [[NSMutableAttributedString alloc]
                    initWithString:str
                        attributes:@{NSFontAttributeName: HDAppTheme.font.standard3, NSForegroundColorAttributeName: idx == 0 ? HDAppTheme.color.G1 : HDAppTheme.color.G3}];
                [text setAttributes:@{NSFontAttributeName: HDAppTheme.font.standard3, NSForegroundColorAttributeName: HDAppTheme.color.G4} range:[str rangeOfString:middleStr]];

                SAWalletBillTableHeaderViewModel *headerModel = SAWalletBillTableHeaderViewModel.new;
                // 判断是否本月
                NSString *nowDateStr = [SAGeneralUtil getDateStrWithDate:NSDate.date format:@"yyyy-MM"];
                if ([nowDateStr isEqualToString:obj]) {
                    headerModel.btnTitle = SALocalizedString(@"this_month", @"本月");
                } else {
                    headerModel.btnTitle = obj;
                }
                headerModel.attrDesc = text;
                sectionModel.list = monthDetailArray;
                sectionModel.commonHeaderModel = headerModel;

                [self.dataSource addObject:sectionModel];
            }];
        }
        dispatch_async(dispatch_get_main_queue(), completion);
    });
}

#pragma mark - lazy load
- (SAWalletDTO *)walletDTO {
    return _walletDTO ?: ({ _walletDTO = SAWalletDTO.new; });
}

- (NSMutableArray<HDTableViewSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray<SAWalletBillModel *> *)originDataSource {
    if (!_originDataSource) {
        _originDataSource = [NSMutableArray array];
    }
    return _originDataSource;
}

@end
