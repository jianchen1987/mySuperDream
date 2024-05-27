//
//  TNProductDetailServiceCell.m
//  SuperApp
//
//  Created by 张杰 on 2021/8/20.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNProductDetailServiceCell.h"
#import "HDAppTheme+TinhNow.h"
#import "NSString+extend.h"
#import "TNProductServiceModel.h"
#import "TNView.h"


@interface TNServiceItemView : TNView
//固定传2个
@property (strong, nonatomic) NSArray<TNProductServiceModel *> *twoArrList;
/// 左边文本
@property (strong, nonatomic) UILabel *leftLabel;
/// 右边文本
@property (strong, nonatomic) UILabel *rightLabel;
@end


@implementation TNServiceItemView
- (void)hd_setupViews {
    [self addSubview:self.leftLabel];
    [self addSubview:self.rightLabel];
}
- (void)updateConstraints {
    CGFloat width = (kScreenWidth - kRealWidth(45) - kRealWidth(20) - kRealWidth(15));
    if (!self.rightLabel.isHidden) {
        width = width / 2;
    }
    [self.leftLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self);
        make.width.mas_equalTo(width);
        if (self.rightLabel.isHidden) {
            make.right.equalTo(self);
        } else {
            make.right.equalTo(self.rightLabel.mas_left).offset(-kRealWidth(20));
            make.width.mas_equalTo(self.rightLabel.mas_width);
        }
    }];
    if (!self.rightLabel.isHidden) {
        [self.rightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.leftLabel);
            make.right.lessThanOrEqualTo(self);
            make.width.mas_equalTo(width);
        }];
    }
    [super updateConstraints];
}
- (void)setTwoArrList:(NSArray<TNProductServiceModel *> *)twoArrList {
    _twoArrList = twoArrList;
    if (HDIsArrayEmpty(twoArrList)) {
        return;
    }
    TNProductServiceModel *leftModel = twoArrList.firstObject;
    NSString *leftText = [NSString stringWithFormat:@"• %@", leftModel.name];
    NSMutableAttributedString *leftAttr = [NSString highLightString:@"•" inLongString:leftText font:[HDAppTheme.TinhNowFont fontSemibold:15] color:HexColor(0x9F8153)];
    // NSBaselineOffsetAttributeName  负数下偏移
    [leftAttr addAttribute:NSBaselineOffsetAttributeName value:@(-0.5) range:[leftText rangeOfString:@"•"]];
    self.leftLabel.attributedText = leftAttr;
    if (twoArrList.count >= 2) {
        TNProductServiceModel *rightModel = twoArrList[1];
        NSString *rightText = [NSString stringWithFormat:@"• %@", rightModel.name];
        NSMutableAttributedString *rightAttr = [NSString highLightString:@"•" inLongString:rightText font:[HDAppTheme.TinhNowFont fontSemibold:15] color:HexColor(0x9F8153)];
        // NSBaselineOffsetAttributeName  负数下偏移
        [rightAttr addAttribute:NSBaselineOffsetAttributeName value:@(-0.5) range:[rightText rangeOfString:@"•"]];
        self.rightLabel.attributedText = rightAttr;
        self.rightLabel.hidden = NO;
    } else {
        self.rightLabel.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}
/** @lazy leftLabel */
- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = HDAppTheme.TinhNowFont.standard12;
        _leftLabel.textColor = HexColor(0x9F8153);
    }
    return _leftLabel;
}
/** @lazy rightLabel */
- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = HDAppTheme.TinhNowFont.standard12;
        _rightLabel.textColor = HexColor(0x9F8153);
    }
    return _rightLabel;
}
@end


@implementation TNProductDetailServiceCellModel

@end


@interface TNProductDetailServiceCell ()
/// 左边图片
@property (strong, nonatomic) UIImageView *leftImageView;
/// 标题
@property (strong, nonatomic) UILabel *titleLabel;
/// 箭头图片
@property (strong, nonatomic) UIImageView *arrowImageView;
/// 右下角背景图片
//@property (strong, nonatomic) UIImageView *bgImageView;
/// 中间文本视图  根据数据动态展示
@property (strong, nonatomic) UIView *containerView;
@end


@implementation TNProductDetailServiceCell

- (void)setFrame:(CGRect)frame {
    CGRect newFrame = frame;
    if (!self.model.notSetCellInset) {
        newFrame.origin.x = kRealWidth(8);
        newFrame.size.width = kScreenWidth - kRealWidth(16);
    }
    [super setFrame:newFrame];
}

- (void)hd_setupViews {
    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.arrowImageView];
    //    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.containerView];
}
- (void)setModel:(TNProductDetailServiceCellModel *)model {
    _model = model;
    if (HDIsArrayEmpty(model.servicesList)) {
        return;
    }
    [self.containerView hd_removeAllSubviews];
    UIView *lastView = nil;
    NSArray *splitArr = [model.servicesList hd_splitArrayWithEachCount:2];
    for (int i = 0; i < splitArr.count; i++) {
        TNServiceItemView *itemView = [[TNServiceItemView alloc] init];
        itemView.twoArrList = splitArr[i];
        [self.containerView addSubview:itemView];
        [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(10));
            } else {
                make.top.equalTo(self.containerView);
            }
            make.height.mas_equalTo(kRealWidth(18));
            if (i == splitArr.count - 1) {
                make.bottom.equalTo(self.containerView.mas_bottom);
            }
        }];
        lastView = itemView;
    }
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.leftImageView sizeToFit];
    [self.leftImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(10));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        make.size.mas_equalTo(self.leftImageView.image.size);
    }];
    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftImageView);
        make.left.equalTo(self.leftImageView.mas_right).offset(kRealWidth(10));
    }];
    [self.arrowImageView sizeToFit];
    [self.arrowImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftImageView);
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(10));
    }];
    //    [self.bgImageView sizeToFit];
    //    [self.bgImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
    //        make.bottom.right.equalTo(self.contentView);
    //    }];
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
    }];
    [super updateConstraints];
}
/** @lazy leftImageView */
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tinhnow_service"]];
    }
    return _leftImageView;
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.text = TNLocalizedString(@"tn_service_info", @"服务");
    }
    return _titleLabel;
}
/** @lazy arrowImageView */
- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_gray_small"]];
    }
    return _arrowImageView;
}
/** @lazy bgImageView */
//- (UIImageView *)bgImageView {
//    if (!_bgImageView) {
//        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tinhnow_service_bg"]];
//    }
//    return _bgImageView;
//}
/** @lazy containerView */
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}
@end
