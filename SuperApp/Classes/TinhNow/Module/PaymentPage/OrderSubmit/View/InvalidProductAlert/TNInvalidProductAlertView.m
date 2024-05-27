//
//  TNInvalidProductAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2022/2/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNInvalidProductAlertView.h"
#import "HDAppTheme+TinhNow.h"
#import "SAOperationButton.h"
#import "SATableViewCell.h"
#import "TNMultiLanguageManager.h"
#import "TNShoppingCarItemModel.h"
#import <HDKitCore/HDKitCore.h>
#import <Masonry/Masonry.h>


@interface TNInvalidProductCell : SATableViewCell
/// goodsPic
@property (nonatomic, strong) UIImageView *goodsImageView;
/// goodName
@property (nonatomic, strong) UILabel *goodsNameLabel;
/// 规格文本
@property (strong, nonatomic) UILabel *specsLabel;
/// 数量
@property (strong, nonatomic) UILabel *quantityLabel;
/// 价格
@property (nonatomic, copy) UILabel *priceLabel;
/// 提示文案
@property (strong, nonatomic) UILabel *skuTipsLabel;
/// 遮罩
@property (strong, nonatomic) UIView *goodImageMaskAlphaView;
///
@property (strong, nonatomic) HDLabel *expireTagLabel;
///
@property (strong, nonatomic) TNShoppingCarItemModel *model;
@end


@implementation TNInvalidProductCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.goodsImageView];
    [self.contentView addSubview:self.goodsNameLabel];
    [self.contentView addSubview:self.specsLabel];
    [self.contentView addSubview:self.quantityLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.skuTipsLabel];
    [self.goodsImageView addSubview:self.goodImageMaskAlphaView];
    [self.goodImageMaskAlphaView addSubview:self.expireTagLabel];
}
- (void)setModel:(TNShoppingCarItemModel *)model {
    _model = model;
    [HDWebImageManager setImageWithURL:model.picture placeholderImage:[HDHelper placeholderImageWithSize:CGSizeMake(kRealWidth(70), kRealWidth(70))] imageView:self.goodsImageView];
    self.goodsNameLabel.text = model.goodsName;
    self.specsLabel.text = HDIsStringNotEmpty(model.goodsSkuName) ? model.goodsSkuName : TNLocalizedString(@"tn_page_default_title", @"默认");
    self.quantityLabel.text = [NSString stringWithFormat:@"x%@", model.quantity];
    self.priceLabel.text = model.salePrice.thousandSeparatorAmount;
    if (HDIsStringNotEmpty(model.invalidMsg)) {
        self.skuTipsLabel.hidden = NO;
        self.goodImageMaskAlphaView.hidden = NO;
        self.skuTipsLabel.text = model.invalidMsg;
    } else {
        self.skuTipsLabel.hidden = YES;
        self.goodImageMaskAlphaView.hidden = YES;
    }

    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.goodsImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(15));
        make.size.mas_equalTo(CGSizeMake(kRealWidth(70), kRealWidth(70)));
        if (self.skuTipsLabel.isHidden) {
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
        }
    }];
    [self.goodsNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(kRealWidth(10));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.top.equalTo(self.goodsImageView.mas_top);
    }];
    [self.specsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.goodsNameLabel);
        make.top.equalTo(self.goodsNameLabel.mas_bottom).offset(kRealWidth(5));
    }];
    [self.quantityLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.goodsNameLabel);
        make.bottom.equalTo(self.goodsImageView.mas_bottom);
    }];
    [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        make.bottom.equalTo(self.goodsImageView.mas_bottom);
    }];

    if (!self.goodImageMaskAlphaView.isHidden) {
        [self.goodImageMaskAlphaView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.goodsImageView);
        }];
        [self.expireTagLabel sizeToFit];
        [self.expireTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.goodImageMaskAlphaView.mas_centerY);
            make.left.equalTo(self.goodImageMaskAlphaView.mas_left).offset(kRealWidth(8));
            make.right.equalTo(self.goodImageMaskAlphaView.mas_right).offset(-kRealWidth(8));
        }];
    }

    if (!self.skuTipsLabel.isHidden) {
        [self.skuTipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.goodsImageView.mas_left);
            make.top.equalTo(self.goodsImageView.mas_bottom).offset(kRealWidth(5));
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(15));
        }];
    }
    [super updateConstraints];
}
/** @lazy goodsImageView */
- (UIImageView *)goodsImageView {
    if (!_goodsImageView) {
        _goodsImageView = [[UIImageView alloc] init];
        _goodsImageView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:5.0];
        };
    }
    return _goodsImageView;
}
/** @lazy goodsNameLabel */
- (UILabel *)goodsNameLabel {
    if (!_goodsNameLabel) {
        _goodsNameLabel = [[UILabel alloc] init];
        _goodsNameLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
        _goodsNameLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _goodsNameLabel.numberOfLines = 1;
    }
    return _goodsNameLabel;
}
/** @lazy specsLabel */
- (UILabel *)specsLabel {
    if (!_specsLabel) {
        _specsLabel = [[UILabel alloc] init];
        _specsLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        _specsLabel.font = HDAppTheme.TinhNowFont.standard12;
        _specsLabel.numberOfLines = 1;
    }
    return _specsLabel;
}
/** @lazy quantityLabel */
- (UILabel *)quantityLabel {
    if (!_quantityLabel) {
        _quantityLabel = [[UILabel alloc] init];
        _quantityLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        _quantityLabel.font = HDAppTheme.TinhNowFont.standard12;
    }
    return _quantityLabel;
}
/** @lazy priceLabel */
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HDAppTheme.TinhNowColor.c5d667f;
        _priceLabel.font = [HDAppTheme.TinhNowFont fontRegular:15];
    }
    return _priceLabel;
}
/** @lazy skuTipsLabel */
- (UILabel *)skuTipsLabel {
    if (!_skuTipsLabel) {
        _skuTipsLabel = [[UILabel alloc] init];
        _skuTipsLabel.textColor = HDAppTheme.TinhNowColor.cFF2323;
        _skuTipsLabel.font = HDAppTheme.TinhNowFont.standard12;
        _skuTipsLabel.numberOfLines = 0;
    }
    return _skuTipsLabel;
}
/** @lazy goodImageMaskAlphaView */
- (UIView *)goodImageMaskAlphaView {
    if (!_goodImageMaskAlphaView) {
        _goodImageMaskAlphaView = [[UIView alloc] init];
        _goodImageMaskAlphaView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    }
    return _goodImageMaskAlphaView;
}
/** @lazy expireTagLabel */
- (HDLabel *)expireTagLabel {
    if (!_expireTagLabel) {
        _expireTagLabel = [[HDLabel alloc] init];
        _expireTagLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];
        _expireTagLabel.textColor = [UIColor whiteColor];
        _expireTagLabel.font = HDAppTheme.TinhNowFont.standard12;
        _expireTagLabel.textAlignment = NSTextAlignmentCenter;
        _expireTagLabel.hd_edgeInsets = UIEdgeInsetsMake(3, 4, 3, 4);
        _expireTagLabel.text = TNLocalizedString(@"hTFG1UDO", @"已失效");
        _expireTagLabel.numberOfLines = 2;
        _expireTagLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:12];
        };
    }
    return _expireTagLabel;
}
@end


@interface TNInvalidProductAlertView () <UITableViewDelegate, UITableViewDataSource>
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 关闭按钮
@property (nonatomic, strong) HDUIButton *closeBTN;
///// 确定按钮
//@property (nonatomic, strong) SAOperationButton *doneBtn;
/// 左边一级分类
@property (strong, nonatomic) UITableView *tableView;
/// 底部视图
@property (strong, nonatomic) UIView *bottomView;
/// 修改按钮
@property (strong, nonatomic) SAOperationButton *changeBtn;
/// 继续下单按钮
@property (strong, nonatomic) SAOperationButton *submitBtn;
///
@property (strong, nonatomic) NSArray<TNShoppingCarItemModel *> *dataArr;
///
@property (nonatomic, assign) TNSubmitInvalidType invalidType;

@end


@implementation TNInvalidProductAlertView
- (instancetype)initWithTitle:(NSString *)title invalidType:(TNSubmitInvalidType)invalidType DataArr:(NSArray *)dataArr {
    if (self = [super init]) {
        self.dataArr = dataArr;
        self.titleLabel.text = title;
        self.invalidType = invalidType;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
    }
    return self;
}

#pragma mark - HDActionAlertViewOverridable
- (void)layoutContainerView {
    [self.containerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
}
- (void)setupContainerViewAttributes {
    // 设置containerview的属性,比如切边啥的
    self.containerView.layer.masksToBounds = YES;
    self.allowTapBackgroundDismiss = NO;
    self.containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
    };
}

- (void)setupContainerSubViews {
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.closeBTN];
    [self.containerView addSubview:self.tableView];
    [self.containerView addSubview:self.bottomView];
    [self.bottomView addSubview:self.changeBtn];
    [self.bottomView addSubview:self.submitBtn];
    if (self.invalidType == TNSubmitInvalidTypeAllInvalid) {
        self.submitBtn.hidden = YES;
    }
}

- (void)layoutContainerViewSubViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.containerView);
        make.height.mas_equalTo(kRealHeight(50));
    }];
    [self.closeBTN sizeToFit];
    [self.closeBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(kRealHeight(330));
    }];

    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.tableView.mas_bottom);
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-kiPhoneXSeriesSafeBottomHeight);
    }];

    if (self.invalidType == TNSubmitInvalidTypeAllInvalid) {
        [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.bottomView.mas_centerX);
            make.height.mas_equalTo(kRealHeight(45));
            make.width.mas_equalTo(kScreenWidth / 2);
            make.top.equalTo(self.bottomView.mas_top).offset(kRealHeight(15));
            make.bottom.equalTo(self.bottomView.mas_bottom).offset(-kRealHeight(15));
        }];
    } else if (self.invalidType == TNSubmitInvalidTypeCanBuy) {
        [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomView.mas_left).offset(kRealWidth(10));
            make.height.mas_equalTo(kRealHeight(45));
            make.top.equalTo(self.bottomView.mas_top).offset(kRealHeight(15));
            make.bottom.equalTo(self.bottomView.mas_bottom).offset(-kRealHeight(15));
        }];
        [self.submitBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomView.mas_top).offset(kRealHeight(15));
            make.bottom.equalTo(self.bottomView.mas_bottom).offset(-kRealHeight(15));
            make.width.equalTo(self.changeBtn.mas_width);
            make.height.equalTo(self.changeBtn.mas_height);
            make.right.equalTo(self.bottomView.mas_right).offset(-kRealWidth(10));
            make.left.equalTo(self.changeBtn.mas_right).offset(kRealWidth(15));
        }];
    }
}
#pragma mark -确认点击
- (void)onClickChangeBtn {
    !self.backChangeBlock ?: self.backChangeBlock();
    [self dismiss];
}
- (void)onCllickSubmitBtn {
    !self.continueSubmitOrderBlock ?: self.continueSubmitOrderBlock(self.dataArr);
    [self dismiss];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TNInvalidProductCell *cell = [TNInvalidProductCell cellWithTableView:tableView];
    TNShoppingCarItemModel *model = self.dataArr[indexPath.row];
    cell.model = model;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (HDUIButton *)closeBTN {
    if (!_closeBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        button.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
            !self.closeBlock ?: self.closeBlock();
        }];
        _closeBTN = button;
    }
    return _closeBTN;
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[HDLabel alloc] init];
        _titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
/** @lazy bottomView */
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}
- (SAOperationButton *)changeBtn {
    if (!_changeBtn) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        button.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:15];
        [button addTarget:self action:@selector(onClickChangeBtn) forControlEvents:UIControlEventTouchUpInside];
        [button applyPropertiesWithBackgroundColor:HexColor(0xFFC95F)];
        [button setTitle:TNLocalizedString(@"2wfHEi8D", @"返回修改") forState:UIControlStateNormal];
        button.titleLabel.numberOfLines = 2;
        _changeBtn = button;
    }
    return _changeBtn;
}
- (SAOperationButton *)submitBtn {
    if (!_submitBtn) {
        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        button.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:15];
        [button addTarget:self action:@selector(onCllickSubmitBtn) forControlEvents:UIControlEventTouchUpInside];
        [button applyPropertiesWithBackgroundColor:HexColor(0xFF8812)];
        button.titleLabel.numberOfLines = 2;
        [button setTitle:TNLocalizedString(@"tn_continue_order", @"继续下单") forState:UIControlStateNormal];
        _submitBtn = button;
    }
    return _submitBtn;
}
/** @lazy tableView */
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = YES;
        //        _tableView.rowHeight = kRealWidth(100);
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = kRealWidth(100);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 15.0, *)) {
            _tableView.sectionHeaderTopPadding = 0;
        }
    }
    return _tableView;
}

@end
