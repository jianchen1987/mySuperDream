//
//  TNAdressChangeTipsAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2021/9/7.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "TNAdressChangeTipsAlertView.h"
#import "HDAppTheme+TinhNow.h"
#import "HDMediator+TinhNow.h"
#import "SAShoppingAddressModel.h"
#import "TNMultiLanguageManager.h"
#import "TNRedZoneActivityModel.h"
#import "TNView.h"
#import <HDKitCore/HDKitCore.h>
#import <Masonry/Masonry.h>


@interface TNActivityItemView : TNView
/// 容器
@property (strong, nonatomic) UIView *contentView;
/// 地址
@property (strong, nonatomic) UILabel *nameLabel;
/// go图片
@property (strong, nonatomic) UIImageView *goImageView;
/// 模型
@property (strong, nonatomic) TNRedZoneRecommendActivityModel *model;
/// 点击专题回调
@property (nonatomic, copy) void (^activityClickCallBack)(NSString *activityId);
@end


@implementation TNActivityItemView

- (void)hd_setupViews {
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.goImageView];
    [self addGestureRecognizer:self.hd_tapRecognizer];
}
- (void)hd_clickedViewHandler {
    !self.activityClickCallBack ?: self.activityClickCallBack(self.model.specialId);
}
- (void)setModel:(TNRedZoneRecommendActivityModel *)model {
    _model = model;
    self.nameLabel.text = model.specialName;
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.goImageView sizeToFit];
    [self.goImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(10));
    }];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(10));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(10));
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealWidth(10));
        make.right.lessThanOrEqualTo(self.goImageView.mas_left).offset(-kRealWidth(15));
    }];
    [self.goImageView setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.nameLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [super updateConstraints];
}
/** @lazy contentView */
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = HDAppTheme.TinhNowColor.C1;
        _contentView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _contentView;
}
/** @lazy nameLabel */
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.numberOfLines = 0;
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
    }
    return _nameLabel;
}
/** @lazy goImageView */
- (UIImageView *)goImageView {
    if (!_goImageView) {
        _goImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_go_image"]];
    }
    return _goImageView;
}
@end


@interface TNActivityListView : TNView
/// 专题列表数据
@property (strong, nonatomic) NSArray<TNRedZoneRecommendActivityModel *> *activityList;
/// 点击专题回调
@property (nonatomic, copy) void (^activityClickCallBack)(NSString *activityId);
@end


@implementation TNActivityListView

- (void)hd_setupViews {
    [self addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
}
- (void)setActivityList:(NSArray<TNRedZoneRecommendActivityModel *> *)activityList {
    _activityList = activityList;
    if (HDIsArrayEmpty(activityList)) {
        return;
    }
    [self.scrollViewContainer hd_removeAllSubviews];
    for (TNRedZoneRecommendActivityModel *model in activityList) {
        TNActivityItemView *itemView = [[TNActivityItemView alloc] init];
        itemView.model = model;
        @HDWeakify(self);
        itemView.activityClickCallBack = ^(NSString *activityId) {
            @HDStrongify(self);
            !self.activityClickCallBack ?: self.activityClickCallBack(activityId);
        };
        [self.scrollViewContainer addSubview:itemView];
    }
    [self setNeedsUpdateConstraints];
}

- (void)updateConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.height.equalTo(self.scrollView);
        make.width.equalTo(self.scrollView);
    }];
    UIView *lastView;
    for (UIView *view in self.scrollViewContainer.subviews) {
        [view mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (lastView) {
                make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(10));
            } else {
                make.top.equalTo(self.scrollViewContainer);
            }
            make.left.equalTo(self.scrollViewContainer.mas_left).offset(kRealWidth(10));
            make.right.equalTo(self.scrollViewContainer.mas_right).offset(-kRealWidth(10));
            if ([view isEqual:self.scrollViewContainer.subviews.lastObject]) {
                make.bottom.equalTo(self.scrollViewContainer.mas_bottom);
            }
        }];
        lastView = view;
    }

    [super updateConstraints];
}
@end


@interface TNAdressChangeTipsAlertView ()
/// 模型
@property (strong, nonatomic) TNAdressChangeTipsAlertConfig *config;
/// 背景
@property (strong, nonatomic) UIView *contentView;
/// 标题
@property (strong, nonatomic) UILabel *titleLabel;
///// 商家信息view
//@property (strong, nonatomic) UIView *merchantInfoView;
///// 配送范围
//@property (strong, nonatomic) UILabel *deliverAreaLabel;
///// 商家位置
//@property (strong, nonatomic) UILabel *locationLabel;

/// 店铺view
@property (strong, nonatomic) UIView *storeView;
/// 店铺名称
@property (strong, nonatomic) UILabel *storeNameLabel;
/// 店铺地址
@property (strong, nonatomic) UILabel *storeLocationLabel;
/// 店铺跳转提示图片
@property (strong, nonatomic) UIImageView *goImageView;
/// 顶部图片
@property (strong, nonatomic) UIImageView *topImageView;
/// 推荐专题列表数据
@property (strong, nonatomic) TNActivityListView *activityListView;
/// 关闭按钮
@property (strong, nonatomic) HDUIButton *closeBTN;
/// 按钮数组
@property (strong, nonatomic) NSMutableArray *btnArr;

@end


@implementation TNAdressChangeTipsAlertView

+ (instancetype)alertViewWithConfig:(TNAdressChangeTipsAlertConfig *)config {
    return [[TNAdressChangeTipsAlertView alloc] initWithConfig:config];
}
- (instancetype)initWithConfig:(TNAdressChangeTipsAlertConfig *)config {
    self = [super init];
    if (self) {
        self.config = config;
        self.backgroundStyle = HDActionAlertViewBackgroundStyleSolid;
        self.transitionStyle = HDActionAlertViewTransitionStyleBounce;
        self.allowTapBackgroundDismiss = YES;
    }
    return self;
}
//去店铺
- (void)gotoStore {
    [self dismiss];
    if (HDIsStringNotEmpty(self.config.storeNo)) {
        [HDMediator.sharedInstance navigaveToTinhNowStoreInfoViewController:@{@"storeNo": self.config.storeNo}];
    }
}
//去查看配送区域
- (void)gotoDeliveryAreaMap {
    [self dismiss];
    if (HDIsStringNotEmpty(self.config.storeNo)) {
        [HDMediator.sharedInstance navigaveToTinhNowDeliveryAreaMapViewController:@{@"storeNo": self.config.storeNo, @"addressModel": self.config.addressModel}];
    }
}
//去配送区域
- (void)layoutContainerView {
    self.containerView.frame = [UIScreen mainScreen].bounds;
}
/// 设置containerview的属性,比如切边啥的
- (void)setupContainerViewAttributes {
    self.containerView.backgroundColor = [UIColor clearColor];
    self.containerView.layer.masksToBounds = YES;
}
/// 给containerview添加子视图
- (void)setupContainerSubViews {
    [self.containerView addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    //    [self.contentView addSubview:self.confirmBtn];

    if (self.config.alertType == TNAdressTipsAlertTypeDeliveryArea) {
        //配送区域
        //        [self.contentView addSubview:self.merchantInfoView];
        //        [self.merchantInfoView addSubview:self.deliverAreaLabel];
        //        [self.merchantInfoView addSubview:self.locationLabel];
        [self.contentView addSubview:self.closeBTN];
        //        [self.confirmBtn setTitle:TNLocalizedString(@"SugnLs2V", @"查看配送区域") forState:UIControlStateNormal];
        //        self.deliverAreaLabel.text = [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"hwwfhcdv", @"配送范围"), self.config.deliveryArea];
        //        self.locationLabel.text = [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"1UMplpCn", @"商家位置"), self.config.storeLocation];
    } else if (self.config.alertType == TNAdressTipsAlertTypeChooseStore) {
        //店铺推荐
        [self.contentView addSubview:self.storeView];
        [self.storeView addSubview:self.storeNameLabel];
        [self.storeView addSubview:self.storeLocationLabel];
        [self.storeView addSubview:self.goImageView];
        //        [self.confirmBtn setTitle:TNLocalizedString(@"GXNehJLg", @"去购买") forState:UIControlStateNormal];
        self.storeNameLabel.text = self.config.storeName;
        self.storeLocationLabel.text = self.config.storeLocation;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoStore)];
        [self.storeView addGestureRecognizer:tap];
    } else if (self.config.alertType == TNAdressTipsAlertTypeConfirm) {
        //提示  只有确定按钮
        //        [self.contentView addSubview:self.merchantInfoView];
        //        [self.merchantInfoView addSubview:self.deliverAreaLabel];
        //        [self.merchantInfoView addSubview:self.locationLabel];
        //        [self.confirmBtn setTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定") forState:UIControlStateNormal];
        //        self.deliverAreaLabel.text = [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"hwwfhcdv", @"配送范围"), self.config.deliveryArea];
        //        self.locationLabel.text = [NSString stringWithFormat:@"%@: %@", TNLocalizedString(@"1UMplpCn", @"商家位置"), self.config.storeLocation];
    } else if (self.config.alertType == TNAdressTipsAlertTypeChooseAdress) {
        [self.contentView addSubview:self.topImageView];
        //        [self.confirmBtn setTitle:TNLocalizedString(@"lps6Jl61", @"选择收货地址") forState:UIControlStateNormal];
        self.titleLabel.font = HDAppTheme.TinhNowFont.standard14;
    } else if (self.config.alertType == TNAdressTipsAlertTypeActivityList) {
        [self.contentView addSubview:self.activityListView];
        self.activityListView.activityList = self.config.activityList;
        @HDWeakify(self);
        self.activityListView.activityClickCallBack = ^(NSString *activityId) {
            @HDStrongify(self);
            !self.activityClickCallBack ?: self.activityClickCallBack(activityId);
            [self dismiss];
        };
        //        [self.confirmBtn setTitle:TNLocalizedString(@"lps6Jl61", @"选择收货地址") forState:UIControlStateNormal];
    }

    self.titleLabel.text = self.config.title;
    //添加按钮
    if (!HDIsArrayEmpty(self.config.actions)) {
        [self.btnArr removeAllObjects];
        @HDWeakify(self);
        for (int i = 0; i < self.config.actions.count; i++) {
            TNAlertAction *action = self.config.actions[i];
            HDUIButton *btn = [[HDUIButton alloc] init];
            [btn setTitleColor:action.textColor forState:UIControlStateNormal];
            btn.backgroundColor = action.backgroundColor;
            btn.titleLabel.font = action.font;
            [btn setTitle:action.title forState:UIControlStateNormal];
            [btn addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
                @HDStrongify(self);
                [self dismiss];
                !action.actionClickCallBack ?: action.actionClickCallBack(action);
            }];
            [self.contentView addSubview:btn];
            if (i != self.config.actions.count - 1) {
                //分割线
                btn.hd_borderPosition = HDViewBorderPositionBottom;
                btn.hd_borderColor = HexColor(0xEBEDF0);
                btn.hd_borderWidth = 0.5;
                btn.hd_borderLocation = HDViewBorderLocationInside;
            }
            [self.btnArr addObject:btn];
        }
    }
}

/// 子视图布局
- (void)layoutContainerViewSubViews {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.containerView);
        make.left.equalTo(self.containerView.mas_left).offset(kRealWidth(35));
        make.right.equalTo(self.containerView.mas_left).offset(-kRealWidth(35));
    }];

    UIView *lastView = nil;
    if (self.config.alertType == TNAdressTipsAlertTypeChooseStore) {
        //修改地址
        lastView = self.storeView;

        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(20));
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(20));
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(20));
        }];

        [self.storeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(20));
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(10));
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(10));
        }];
        [self.storeNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.storeView.mas_top).offset(kRealWidth(10));
            make.left.equalTo(self.storeView.mas_left).offset(kRealWidth(10));
            make.right.lessThanOrEqualTo(self.goImageView.mas_left).offset(-kRealWidth(10));
        }];
        [self.goImageView sizeToFit];
        [self.goImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.storeNameLabel.mas_centerY);
            make.right.equalTo(self.storeView.mas_right).offset(-kRealWidth(10));
        }];
        [self.storeLocationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.storeView.mas_bottom).offset(-kRealWidth(10));
            make.left.equalTo(self.storeView.mas_left).offset(kRealWidth(10));
            make.top.equalTo(self.storeNameLabel.mas_bottom).offset(kRealWidth(10));
            make.right.equalTo(self.storeView.mas_right).offset(-kRealWidth(10));
        }];
    } else if (self.config.alertType == TNAdressTipsAlertTypeDeliveryArea || self.config.alertType == TNAdressTipsAlertTypeConfirm) {
        lastView = self.titleLabel;

        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            //            make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(20));
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(20));
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(20));
            make.centerY.equalTo(self.contentView.mas_centerY).offset(-kRealWidth(20));
            make.height.mas_equalTo(kRealHeight(80));
        }];

        //        [self.merchantInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(20));
        //            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(20));
        //            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(20));
        //        }];
        //        [self.deliverAreaLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        //            make.left.top.right.equalTo(self.merchantInfoView);
        //        }];
        //        [self.locationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        //            make.left.bottom.right.equalTo(self.merchantInfoView);
        //            make.top.equalTo(self.deliverAreaLabel.mas_bottom).offset(kRealWidth(10));
        //        }];
        if (self.config.alertType == TNAdressTipsAlertTypeDeliveryArea) {
            [self.closeBTN mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(8));
                make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(8));
                make.size.mas_equalTo(CGSizeMake(13, 13));
            }];
        }

    } else if (self.config.alertType == TNAdressTipsAlertTypeChooseAdress) {
        lastView = self.titleLabel;
        [self.topImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
            make.height.equalTo(self.topImageView.mas_width).multipliedBy(0.3);
        }];

        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topImageView.mas_bottom).offset(kRealWidth(20));
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(15));
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        }];
    } else if (self.config.alertType == TNAdressTipsAlertTypeActivityList) {
        lastView = self.activityListView;
        [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(20));
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(20));
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(20));
        }];
        [self.activityListView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(kRealWidth(20));
        }];
    }
    if (!HDIsArrayEmpty(self.btnArr)) {
        HDUIButton *lastBtn = nil;
        for (int i = 0; i < self.btnArr.count; i++) {
            HDUIButton *btn = self.btnArr[i];
            [btn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(kRealWidth(45));
                make.left.right.equalTo(self.contentView);
                if (lastBtn) {
                    make.top.equalTo(lastBtn.mas_bottom);
                } else {
                    make.top.equalTo(lastView.mas_bottom).offset(kRealWidth(20));
                }
                if (i == self.btnArr.count - 1) {
                    make.bottom.equalTo(self.contentView);
                }
            }];
            lastBtn = btn;
        }
    }
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor hd_colorWithHexString:@"#FFFFFF"];
        _contentView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:8];
        };
    }
    return _contentView;
}
/** @lazy titleLabel */
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _titleLabel.font = [HDAppTheme.TinhNowFont fontSemibold:15];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

///** @lazy deliverAreaLabel */
//- (UILabel *)deliverAreaLabel {
//    if (!_deliverAreaLabel) {
//        _deliverAreaLabel = [[UILabel alloc] init];
//        _deliverAreaLabel.textColor = HDAppTheme.TinhNowColor.G1;
//        _deliverAreaLabel.font = HDAppTheme.TinhNowFont.standard12;
//        _deliverAreaLabel.numberOfLines = 0;
//    }
//    return _deliverAreaLabel;
//}
///** @lazy deliverAreaLabel */
//- (UILabel *)locationLabel {
//    if (!_locationLabel) {
//        _locationLabel = [[UILabel alloc] init];
//        _locationLabel.textColor = HDAppTheme.TinhNowColor.G1;
//        _locationLabel.font = HDAppTheme.TinhNowFont.standard12;
//        _locationLabel.numberOfLines = 0;
//    }
//    return _locationLabel;
//}

///** @lazy merchantInfoView */
//- (UIView *)merchantInfoView {
//    if (!_merchantInfoView) {
//        _merchantInfoView = [[UIView alloc] init];
//    }
//    return _merchantInfoView;
//}
/** @lazy storeView */
- (UIView *)storeView {
    if (!_storeView) {
        _storeView = [[UIView alloc] init];
        _storeView.backgroundColor = HDAppTheme.TinhNowColor.C1;
        _storeView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _storeView;
}
/** @lazy storeNameLabel */
- (UILabel *)storeNameLabel {
    if (!_storeNameLabel) {
        _storeNameLabel = [[UILabel alloc] init];
        _storeNameLabel.textColor = [UIColor whiteColor];
        _storeNameLabel.font = [HDAppTheme.TinhNowFont fontMedium:12];
    }
    return _storeNameLabel;
}
/** @lazy storeLocationLabel */
- (UILabel *)storeLocationLabel {
    if (!_storeLocationLabel) {
        _storeLocationLabel = [[UILabel alloc] init];
        _storeLocationLabel.textColor = [UIColor whiteColor];
        _storeLocationLabel.font = HDAppTheme.TinhNowFont.standard12;
        _storeLocationLabel.numberOfLines = 0;
    }
    return _storeLocationLabel;
}
/** @lazy goImageView */
- (UIImageView *)goImageView {
    if (!_goImageView) {
        _goImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_go_image"]];
    }
    return _goImageView;
}
/** @lazy topImageView */
- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_map_tip_image"]];
    }
    return _topImageView;
}
/** @lazy activityListView */
- (TNActivityListView *)activityListView {
    if (!_activityListView) {
        _activityListView = [[TNActivityListView alloc] init];
    }
    return _activityListView;
}
- (HDUIButton *)closeBTN {
    if (!_closeBTN) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        button.adjustsButtonWhenHighlighted = false;
        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            [self dismiss];
        }];
        _closeBTN = button;
    }
    return _closeBTN;
}
/** @lazy btnArr */
- (NSMutableArray *)btnArr {
    if (!_btnArr) {
        _btnArr = [NSMutableArray array];
    }
    return _btnArr;
}
@end
