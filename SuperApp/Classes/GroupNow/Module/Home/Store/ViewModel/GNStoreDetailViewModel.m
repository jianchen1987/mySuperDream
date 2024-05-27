//
//  GNStoreDetailViewModel.m
//  SuperApp
//
//  Created by wmz on 2022/6/6.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNStoreDetailViewModel.h"
#import "GNHomeDTO.h"


@interface GNStoreDetailViewModel ()
/// DTO
@property (nonatomic, strong) GNHomeDTO *homeDTO;
/// 队列组
@property (nonatomic, strong) dispatch_group_t taskGroup;
/// 评论
@property (nonatomic, strong, nullable) GNCommentPagingRspModel *commentPagingRspModel;

@end


@implementation GNStoreDetailViewModel

/// 详情
- (void)getStoreDetailStoreNo:(nonnull NSString *)storeNO productCode:(nullable NSString *)productCode {
    @HDWeakify(self)
        ///详情
        dispatch_group_enter(self.taskGroup);
    [self.homeDTO merchantDetailStoreNo:storeNO productCode:productCode success:^(GNStoreDetailModel *_Nonnull detailModel) {
        @HDStrongify(self) self.detailModel = detailModel;
        dispatch_group_leave(self.taskGroup);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self) self.detailModel = nil;
        dispatch_group_leave(self.taskGroup);
    }];

    ///评论
    dispatch_group_enter(self.taskGroup);
    [self getStoreReviewStoreNo:storeNO productCode:nil pageNum:1 completion:^(GNCommentPagingRspModel *_Nonnull rspModel, BOOL error) {
        @HDStrongify(self) self.commentPagingRspModel = rspModel;
        dispatch_group_leave(self.taskGroup);
    }];

    dispatch_group_notify(self.taskGroup, dispatch_get_main_queue(), ^() {
        [self.dataSource removeAllObjects];
        if (self.detailModel) {
            if ([self.detailModel.storeStatus.codeId isEqualToString:GNStoreStatusOpening] && [self.detailModel.businessStatus.codeId isEqualToString:GNStoreBusnessTypeOpen]) {
                /// head
                [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                     GNCellModel *model = [GNCellModel createClass:@"GNStoreDetailHeadCell"];
                                     model.businessData = self.detailModel;
                                     [sectionModel.rows addObject:model];
                                     sectionModel.footerHeight = kRealWidth(12);
                                     sectionModel.footerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;
                                 })];

                ///商品列表
                [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                     sectionModel.footerHeight = kRealWidth(12);
                                     sectionModel.footerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;
                                     GNCellModel *model = [GNCellModel createClass:@"GNStoreDetailSectionView"];
                                     model.title = GNLocalizedString(@"gn_offers", @"Offers");
                                     [sectionModel.rows addObject:model];
                                     if (self.detailModel.productList.count) {
                                         for (GNProductModel *product in self.detailModel.productList) {
                                             GNCellModel *model = [GNCellModel createClass:@"GNStoreDetailProductTableViewCell"];
                                             model.businessData = product;
                                             [sectionModel.rows addObject:model];
                                         }
                                     } else {
                                         GNCellModel *model = [GNCellModel createClass:@"GNStroreNoDataCell"];
                                         model.image = [UIImage imageNamed:@"gn_store_nodata"];
                                         model.title = GNLocalizedString(@"gn_store_noProduct", @"该商家还没有上架商品！");
                                         model.backgroundColor = UIColor.whiteColor;
                                         [sectionModel.rows addObject:model];
                                     }
                                 })];

                ///相册
                [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                     sectionModel.footerHeight = kRealWidth(12);
                                     sectionModel.footerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;
                                     ///头部
                                     GNCellModel *model = [GNCellModel createClass:@"GNStoreDetailSectionView"];
                                     model.title = GNLocalizedString(@"gn_photos", @"Photos");
                                     if (self.detailModel.storeAllPhotoArr.count > 3) {
                                         model.detail = [NSString stringWithFormat:GNLocalizedString(@"gn_sheet_photos", @"View %d Photos"), self.detailModel.storeAllPhotoArr.count];
                                         model.tag = @"photos";
                                     }
                                     [sectionModel.rows addObject:model];

                                     model = [GNCellModel createClass:@"GNStoreDetailPhotoCell"];
                                     ///获取相册前三张
                                     NSMutableArray *marr = NSMutableArray.new;
                                     for (NSString *str in self.detailModel.storeAllPhotoArr) {
                                         if (marr.count < 3) {
                                             [marr addObject:str];
                                         }
                                     }
                                     model.businessData = marr;
                                     [sectionModel.rows addObject:model];
                                 })];

                ///商家介绍
                [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                     sectionModel.footerHeight = kRealWidth(12);
                                     sectionModel.footerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;

                                     GNCellModel *model = [GNCellModel createClass:@"GNStoreDetailSectionView"];
                                     model.title = GNLocalizedString(@"gn_merchant_introduction", @"商家介绍");
                                     [sectionModel.rows addObject:model];
                                     if (!HDIsArrayEmpty(self.detailModel.storeIntroducePhotoArr) || GNStringNotEmpty(self.detailModel.storeIntroduce.desc)) {
                                         model = [GNCellModel createClass:@"GNStoreDetailIntroductionCell"];
                                         model.title = self.detailModel.storeIntroduce.desc;
                                         model.imageTitle = self.detailModel.storeIntroducePhotoArr.firstObject;
                                         model.dataSource = self.detailModel.storeIntroducePhotoArr;
                                         [sectionModel.rows addObject:model];
                                     }
                                 })];

                ///有评论
                if (self.commentPagingRspModel && !HDIsArrayEmpty(self.commentPagingRspModel.list)) {
                    [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                         GNCellModel *model = [GNCellModel createClass:@"GNStoreDetailSectionView"];
                                         model.title = GNLocalizedString(@"gn_reviews", @"Reviews");

                                         model.detail = [NSString stringWithFormat:GNLocalizedString(@"gn_sheet_reviews", @"View %d Reviews"), self.commentPagingRspModel.total];
                                         model.tag = @"reviews";
                                         [sectionModel.rows addObject:model];

                                         int num = 0;
                                         for (GNCommentModel *commonModel in self.commentPagingRspModel.list) {
                                             ///隐藏图片
                                             commonModel.imageHide = YES;
                                             ///隐藏商家回复
                                             commonModel.imageLeft = YES;
                                             [sectionModel.rows addObject:commonModel];
                                             num++;
                                             if (num >= 3)
                                                 break;
                                         }
                                         if (self.commentPagingRspModel.list.count > 0) {
                                             GNCellModel *model = [GNCellModel createClass:@"GNCommonBTNCell"];
                                             model.title = GNLocalizedString(@"gn_view_more", @"View Reviews");
                                             model.titleFont = [HDAppTheme.font boldForSize:14];
                                             model.nameColor = HDAppTheme.color.gn_999Color;
                                             ////圆角
                                             model.offset = kRealWidth(4);
                                             model.outInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(16), kRealWidth(12));
                                             model.innerInsets = UIEdgeInsetsMake(kRealWidth(10), 0, kRealWidth(10), 0);
                                             [sectionModel.rows addObject:model];
                                         }
                                     })];
                } else {
                    ///没有评论
                    [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                         GNCellModel *model = [GNCellModel createClass:@"GNStoreDetailSectionView"];
                                         model.title = GNLocalizedString(@"gn_reviews", @"Reviews");
                                         [sectionModel.rows addObject:model];

                                         model = [GNCellModel createClass:@"GNStroreNoDataCell"];
                                         model.image = [UIImage imageNamed:@"gn_store_nocomment"];
                                         model.title = GNLocalizedString(@"gn_no_reviews", @"这里还没有点评");
                                         model.backgroundColor = UIColor.whiteColor;
                                         [sectionModel.rows addObject:model];
                                     })];
                }
            }
        }
        self.refreshFlag = !self.refreshFlag;
    });
}

- (void)getStoreReviewStoreNo:(nonnull NSString *)storeNO
                  productCode:(nullable NSString *)productCode
                      pageNum:(NSInteger)pageNum
                   completion:(nullable void (^)(GNCommentPagingRspModel *rspModel, BOOL error))completion {
    [self.homeDTO productReviewListWithStoreNo:storeNO productCode:productCode pageNum:pageNum success:^(BOOL result, GNCommentPagingRspModel *_Nonnull rspModel) {
        if (!result) {
            [rspModel.list enumerateObjectsUsingBlock:^(GNCommentModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                obj.notCacheHeight = YES;
                obj.cellClass = NSClassFromString(@"GNCommentCell");
                if (GNStringNotEmpty(obj.reviewPhoto)) {
                    if ([obj.reviewPhoto containsString:@","]) {
                        obj.dataSource = [obj.reviewPhoto componentsSeparatedByString:@","];
                    } else {
                        obj.dataSource = @[obj.reviewPhoto];
                    }
                }
            }];
        }
        !completion ?: completion(rspModel, result);
    }];
}

- (NSMutableArray<GNSectionModel *> *)dataSource {
    if (!_dataSource) {
        _dataSource = NSMutableArray.new;
    }
    return _dataSource;
}

- (GNHomeDTO *)homeDTO {
    if (!_homeDTO) {
        _homeDTO = GNHomeDTO.new;
    }
    return _homeDTO;
}

- (dispatch_group_t)taskGroup {
    return _taskGroup ?: ({ _taskGroup = dispatch_group_create(); });
}

@end
