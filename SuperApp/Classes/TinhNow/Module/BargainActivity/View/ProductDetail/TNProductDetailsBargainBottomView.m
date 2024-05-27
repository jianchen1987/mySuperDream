//
//  TNProductDetailsBargainBottomView.m
//  SuperApp
//
//  Created by xixi on 2021/2/24.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNProductDetailsBargainBottomView.h"
#import "TNProductDetailsRspModel.h"
#import "TNBargainProductDetailViewModel.h"
#import "TNProductSkuModel.h"


@interface TNProductDetailsBargainBottomView ()
/// viewModel
@property (nonatomic, strong) TNBargainProductDetailViewModel *viewModel;
/// 顶部线条
@property (nonatomic, strong) UIView *topLine;
/// 分享邀请助力
@property (nonatomic, strong) UIButton *bargainShareBtn;
/// 右边容器view
@property (nonatomic, strong) UIView *buttonContainer;
/// 客服
@property (nonatomic, strong) HDUIButton *customerServiceBtn;
/// 立即购买
@property (nonatomic, strong) UIButton *buyNowBtn;
/// 创建发起助力活动 -($1拿走)
@property (nonatomic, strong) UIButton *createBargainTaskBtn;
/// 店铺
@property (nonatomic, strong) NSString *storeNo;
/// 是否能够购买
@property (nonatomic, assign) BOOL soldOutFlag;

@end


@implementation TNProductDetailsBargainBottomView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.soldOutFlag = YES;
    self.viewModel = viewModel;
    self = [super initWithViewModel:viewModel];
    return self;
}

- (void)hd_setupViews {
    self.backgroundColor = [UIColor whiteColor];
    [self setAllViewHidden];
    [self addSubview:self.topLine];
    [self addSubview:self.bargainShareBtn];
    [self addSubview:self.customerServiceBtn];
    [self addSubview:self.buttonContainer];
    [self.buttonContainer addSubview:self.buyNowBtn];
    [self.buttonContainer addSubview:self.createBargainTaskBtn];
}

- (void)updateConstraints {
    [self.topLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
        make.height.mas_equalTo(0.5);
    }];
    if (HDIsStringNotEmpty(self.viewModel.bargainPrice)) { //如果进入详情有砍价价格的话  就只是显示分享按钮
        [self configShareStyle];
    } else {
        if (!self.soldOutFlag) {
            //如果商品状态是删除或者下载  需要隐藏 立即购买
            [self configCreateTaskStyle];
        } else {
            [self configDefaulStyle];
        }
    }
    [super updateConstraints];
}

- (void)hd_bindViewModel {
    if (HDIsStringEmpty(self.viewModel.bargainPrice)) { //如果是砍价详情需要更新按钮状态
        @HDWeakify(self);
        [self.KVOController hd_observe:self.viewModel keyPath:@"refreshFlag" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
            @HDStrongify(self);
            [self refreshViewWithModel:self.viewModel.productDetailsModel];
        }];
    }
}

#pragma mark - private methods
- (void)refreshViewWithModel:(TNProductDetailsRspModel *)model {
    if (!model.productSource.originalValid) {
        self.soldOutFlag = NO;
    }
    self.storeNo = model.storeNo;

    NSString *buyBtnStr = [NSString stringWithFormat:@"%@\n%@", model.productSource.price.thousandSeparatorAmount, TNLocalizedString(@"tn_buynow", @"立即购买")];
    [_buyNowBtn setTitle:buyBtnStr forState:UIControlStateNormal];

    NSString *taskBtnStr = @"";
    NSString *smallStr = @"";
    if ([model.status isEqualToString:@"DOING"]) {
        taskBtnStr = [NSString stringWithFormat:@"%@ %@", model.lowestPrice.thousandSeparatorAmount, TNLocalizedString(@"tn_bargain_take_away", @"拿走")];
        if (HDIsStringNotEmpty(model.clientNumberMsg)) {
            taskBtnStr = [taskBtnStr stringByAppendingFormat:@"\n%@", model.clientNumberMsg];
            smallStr = model.clientNumberMsg;
        }
        _createBargainTaskBtn.enabled = YES;
    } else {
        _createBargainTaskBtn.enabled = NO;
        taskBtnStr = TNLocalizedString(@"tn_bargain_end", @"已结束");
    }

    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:taskBtnStr];
    NSRange range = [taskBtnStr rangeOfString:smallStr];
    if (range.location != NSNotFound) {
        [attStr addAttribute:NSFontAttributeName value:[HDAppTheme.TinhNowFont fontSemibold:12.f] range:NSMakeRange(range.location, smallStr.length)];
    }
    [attStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, taskBtnStr.length)];

    [self.createBargainTaskBtn setAttributedTitle:attStr forState:UIControlStateNormal];

    [self setNeedsUpdateConstraints];
}

/// 默认样式
- (void)configDefaulStyle {
    self.buttonContainer.hidden = NO;
    self.customerServiceBtn.hidden = NO;
    self.buyNowBtn.hidden = NO;
    self.createBargainTaskBtn.hidden = NO;

    [self.customerServiceBtn sizeToFit];
    [self.customerServiceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20.0);
        make.centerY.equalTo(self.mas_top).offset(25.0);
    }];

    [self.buttonContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.customerServiceBtn.mas_right).offset(25);
        make.top.right.mas_equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(-kiPhoneXSeriesSafeBottomHeight);
    }];

    [self.buyNowBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.buttonContainer);
        make.width.equalTo(self.buttonContainer.mas_width).multipliedBy(0.35);
    }];

    [self.createBargainTaskBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.buttonContainer);
        make.width.equalTo(self.buttonContainer.mas_width).multipliedBy(0.65);
    }];
}

/// 分享样式
- (void)configShareStyle {
    self.bargainShareBtn.hidden = NO;
    [self.bargainShareBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.height.mas_equalTo(kRealHeight(49));
        make.bottom.equalTo(self.mas_bottom).offset(-kiPhoneXSeriesSafeBottomHeight);
    }];
}

/// 创建任务样式
- (void)configCreateTaskStyle {
    self.buttonContainer.hidden = NO;
    self.customerServiceBtn.hidden = NO;
    self.createBargainTaskBtn.hidden = NO;

    [self.customerServiceBtn sizeToFit];
    [self.customerServiceBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.centerY.equalTo(self.mas_top).offset(25.0);
        make.height.mas_equalTo(kRealHeight(49));
        make.width.equalTo(@(65));
    }];

    [self.buttonContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.customerServiceBtn.mas_right);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-kiPhoneXSeriesSafeBottomHeight);
        make.height.mas_equalTo(kRealHeight(49));
    }];

    [self.createBargainTaskBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.buttonContainer);
    }];
}

- (void)setAllViewHidden {
    self.bargainShareBtn.hidden = YES;
    self.customerServiceBtn.hidden = YES;
    self.buttonContainer.hidden = YES;
    self.buyNowBtn.hidden = YES;
    self.createBargainTaskBtn.hidden = YES;
}

#pragma mark -
- (UIView *)topLine {
    if (!_topLine) {
        _topLine = [[UIView alloc] init];
        _topLine.backgroundColor = HDAppTheme.TinhNowColor.lineColor;
    }
    return _topLine;
}

- (UIButton *)bargainShareBtn {
    if (!_bargainShareBtn) {
        _bargainShareBtn = [[UIButton alloc] init];
        _bargainShareBtn.backgroundColor = [UIColor hd_colorWithHexString:@"#F52138"];
        _bargainShareBtn.titleLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
        [_bargainShareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_bargainShareBtn setTitle:TNLocalizedString(@"tn_bargain_invite_friend", @"邀请好友助力") forState:UIControlStateNormal];
        _bargainShareBtn.hidden = YES;
        @HDWeakify(self);
        [_bargainShareBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.shareButtonClickedHander) {
                self.shareButtonClickedHander();
            }
        }];
    }
    return _bargainShareBtn;
}

- (HDUIButton *)customerServiceBtn {
    if (!_customerServiceBtn) {
        _customerServiceBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_customerServiceBtn setImagePosition:HDUIButtonImagePositionTop];
        [_customerServiceBtn setImage:[UIImage imageNamed:@"tinhnow_product_customer"] forState:UIControlStateNormal];
        [_customerServiceBtn setTitle:TNLocalizedString(@"tn_product_customer", @"Customer") forState:UIControlStateNormal];
        _customerServiceBtn.titleLabel.font = HDAppTheme.TinhNowFont.standard11;
        [_customerServiceBtn setTitleColor:HDAppTheme.TinhNowColor.G2 forState:UIControlStateNormal];
        _customerServiceBtn.hidden = YES;
        @HDWeakify(self);
        [_customerServiceBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.customerServiceButtonClickedHander) {
                self.customerServiceButtonClickedHander(self.storeNo);
            }
        }];
    }
    return _customerServiceBtn;
}

- (UIView *)buttonContainer {
    if (!_buttonContainer) {
        _buttonContainer = [[UIView alloc] init];
    }
    return _buttonContainer;
}

- (UIButton *)buyNowBtn {
    if (!_buyNowBtn) {
        _buyNowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _buyNowBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15.f];
        [_buyNowBtn setTitleColor:[UIColor whiteColor] forState:0];
        _buyNowBtn.backgroundColor = [UIColor hd_colorWithHexString:@"#FF9557"];
        _buyNowBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _buyNowBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        @HDWeakify(self);
        [_buyNowBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            NSString *originalIdStr = self.viewModel.productDetailsModel.productSource.originalId;
            if (self.buyNowButtonClickedHander && HDIsStringNotEmpty(originalIdStr)) {
                self.buyNowButtonClickedHander(originalIdStr);
            }
        }];
    }
    return _buyNowBtn;
}

- (UIButton *)createBargainTaskBtn {
    if (!_createBargainTaskBtn) {
        _createBargainTaskBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _createBargainTaskBtn.titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15.f];
        [_createBargainTaskBtn setTitleColor:[UIColor whiteColor] forState:0];
        [_createBargainTaskBtn setBackgroundImage:[UIImage hd_imageWithColor:[UIColor hd_colorWithHexString:@"#D6D6D6"]] forState:UIControlStateDisabled];
        [_createBargainTaskBtn setBackgroundImage:[UIImage hd_imageWithColor:HDAppTheme.TinhNowColor.R2] forState:UIControlStateNormal];
        _createBargainTaskBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _createBargainTaskBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        @HDWeakify(self);
        [_createBargainTaskBtn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.createTaskButtonClickedHander) {
                self.createTaskButtonClickedHander();
            }
        }];
    }
    return _createBargainTaskBtn;
}

@end
