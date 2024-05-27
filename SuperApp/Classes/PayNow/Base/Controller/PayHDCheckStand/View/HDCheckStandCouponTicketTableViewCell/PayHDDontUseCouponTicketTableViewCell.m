//
//  PayHDDontUseCouponTicketTableViewCell.m
//  ViPay
//
//  Created by VanJay on 2019/6/15.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDDontUseCouponTicketTableViewCell.h"
#import "HDDontUseCouponTicketView.h"
#import "Masonry.h"


@interface PayHDDontUseCouponTicketTableViewCell ()
@property (nonatomic, strong) HDDontUseCouponTicketView *couponTicketView; ///< 不使用优惠券
@end


@implementation PayHDDontUseCouponTicketTableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    // 新建标识
    static NSString *ID = @"PayHDDontUseCouponTicketTableViewCell";

    // 创建cell
    PayHDDontUseCouponTicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];

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
    _couponTicketView = [[HDDontUseCouponTicketView alloc] init];
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

    [self setNeedsUpdateConstraints];
}
@end
