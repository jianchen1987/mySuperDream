//
//  DepositCell.m
//  SuperApp
//
//  Created by Quin on 2021/11/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "PNDepositCell.h"


@implementation PNDepositCell
+ (instancetype)cellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"DepositCell";
    PNDepositCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
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
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.iconImg];
    [self.bgView addSubview:self.detailLB];
    [self.bgView addSubview:self.button];
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(kRealWidth(12));
        make.right.mas_equalTo(self.contentView.mas_right).offset(kRealWidth(-12));
        make.top.mas_equalTo(self.contentView).offset(kRealWidth(16));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(kRealWidth(-12));
    }];

    [self.iconImg mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgView).offset(kRealWidth(12));
        make.left.mas_equalTo(self.bgView).offset(kRealWidth(12));
        make.width.equalTo(@(kRealWidth(43)));
        make.height.equalTo(@(kRealWidth(43)));
        if (self.button.hidden) {
            make.bottom.lessThanOrEqualTo(self.bgView.mas_bottom).offset(kRealWidth(-12));
        }
    }];

    [self.detailLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        //        make.centerY.equalTo(self.iconImg);
        make.top.mas_equalTo(self.iconImg.mas_top);
        make.left.equalTo(self.iconImg.mas_right).offset(kRealWidth(8));
        make.right.equalTo(self.bgView.mas_right).offset(kRealWidth(-12));
        if (self.button.hidden) {
            make.bottom.lessThanOrEqualTo(self.bgView.mas_bottom).offset(kRealWidth(-16));
        }
    }];

    if (!self.button.hidden) {
        [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.greaterThanOrEqualTo(self.iconImg.mas_bottom).offset(kRealWidth(12));
            make.top.greaterThanOrEqualTo(self.detailLB.mas_bottom).offset(kRealWidth(12));
            make.left.right.equalTo(self.bgView);
            make.height.mas_equalTo(kRealHeight(35));
            make.bottom.mas_equalTo(self.bgView.mas_bottom);
        }];
    }

    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}
//-(void)collecTap:(DepositModel *)model{
//    !self.collecBlock ?: self.collecBlock(model);
//
//}
- (void)buttonTap {
    !self.collecBlock ?: self.collecBlock(self.model);
}

#pragma mark - getters and setters
- (void)setModel:(PNDepositModel *)model {
    _model = model;
    self.iconImg.image = [UIImage imageNamed:model.iconImgName];
    self.detailLB.text = model.detail;

    if (WJIsStringNotEmpty(model.btnTitle)) {
        self.button.hidden = NO;
        [self.button setTitle:model.btnTitle forState:UIControlStateNormal];
    } else {
        self.button.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = UIView.new;
        _bgView.backgroundColor = [UIColor whiteColor];
        _bgView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:7 borderWidth:1 borderColor:HDAppTheme.PayNowColor.cECECEC];
        };
    }
    return _bgView;
}

- (UIImageView *)iconImg {
    if (!_iconImg) {
        _iconImg = UIImageView.new;
    }
    return _iconImg;
}

- (SALabel *)detailLB {
    if (!_detailLB) {
        SALabel *label = SALabel.new;
        label.font = [HDAppTheme.font forSize:13];
        label.textColor = HDAppTheme.PayNowColor.c343B4D;
        label.numberOfLines = 0;
        _detailLB = label;
    }
    return _detailLB;
}

- (HDUIButton *)button {
    if (!_button) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsButtonWhenHighlighted = false;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [HDAppTheme.font forSize:13];
        [button sizeToFit];
        button.backgroundColor = [UIColor hd_colorWithHexString:@"#FD7127"];
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self buttonTap];
        }];
        button.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight radius:7];
        };

        _button = button;
    }
    return _button;
}
@end
