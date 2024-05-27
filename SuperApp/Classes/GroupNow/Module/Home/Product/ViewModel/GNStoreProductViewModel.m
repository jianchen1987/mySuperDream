//
//  GNStoreProductViewModel.m
//  SuperApp
//
//  Created by wmz on 2021/6/3.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNStoreProductViewModel.h"
#import "GNHomeDTO.h"


@interface GNStoreProductViewModel ()
///网络请求
@property (nonatomic, strong) GNHomeDTO *homeDTO;

@end


@implementation GNStoreProductViewModel

/// 产品详情
- (void)getProductDetailStoreNo:(nonnull NSString *)code completion:(nullable void (^)(void))completion {
    [self.homeDTO productGetDetailRequestCode:code success:^(GNProductModel *_Nonnull rspModel) {
        self.productModel = rspModel;
        self.dataSource = NSMutableArray.new;

        ///头部
        [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                             GNCellModel *model = [GNCellModel createClass:@"GNStoreProductHeadCell"];
                             model.businessData = rspModel;
                             [sectionModel.rows addObject:model];
                         })];

        ///使用流程
        [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                             GNCellModel *model = [GNCellModel createClass:@"GNOrderTitleSectionTitleCell"];
                             model.title = GNLocalizedString(@"gn_process_using", @"使用流程");
                             [sectionModel.rows addObject:model];

                             GNCellModel *cellModel = GNCellModel.new;
                             cellModel.cellClass = NSClassFromString(@"GNGroupTextCell");
                             cellModel.bottomOffset = kRealWidth(16);
                             cellModel.offset = kRealWidth(4);
                             if ([rspModel.type.codeId isEqualToString:GNProductTypeP1]) {
                                 cellModel.title = GNLocalizedString(@"gn_pr_useProcess", @"gn_qr_useProcess");
                             } else {
                                 cellModel.title = GNLocalizedString(@"gn_qr_useProcess", @"gn_qr_useProcess");
                             }
                             [sectionModel.rows addObject:cellModel];
                             sectionModel.headerHeight = kRealWidth(8);
                             sectionModel.headerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;
                         })];

        ///内容
        if ([rspModel.type.codeId isEqualToString:GNProductTypeP1]) {
            [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                 GNCellModel *model = [GNCellModel createClass:@"GNOrderTitleSectionTitleCell"];
                                 model.title = GNLocalizedString(@"gn_product_content", @"内容");
                                 [sectionModel.rows addObject:model];

                                 GNCellModel *cellModel = GNCellModel.new;
                                 cellModel.cellClass = NSClassFromString(@"GNGroupTextCell");
                                 cellModel.bottomOffset = kRealWidth(16);
                                 cellModel.offset = kRealWidth(4);
                                 cellModel.title = GNFillEmpty(rspModel.content.desc);
                                 [sectionModel.rows addObject:cellModel];
                                 sectionModel.headerHeight = kRealWidth(8);
                                 sectionModel.headerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;
                             })];
        }

        ///使用商家
        [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                             GNCellModel *model = [GNCellModel createClass:@"GNOrderTitleSectionTitleCell"];
                             model.title = GNLocalizedString(@"gn_product_store", @"使用商家");
                             model.outInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(8), kRealWidth(12));
                             [sectionModel.rows addObject:model];

                             GNCellModel *cellModel = GNCellModel.new;
                             cellModel.cellClass = NSClassFromString(@"GNProductStoreCell");
                             cellModel.businessData = rspModel;
                             [sectionModel.rows addObject:cellModel];

                             sectionModel.headerHeight = kRealWidth(8);
                             sectionModel.headerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;
                         })];

        ///购买信息
        [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                             GNCellModel *model = [GNCellModel createClass:@"GNOrderTitleSectionTitleCell"];
                             model.title = GNLocalizedString(@"gn_product_buyKnow", @"信息");
                             [sectionModel.rows addObject:model];

                             ///有效期
                             GNCellModel *cellModel = GNCellModel.new;
                             cellModel.cellClass = NSClassFromString(@"GNStoreProductTextCell");
                             cellModel.image = [UIImage imageNamed:@"gn_product_icon_valid"];
                             cellModel.title = GNLocalizedString(@"gn_product_vaild", @"有效期");
                             if (rspModel.termOfValidityType) {
                                 NSString *beganDate = [SAGeneralUtil getDateStrWithTimeInterval:rspModel.termOfValidityFrom / 1000 format:@"dd/MM/yyyy"];
                                 NSString *endDate = [SAGeneralUtil getDateStrWithTimeInterval:rspModel.termOfValidityTo / 1000 format:@"dd/MM/yyyy"];
                                 cellModel.detail = [NSString stringWithFormat:@"%@ - %@", beganDate, endDate];
                             } else {
                                 cellModel.detail = [NSString stringWithFormat:GNLocalizedString(@"gn_buy_vaildday", @"购买后%ld天有效"), rspModel.termOfValidity];
                             }
                             [sectionModel.rows addObject:cellModel];

                             ///使用时间
                             cellModel = GNCellModel.new;
                             cellModel.cellClass = NSClassFromString(@"GNStoreProductTextCell");
                             cellModel.image = [UIImage imageNamed:@"gn_product_icon_use"];
                             cellModel.title = GNLocalizedString(@"gn_product_useTime", @"使用时间");
                             cellModel.detail = GNFillEmpty(rspModel.useTime.desc);
                             [sectionModel.rows addObject:cellModel];

                             ///适用范围
                             if ([rspModel.type.codeId isEqualToString:GNProductTypeP2]) {
                                 cellModel = GNCellModel.new;
                                 cellModel.cellClass = NSClassFromString(@"GNStoreProductTextCell");
                                 cellModel.image = [UIImage imageNamed:@"gn_product_icon_limit"];
                                 cellModel.title = GNLocalizedString(@"gn_product_limit", @"适用范围");
                                 cellModel.detail = GNFillEmpty(rspModel.applyRange.desc);
                                 [sectionModel.rows addObject:cellModel];
                             }

                             ///使用规则
                             cellModel = GNCellModel.new;
                             cellModel.cellClass = NSClassFromString(@"GNStoreProductTextCell");
                             cellModel.image = [UIImage imageNamed:@"gn_product_icon_rule"];
                             cellModel.title = GNLocalizedString(@"gn_product_regular", @"使用规则");
                             cellModel.lineHidden = YES;
                             cellModel.detail = GNFillEmpty(rspModel.useRules.desc);
                             [sectionModel.rows addObject:cellModel];

                             sectionModel.headerHeight = kRealWidth(8);
                             sectionModel.headerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;
                         })];

        ///用户评价
        [self.dataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                             self.commentHeadModel = [GNCellModel createClass:@"GNOrderTitleSectionTitleCell"];
                             self.commentHeadModel.title = GNLocalizedString(@"gn_user_evaluation", @"用户评价");
                             self.commentHeadModel.outInsets = UIEdgeInsetsMake(kRealWidth(16), kRealWidth(12), kRealWidth(8), kRealWidth(12));
                             [sectionModel.rows addObject:self.commentHeadModel];

                             GNCellModel *model = [GNCellModel createClass:@"GNStroreNoDataCell"];
                             model.image = [UIImage imageNamed:@"gn_store_nocomment"];
                             model.title = GNLocalizedString(@"gn_no_reviews", @"这里还没有点评");
                             model.backgroundColor = UIColor.whiteColor;
                             [sectionModel.rows addObject:model];
                             self.notCommentModel = model;

                             sectionModel.headerHeight = kRealWidth(8);
                             sectionModel.headerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;

                             sectionModel.footerHeight = kRealWidth(8);
                             sectionModel.footerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;
                             self.commentSection = sectionModel;
                         })];

        !completion ?: completion();
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        self.dataSource = NSMutableArray.new;
        !completion ?: completion();
    }];
}

- (void)getStoreReviewStoreNo:(nonnull NSString *)storeNO
                  productCode:(nullable NSString *)productCode
                      pageNum:(NSInteger)pageNum
                   completion:(nullable void (^)(GNCommentPagingRspModel *rspModel, BOOL error))completion {
    [self.homeDTO productReviewListWithStoreNo:storeNO productCode:productCode pageNum:pageNum success:^(BOOL result, GNCommentPagingRspModel *_Nonnull rspModel) {
        if (!result) {
            self.commentHeadModel.title = [GNLocalizedString(@"gn_user_evaluation", @"用户评价") stringByAppendingFormat:@"(%ld)", rspModel.total];
            [rspModel.list enumerateObjectsUsingBlock:^(GNCommentModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                obj.cellClass = NSClassFromString(@"GNCommentCell");
                ///隐藏图片
                obj.imageHide = YES;
                ///隐藏商品
                obj.leftHigh = YES;
                obj.notCacheHeight = YES;
                if (GNStringNotEmpty(obj.reviewPhoto)) {
                    if ([obj.reviewPhoto containsString:@","]) {
                        obj.dataSource = [obj.reviewPhoto componentsSeparatedByString:@","];
                    } else {
                        obj.dataSource = @[obj.reviewPhoto];
                    }
                }
            }];
            if (pageNum == 1) {
                [self.commentSection.rows removeAllObjects];
                [self.commentSection.rows addObject:self.commentHeadModel];
            }
            [self.commentSection.rows addObjectsFromArray:rspModel.list];
            if (self.commentSection.rows.count > 1) {
                if ([self.commentSection.rows indexOfObject:self.notCommentModel] != NSNotFound) {
                    [self.commentSection.rows removeObject:self.notCommentModel];
                }
            } else {
                if ([self.commentSection.rows indexOfObject:self.notCommentModel] == NSNotFound) {
                    [self.commentSection.rows insertObject:self.notCommentModel atIndex:1];
                }
            }
        }
        !completion ?: completion(rspModel, result);
    }];
}

- (GNHomeDTO *)homeDTO {
    if (!_homeDTO) {
        _homeDTO = GNHomeDTO.new;
    }
    return _homeDTO;
}

@end
