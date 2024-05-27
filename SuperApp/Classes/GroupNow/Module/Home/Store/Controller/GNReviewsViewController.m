//
//  GNReviewsViewController.m
//  SuperApp
//
//  Created by wmz on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "GNReviewsViewController.h"
#import "GNStoreDetailViewModel.h"


@interface GNReviewsViewController ()
/// viewModel
@property (nonatomic, strong) GNStoreDetailViewModel *viewModel;
///门店id
@property (nonatomic, copy) NSString *storeNo;
///商品id
@property (nonatomic, copy) NSString *productCode;

@end


@implementation GNReviewsViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    if (self = [super initWithRouteParameters:parameters]) {
        self.storeNo = parameters[@"storeNo"];
        self.productCode = parameters[@"productCode"];
    }
    return self;
}

- (void)hd_setupNavigation {
    [super hd_setupNavigation];
    self.boldTitle = GNLocalizedString(@"gn_reviews", @"Reviews");
}

- (void)hd_setupViews {
    [super hd_setupViews];
    self.tableView.delegate = self.tableView.provider;
    self.tableView.dataSource = self.tableView.provider;
}

- (void)gn_getNewData {
    @HDWeakify(self);
    [self.viewModel getStoreReviewStoreNo:self.storeNo productCode:self.productCode pageNum:self.tableView.pageNum completion:^(GNCommentPagingRspModel *_Nonnull rspModel, BOOL error) {
        @HDStrongify(self);
        if (!error) {
            NSMutableArray *sectionArr = NSMutableArray.new;
            for (GNCommentModel *commentModel in rspModel.list) {
                [sectionArr addObject:addSection(^(GNSectionModel *_Nonnull sectionModel) {
                                sectionModel.headerHeight = kRealWidth(12);
                                sectionModel.headerModel.backgroundColor = HDAppTheme.color.gn_mainBgColor;
                                [sectionModel.rows addObject:commentModel];
                            })];
            }
            if (self.tableView.pageNum > 1) {
                [self.dataSource addObjectsFromArray:sectionArr];
            } else {
                self.dataSource = [NSMutableArray arrayWithArray:sectionArr];
            }
        }
        self.tableView.GNdelegate = self;
        !error ? [self.tableView reloadData:!rspModel.hasNextPage] : [self.tableView reloadFail];
    }];
}

- (void)respondEvent:(NSObject<GNEvent> *)event {
    [super respondEvent:event];
    ///点击评论商品
    if ([event.key isEqualToString:@"commentProduct"]) {
        GNProductModel *model = event.info[@"data"];
        if ([model isKindOfClass:GNProductModel.class]) {
            [HDMediator.sharedInstance navigaveToGNStoreProductViewController:@{@"storeNo": self.storeNo, @"productCode": model.productCode, @"fromOrder": @"bugAgain"}];
        }
    }
}

- (NSArray<GNSectionModel *> *)numberOfSectionsInGNTableView:(GNTableView *)tableView {
    return self.dataSource;
}

- (GNStoreDetailViewModel *)viewModel {
    return _viewModel ?: ({ _viewModel = GNStoreDetailViewModel.new; });
}

@end
