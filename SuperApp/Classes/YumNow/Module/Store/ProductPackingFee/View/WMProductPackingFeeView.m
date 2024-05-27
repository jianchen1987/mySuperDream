//
//  WMProductPackingFeeView.m
//  SuperApp
//
//  Created by VanJay on 2020/6/27.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "WMProductPackingFeeView.h"
#import "GNTableView.h"
#import "WMProductPackingFeeTableViewCell.h"
#import "WMProductPackingFeeViewModel.h"


@interface WMProductPackingFeeView () <GNTableViewProtocol>
/// VM
@property (nonatomic, strong) WMProductPackingFeeViewModel *viewModel;
/// 列表
@property (nonatomic, strong) GNTableView *tableView;
/// 数据源
@property (nonatomic, strong) GNSectionModel *sectionModel;

@end


@implementation WMProductPackingFeeView
#pragma mark - SAViewProtocol
- (void)hd_setupViews {
    self.backgroundColor = self.tableView.backgroundColor;
    [self addSubview:self.tableView];
}

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_bindViewModel {
    self.sectionModel = addSection(^(GNSectionModel *_Nonnull sectionModel) {
        sectionModel.cornerRadios = kRealWidth(9);

        NSArray *productArr = [self.viewModel.productList hd_filterWithBlock:^BOOL(WMShoppingCartPayFeeCalProductModel *_Nonnull item) {
            return item.packageFee.cent.doubleValue > 0;
        }];

        NSMutableArray *resultArr = [NSMutableArray array];
        NSMutableSet *groupNoSet = [NSMutableSet set];
        [productArr enumerateObjectsUsingBlock:^(WMShoppingCartPayFeeCalProductModel *obj, NSUInteger idx, BOOL *_Nonnull stop) {
            [groupNoSet addObject:obj.productId];
        }];
        [groupNoSet enumerateObjectsUsingBlock:^(NSString *groupNo, BOOL *_Nonnull stop) {
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productId = %@", groupNo]; //创建谓词筛选器
            NSArray *group = [productArr filteredArrayUsingPredicate:predicate];
            if (group.count != 0)
                [resultArr addObject:group];
        }];

        for (NSArray<WMShoppingCartPayFeeCalProductModel *> *arr in resultArr) {
            WMShoppingCartPayFeeCalProductModel *pro = WMShoppingCartPayFeeCalProductModel.new;
            pro.productId = arr.firstObject.productId;
            pro.name = arr.firstObject.name;
            pro.packageFee = arr.firstObject.packageFee;
            pro.packageShare = arr.firstObject.packageShare;
            int count = 0;
            for (WMShoppingCartPayFeeCalProductModel *pr in arr) {
                count += pr.count;
            }
            pro.count = count;
            GNCellModel *cellModel = GNCellModel.new;
            cellModel.cellClass = WMProductPackingFeeTableViewCell.class;
            cellModel.businessData = pro;
            [sectionModel.rows addObject:cellModel];
        }

        ///打包费
        if (self.viewModel.packingFee && self.viewModel.packingFee.cent.integerValue) {
            GNCellModel *cellModel = GNCellModel.new;
            cellModel.cellClass = NSClassFromString(@"WMProductBoxFeeTableViewCell");
            cellModel.businessData = self.viewModel.packingFee;
            [sectionModel.rows addObject:cellModel];
        }
    });
    [self.tableView reloadData:true];
}

- (NSArray<GNSectionModel *> *)numberOfSectionsInGNTableView:(GNTableView *)tableView {
    return @[self.sectionModel];
}

#pragma mark - layout
- (void)updateConstraints {
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kRealWidth(8));
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(kRealWidth(10));
        make.right.mas_equalTo(kRealWidth(-10));
    }];
    [super updateConstraints];
}

#pragma mark - lazy load
- (GNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[GNTableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.GNdelegate = self;
    }
    return _tableView;
}
@end
