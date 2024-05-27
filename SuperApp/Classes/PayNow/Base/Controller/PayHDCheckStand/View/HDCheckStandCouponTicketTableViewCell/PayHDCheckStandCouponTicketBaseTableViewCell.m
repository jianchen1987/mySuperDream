//
//  PayHDCheckstandCouponTicketBaseTableViewCell.m
//  ViPay
//
//  Created by VanJay on 2019/6/16.
//  Copyright © 2019 chaos network technology. All rights reserved.
//

#import "PayHDCheckStandCouponTicketBaseTableViewCell.h"
#import "HDCommonButton.h"
#import "Masonry.h"


@interface PayHDCheckstandCouponTicketBaseTableViewCell ()
@property (nonatomic, strong) HDCommonButton *tickBtn;  ///< 勾选按钮
@property (nonatomic, strong) UIImageView *bestOfferIV; ///< 最优惠图片
@end


@implementation PayHDCheckstandCouponTicketBaseTableViewCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    return nil;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // 去除选中样式
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        // 初始化子控件
        [self _setupSubViews];
    }
    return self;
}

- (void)_setupSubViews {
    _tickBtn = [HDCommonButton buttonWithType:UIButtonTypeCustom];
    _tickBtn.userInteractionEnabled = NO;
    [_tickBtn setImage:[UIImage imageNamed:@"lanUnSelect"] forState:UIControlStateNormal];
    [_tickBtn setImage:[UIImage imageNamed:@"lanSelect"] forState:UIControlStateSelected];
    _tickBtn.adjustsImageWhenDisabled = NO;
    [self.contentView addSubview:_tickBtn];

    self.bestOfferIV = ({
        UIImageView *bestOfferIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"best_offer"]];
        bestOfferIV.hidden = true;
        [self.contentView addSubview:bestOfferIV];
        bestOfferIV;
    });
}

- (void)updateConstraints {
    [super updateConstraints];

    [self.contentView bringSubviewToFront:self.tickBtn];
    [self.contentView bringSubviewToFront:self.bestOfferIV];

    [self.tickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(kRealWidth(5));
        make.right.equalTo(self.contentView).offset(-kRealWidth(30));
    }];

    [self.bestOfferIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tickBtn.mas_bottom).offset(kRealWidth(12));
        make.right.equalTo(self.tickBtn);
    }];
}

- (void)setModel:(PayHDTradePreferentialModel *)model {
    _model = model;

    self.bestOfferIV.hidden = !model.showStamp;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.tickBtn.selected = selected;
    self.model.selected = selected;
}
@end
