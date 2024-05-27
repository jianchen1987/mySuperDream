//
//  PayHDCommonCouponTicketTableViewCell.m
//  ViPay
//
//  Created by VanJay on 2019/6/11.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDCommonCouponTicketTableViewCell.h"
#import "HDCommonCouponTicketView.h"
#import "Masonry.h"


@interface PayHDCommonCouponTicketTableViewCell ()
@property (nonatomic, strong) HDCommonCouponTicketView *couponTicketView; ///< 优惠券
@end


@implementation PayHDCommonCouponTicketTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 新建标识
    static NSString *ID = @"PayHDCommonCouponTicketTableViewCell";

    // 创建cell
    PayHDCommonCouponTicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

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
    _couponTicketView = [[HDCommonCouponTicketView alloc] init];
    [self.contentView addSubview:_couponTicketView];
}

- (void)updateConstraints {
    [super updateConstraints];

    [self.couponTicketView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).offset(-2 * kRealWidth(15));
        make.centerX.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-kRealWidth(15));
    }];
}

#pragma mark - getters and setters
- (void)setModel:(PayHDTradePreferentialModel *)model {
    [super setModel:model];

    HDCouponTicketModel *couponTicketModel = [HDCouponTicketModel modelWithTradePreferentialModel:model];

    self.couponTicketView.model = couponTicketModel;

    [self setNeedsUpdateConstraints];
}
@end
