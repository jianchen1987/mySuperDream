//
//  SASearchViewModel.h
//  SuperApp
//
//  Created by Tia on 2022/12/13.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "SAAddressModel.h"
#import "SAImageLabelCollectionViewCellModel.h"
#import "SAViewModel.h"
#import "SASearchAssociateModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface SASearchViewModel : SAViewModel
/// address
@property (nonatomic, strong) SAAddressModel *currentlyAddress;
/// 关键字
@property (nonatomic, copy) NSString *keyword;
/// 数据源
@property (nonatomic, strong) NSMutableArray<HDTableViewSectionModel *> *dataSource; ///< 默认数据源
/// 刷新标志
@property (nonatomic, assign, readonly) BOOL refreshFlag;
/// 获取历史搜索记录
- (void)loadDefaultData;

/// 获取搜索排行 和 搜索发现 数据
- (void)getSearchRankAndDiscoveryData;

/// 记录搜索记录
/// - Parameter keyword: 关键字
- (void)saveMerchantHistorySearchWithKeyword:(NSString *)keyword;

/// 清除搜索记录
- (void)removeAllHistorySearch;

- (CMNetworkRequest *)getAssociateSearchKeyword:(NSString *)keyword success:(void (^)(NSArray<SASearchAssociateModel *> *list))successBlock failure:(CMNetworkFailureBlock)failureBlock;

///获取联想词停顿时间
- (void)getSystemConfigWithKey:(NSString *)key success:(void (^)(NSString *value))successBlock failure:(CMNetworkFailureBlock)failureBlock;

///获取搜索下标数
- (void)searchWithKeyWord:(NSString *_Nonnull)keyWord
                 complete:(void (^)(NSArray *))complete;

@end

NS_ASSUME_NONNULL_END
