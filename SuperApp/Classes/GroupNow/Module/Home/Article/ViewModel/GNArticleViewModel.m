//
//  GNArticleViewModel.m
//  SuperApp
//
//  Created by wmz on 2022/5/31.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNArticleViewModel.h"


@interface GNArticleViewModel ()

@property (nonatomic, strong) GNArticleDTO *homeDTO;

@end


@implementation GNArticleViewModel

- (void)getAritcleDetailWithCode:(NSString *)code completion:(nullable void (^)(GNArticleModel *rspModel, BOOL error))completion {
    @HDWeakify(self)[self.homeDTO getArticleDetailWithCode:code success:^(GNArticleModel *_Nonnull rspModel) {
        @HDStrongify(self) self.detailDataSource = NSMutableArray.new;
        if (rspModel) {
            ///文章详情
            [self.detailDataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                       GNCellModel *model = [GNCellModel createClass:@"GNArticleDetailContentCell"];
                                       model.notCacheHeight = YES;
                                       model.businessData = rspModel;
                                       [sectionModel.rows addObject:model];
                                   })];
            ///商品
            if ([rspModel.boundType.codeId isEqualToString:GNHomeArticleBindProduct] && rspModel.articleProductInfo) {
                [self.detailDataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                           GNCellModel *model = [GNCellModel createClass:@"GNArticleDetailProductCell"];
                                           rspModel.articleProductInfo.imageHide = YES;
                                           model.businessData = rspModel.articleProductInfo;
                                           [sectionModel.rows addObject:model];
                                           sectionModel.headerHeight = kRealWidth(8);
                                           sectionModel.headerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;
                                       })];
            }
            ///门店
            else if ([rspModel.boundType.codeId isEqualToString:GNHomeArticleBindStore] && rspModel.articleStoreInfo) {
                [self.detailDataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                           GNCellModel *model = [GNCellModel createClass:@"GNArticleDetailStoreCell"];
                                           model.businessData = rspModel.articleStoreInfo;
                                           [sectionModel.rows addObject:model];
                                           sectionModel.headerHeight = kRealWidth(8);
                                           sectionModel.headerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;
                                       })];
            }
            ///其他类型
            else if (rspModel.boundType && HDIsStringNotEmpty(rspModel.boundImage)) {
                [self.detailDataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                           GNCellModel *model = [GNCellModel createClass:@"GNArticleDetailBindCell"];
                                           model.businessData = rspModel;
                                           [sectionModel.rows addObject:model];
                                           sectionModel.headerHeight = kRealWidth(8);
                                           sectionModel.headerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;
                                       })];
            }
            ///作者
            [self.detailDataSource addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                       GNCellModel *model = [GNCellModel createClass:@"GNArticleDetailAuthorCell"];
                                       model.businessData = rspModel;
                                       [sectionModel.rows addObject:model];
                                       sectionModel.headerHeight = kRealWidth(8);
                                       sectionModel.headerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;
                                   })];
        }
        !completion ?: completion(rspModel, rspModel ? NO : YES);
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self) self.detailDataSource = NSMutableArray.new;
        !completion ?: completion(nil, YES);
    }];
}

- (GNArticleDTO *)homeDTO {
    if (!_homeDTO) {
        _homeDTO = GNArticleDTO.new;
    }
    return _homeDTO;
}

@end
