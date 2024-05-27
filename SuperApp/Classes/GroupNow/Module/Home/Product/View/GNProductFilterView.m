//
//  GNProductFilterView.m
//  SuperApp
//
//  Created by wmz on 2021/7/15.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "GNProductFilterView.h"


@interface GNProductFilterView () <UITableViewDelegate, UITableViewDataSource>
/// 全部产品
@property (nonatomic, strong) HDLabel *nameLB;
/// 关闭
@property (nonatomic, strong) HDUIButton *closeBTN;

@end


@implementation GNProductFilterView

- (void)hd_setupViews {
    [self addSubview:self.shadomView];
    [self addSubview:self.dataView];
    [self.dataView addSubview:self.headView];
    [self.headView addSubview:self.nameLB];
    [self.headView addSubview:self.closeBTN];
    [self.dataView addSubview:self.tableView];
}

- (void)updateConstraints {
    [self.shadomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(kRealHeight(40));
    }];

    [self.nameLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(HDAppTheme.value.gn_marginL);
        make.centerY.mas_equalTo(0);
    }];

    [self.closeBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-HDAppTheme.value.gn_marginL);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(kRealHeight(30), kRealHeight(30)));
    }];

    [super updateConstraints];
}

- (void)setDataSource:(NSArray<GNProductModel *> *)dataSource {
    _dataSource = dataSource;
    self.nameLB.text = GNLocalizedString(@"gn_product_all", @"全部产品");
    CGFloat height = MIN(dataSource.count * kRealHeight(40), kRealHeight(320));
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.headView.mas_bottom);
        make.height.mas_equalTo(height + kRealHeight(20));
    }];
    self.normalRect = CGRectMake(0, 0, kScreenWidth, height + kRealHeight(60));
    self.dataView.frame = self.normalRect;
    [self.tableView updateUI];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GNFilterTextCell *cell = [GNFilterTextCell cellWithTableView:tableView];
    [cell setGNModel:self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataSource enumerateObjectsUsingBlock:^(GNProductModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        obj.select = (indexPath.row == idx);
    }];
    [self.tableView updateUI];
    [self dissmiss];
    [GNEvent eventResponder:self target:self key:@"filterSelectAction" indexPath:indexPath];
}

- (void)show:(UIView *)parentView {
    if (self.isShow)
        return;
    [parentView addSubview:self];
    [self.tableView updateUI];
    self.shadomView.alpha = 0;
    CGRect rect = self.normalRect;
    self.dataView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 0);
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.dataView.frame = rect;
        self.shadomView.alpha = 0.4;
    } completion:^(BOOL finished) {
        self.show = YES;
    }];
    if (self.viewWillAppear) {
        self.viewWillAppear(self);
    }
}

- (void)dissmiss {
    if (!self.isShow)
        return;
    self.shadomView.alpha = 0.4;
    CGRect rect = self.dataView.frame;
    rect.size.height = 0;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.dataView.frame = rect;
        self.shadomView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.show = NO;
    }];
    if (self.viewWillDisappear) {
        self.viewWillDisappear(self);
    }
}

- (UIView *)headView {
    if (!_headView) {
        _headView = UIView.new;
        _headView.backgroundColor = HDAppTheme.color.gn_whiteColor;
    }
    return _headView;
}

- (GNTableView *)tableView {
    if (!_tableView) {
        _tableView = [[GNTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.bounces = NO;
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (HDLabel *)nameLB {
    if (!_nameLB) {
        _nameLB = HDLabel.new;
        _nameLB.font = [HDAppTheme.font gn_boldForSize:16];
    }
    return _nameLB;
}

- (HDUIButton *)closeBTN {
    if (!_closeBTN) {
        _closeBTN = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_closeBTN setImage:[UIImage imageNamed:@"gn_store_product_close"] forState:UIControlStateNormal];
        @HDWeakify(self);
        [_closeBTN addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dissmiss];
        }];
    }
    return _closeBTN;
}

- (UIView *)shadomView {
    if (!_shadomView) {
        _shadomView = UIView.new;
        _shadomView.backgroundColor = HDAppTheme.color.gn_333Color;
        UITapGestureRecognizer *ta = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmiss)];
        [_shadomView addGestureRecognizer:ta];
    }
    return _shadomView;
}

- (UIView *)dataView {
    if (!_dataView) {
        _dataView = UIView.new;
        _dataView.clipsToBounds = YES;
        _dataView.backgroundColor = HDAppTheme.color.gn_whiteColor;
    }
    return _dataView;
}

@end


@interface GNFilterTextCell ()
///文字
@property (nonatomic, strong) HDLabel *leftLB;

@end


@implementation GNFilterTextCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.leftLB];
}

- (void)updateConstraints {
    [self.leftLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-HDAppTheme.value.gn_marginL);
        make.left.mas_offset(HDAppTheme.value.gn_marginL);
        make.top.mas_offset(HDAppTheme.value.gn_marginT);
        make.bottom.mas_offset(-HDAppTheme.value.gn_marginT);
    }];
    [super updateConstraints];
}

- (void)setGNModel:(GNProductModel *)data {
    self.leftLB.textColor = data.isSelected ? HDAppTheme.color.gn_mainColor : HDAppTheme.color.gn_333Color;
    self.leftLB.text = GNFillEmpty(data.name.desc);
    self.leftLB.font = data.titleFont;
}

- (HDLabel *)leftLB {
    if (!_leftLB) {
        _leftLB = HDLabel.new;
        _leftLB.numberOfLines = 0;
    }
    return _leftLB;
}

@end
