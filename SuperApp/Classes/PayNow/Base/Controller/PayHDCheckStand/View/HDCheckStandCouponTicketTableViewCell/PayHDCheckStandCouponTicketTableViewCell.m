//
//  PayHDCheckstandCouponTicketTableViewCell.m
//  ViPay
//
//  Created by VanJay on 2019/6/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDCheckStandCouponTicketTableViewCell.h"
#import "HDCouponTicketView.h"
#import "Masonry.h"
#import "PayHDCouponTicketCashView.h"


@interface PayHDCheckstandCouponTicketTableViewCell ()
@property (nonatomic, strong) HDCouponTicketView *couponTicketView;            ///< 优惠券
@property (nonatomic, strong) PayHDCouponTicketCashView *couponTicketCashView; ///< 现金券
@property (nonatomic, strong) HDCouponTicketModel *couponTicketModel;          ///< 优惠券模型
@end


@implementation PayHDCheckstandCouponTicketTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 新建标识
    static NSString *ID = @"PayHDCheckstandCouponTicketTableViewCell";

    // 创建cell
    PayHDCheckstandCouponTicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

    if (!cell) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 去除选中样式
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        // 初始化子控件
        [self setupSubViews];
    }
    return self;
}

- (void)setupSubViews {
    if (!self.couponTicketModel)
        return;

    if (self.couponTicketModel.couponType == PNTradePreferentialTypeCash) {
        [self removeCouponTicketView];
        [self addCouponTicketCashView];
    } else {
        [self removeCouponTicketCashView];
        [self addCouponTicketView];
    }
}

- (void)addCouponTicketView {
    if (!_couponTicketView) {
        _couponTicketView = [[HDCouponTicketView alloc] init];
        [self.contentView addSubview:_couponTicketView];
    }
    _couponTicketView.model = self.couponTicketModel;
}

- (void)addCouponTicketCashView {
    if (!_couponTicketCashView) {
        _couponTicketCashView = [[PayHDCouponTicketCashView alloc] init];
        [self.contentView addSubview:_couponTicketCashView];
    }
    _couponTicketCashView.model = self.couponTicketModel;
}

- (void)removeCouponTicketView {
    if (_couponTicketView) {
        [_couponTicketView removeFromSuperview];
        _couponTicketView = nil;
    }
}

- (void)removeCouponTicketCashView {
    if (_couponTicketCashView) {
        [_couponTicketCashView removeFromSuperview];
        _couponTicketCashView = nil;
    }
}

- (void)updateConstraints {
    UIView *contentView = self.couponTicketView ?: self.couponTicketCashView;
    if (!contentView) {
        [super updateConstraints];
        return;
    }

    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).offset(-2 * kRealWidth(15));
        make.centerX.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-kRealWidth(15));
    }];
    [super updateConstraints];
}

#pragma mark - getters and setters
- (void)setModel:(PayHDTradePreferentialModel *)model {
    [super setModel:model];

    self.couponTicketModel = [HDCouponTicketModel modelWithTradePreferentialModel:model];
    [self setupSubViews];
    [self setNeedsUpdateConstraints];
}
@end
