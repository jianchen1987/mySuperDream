//
//  TNBargainRecordCell.m
//  SuperApp
//
//  Created by 张杰 on 2020/10/29.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "TNBargainRecordCell.h"
#import "HDAppTheme+TinhNow.h"
#import "TNNotificationConst.h"


@interface TNBargainRecordCell ()
/// 图片
@property (strong, nonatomic) UIImageView *goodsImageView;
/// 名称
@property (strong, nonatomic) UILabel *nameLabel;
/// 状态文本
@property (strong, nonatomic) UILabel *statusLabel;
/// 操作按钮
@property (strong, nonatomic) HDUIButton *oprateBtn;
/// 头像容器
@property (strong, nonatomic) UIView *iconContainerView;
/// 分割线
@property (strong, nonatomic) UIView *lineView;
/// 头像存储数组
@property (strong, nonatomic) NSMutableArray<UIImageView *> *icons;
@end


@implementation TNBargainRecordCell
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)hd_setupViews {
    [self.contentView addSubview:self.goodsImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.statusLabel];
    [self.contentView addSubview:self.oprateBtn];
    [self.contentView addSubview:self.iconContainerView];
    [self.contentView addSubview:self.lineView];

    self.goodsImageView.image = [HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(105), kRealWidth(105))];
    //最多显示5个头像 默认先创建6个 根据数据显示隐藏
    self.icons = [NSMutableArray array];
    UIView *lastView = nil;
    CGFloat width = kRealWidth(21);
    for (int i = 0; i < 5; i++) {
        UIImageView *icon = [[UIImageView alloc] init];
        icon.backgroundColor = [UIColor grayColor];
        [self.iconContainerView addSubview:icon];
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.iconContainerView);
            make.width.mas_equalTo(width);
            if (lastView) {
                make.left.equalTo(lastView.mas_right).offset(kRealWidth(6));
            } else {
                make.left.equalTo(self.iconContainerView);
            }
        }];
        lastView = icon;
        icon.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:precedingFrame.size.height * 0.5];
        };
        [self.icons addObject:icon];
        //默认全部隐藏先
        icon.hidden = true;
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(countDownNoti) name:kNotificationNameBargainCountTime object:nil];
}
#pragma mark - 倒计时
- (void)countDownNoti {
    if (self.model.status == TNBargainGoodStatusOngoing) {
        NSInteger timeout = self.model.expiredTimeOut;
        if (timeout > 0) {
            NSInteger second = timeout % 60;       //秒
            NSInteger minutes = timeout / 60 % 60; //分
            NSInteger hours = timeout / 60 / 60;   //时
            NSString *showTime = [NSString stringWithFormat:@"%02ld:%02ld:%02ld", hours, minutes, second];
            self.statusLabel.text = [NSString stringWithFormat:TNLocalizedString(@"tn_bargain_end_after", @"%@后结束"), showTime];
        } else {
            //倒计时结束
            self.statusLabel.text = [NSString stringWithFormat:TNLocalizedString(@"tn_bargain_end_after", @"%@后结束"), @"00:00:00"];
        }
    }
}
- (void)setModel:(TNBargainRecordModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.images placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(105), kRealWidth(105))] imageView:self.goodsImageView];
    switch (model.status) {
        case TNBargainGoodStatusOngoing: //进行中
            [self.oprateBtn setTitle:TNLocalizedString(@"tn_bargain_continue", @"继续助力") forState:UIControlStateNormal];
            self.oprateBtn.enabled = YES;
            self.oprateBtn.userInteractionEnabled = false; //禁止点击  让cell自身响应进入详情事件
            self.statusLabel.textColor = HDAppTheme.TinhNowColor.R1;
            break;
        case TNBargainGoodStatusFailure: //助力失败
            [self.oprateBtn setTitle:TNLocalizedString(@"tn_bargain_end", @"助力结束") forState:UIControlStateNormal];
            self.oprateBtn.enabled = NO;
            self.oprateBtn.userInteractionEnabled = false; //禁止点击  让cell自身响应进入详情事件
            self.statusLabel.text = TNLocalizedString(@"tn_bargain_not_success", @"助力未成功");
            self.statusLabel.textColor = [UIColor hd_colorWithHexString:@"#BEBEBE"];
            break;
        case TNBargainGoodStatusSuccess: //助力成功
            [self.oprateBtn setTitle:TNLocalizedString(@"tn_bargain_check_order", @"查看订单") forState:UIControlStateNormal];
            self.oprateBtn.enabled = YES;
            self.oprateBtn.userInteractionEnabled = true; //去订单详情
            self.statusLabel.text = TNLocalizedString(@"tn_bargain_success", @"助力成功");
            self.statusLabel.textColor = HDAppTheme.TinhNowColor.R1;
            break;
        default:
            break;
    }
    //手动调节倒计时
    [self countDownNoti];
    //显示砍价展示文案
    self.nameLabel.attributedText = model.attrMsg;
    //先将所有头像全部隐藏  再根据数据显示  避免复用
    for (UIImageView *icon in self.icons) {
        icon.hidden = true;
    }
    //最多显示5个  如果多余5个 就显示最新的5个
    if (!HDIsArrayEmpty(model.bargainDetailList)) {
        NSArray *list = @[];
        if (model.bargainDetailList.count <= 5) {
            list = model.bargainDetailList;
        } else { //取最新的5条
            list = [model.bargainDetailList subarrayWithRange:NSMakeRange(model.bargainDetailList.count - 5, 5)];
        }
        for (int i = 0; i < list.count; i++) {
            UIImageView *icon = self.icons[i];
            icon.hidden = NO;
            TNBargainPeopleModel *pModel = list[i];
            [icon sd_setImageWithURL:[NSURL URLWithString:pModel.userPortrait] placeholderImage:[UIImage imageNamed:@"tinhnow-default-avatar"]];
        }
    }

    [self setNeedsUpdateConstraints];
}
- (void)setHiddeBottomLine:(BOOL)hiddeBottomLine {
    _hiddeBottomLine = hiddeBottomLine;
    if (hiddeBottomLine) {
        self.lineView.hidden = YES;
    } else {
        self.lineView.hidden = NO;
    }
}
#pragma mark - 事件点击
- (void)oprateClick {
    if (self.model.status == TNBargainGoodStatusSuccess) { //成功后就是点击订单详情
        if (self.orderDetailClickCallBack) {
            self.orderDetailClickCallBack();
        }
    }
}
- (void)updateConstraints {
    [self.goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(8));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
        make.width.mas_equalTo(kRealWidth(105));
    }];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsImageView.mas_top);
        make.left.equalTo(self.goodsImageView.mas_right).offset(kRealWidth(15));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(10));
    }];
    [self.iconContainerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(kRealWidth(10));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(10));
        make.height.mas_equalTo(kRealWidth(21));
    }];
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.nameLabel);
        make.bottom.equalTo(self.goodsImageView.mas_bottom);
    }];
    [self.oprateBtn sizeToFit];
    [self.oprateBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.goodsImageView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(10));
    }];
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(1));
        make.height.mas_equalTo(kRealWidth(1));
    }];
    [super updateConstraints];
}

/** @lazy goodsImageView */
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] init];
    }
    return _goodsImageView;
}
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 2;
        _nameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _nameLabel.font = HDAppTheme.TinhNowFont.standard15;
    }
    return _nameLabel;
}
/** @lazy statusLabel */
- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = HDAppTheme.TinhNowColor.R1;
        _statusLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    }
    return _statusLabel;
}
/** @lazy iconContainerView */
- (UIView *)iconContainerView {
    if (!_iconContainerView) {
        _iconContainerView = [[UIView alloc] init];
    }
    return _iconContainerView;
}
/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HDAppTheme.TinhNowColor.G4;
    }
    return _lineView;
}
/** @lazy oprateBtn */
- (HDUIButton *)oprateBtn {
    if (!_oprateBtn) {
        _oprateBtn = [[HDUIButton alloc] init];
        _oprateBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        [_oprateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_oprateBtn setTitleEdgeInsets:UIEdgeInsetsMake(4, 9, 4, 9)];
        [_oprateBtn addTarget:self action:@selector(oprateClick) forControlEvents:UIControlEventTouchUpInside];
        [_oprateBtn setBackgroundImage:[self gradientColorImageFromColors:@[[UIColor hd_colorWithHexString:@"#BEBEBE"], [UIColor hd_colorWithHexString:@"#BEBEBE"]]
                                                                  imgSize:CGSizeMake(kRealWidth(105), 100)]
                              forState:UIControlStateDisabled];
        [_oprateBtn setBackgroundImage:[self gradientColorImageFromColors:@[HDAppTheme.TinhNowColor.R3, HDAppTheme.TinhNowColor.R4] imgSize:CGSizeMake(kRealWidth(105), 100)]
                              forState:UIControlStateNormal];

        _oprateBtn.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:16];
        };
    }
    return _oprateBtn;
}

- (UIImage *)gradientColorImageFromColors:(NSArray<UIColor *> *)colors imgSize:(CGSize)imgSize {
    NSMutableArray *ar = [NSMutableArray array];
    for (UIColor *c in colors) {
        [ar addObject:(id)c.CGColor];
    }
    UIGraphicsBeginImageContextWithOptions(imgSize, YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)ar, NULL);
    CGPoint start = CGPointMake(0, 0);
    CGPoint end = CGPointMake(1, 0);

    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    CGColorSpaceRelease(colorSpace);
    UIGraphicsEndImageContext();
    return image;
}
@end


@implementation TNBargainRecordCellModel

@end
