//
//  TNSelectDeliveryTimeAlertView.m
//  SuperApp
//
//  Created by 张杰 on 2022/2/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "TNSelectDeliveryTimeAlertView.h"
#import "HDAppTheme+TinhNow.h"
#import "NSDate+SAExtension.h"
#import "SAOperationButton.h"
#import "SATableViewCell.h"
#import "TNMultiLanguageManager.h"
#import <HDKitCore/HDKitCore.h>
#import <Masonry/Masonry.h>
#import "UIColor+Extend.h"

@interface TNTimeLeftCell : SATableViewCell
///日期
@property (strong, nonatomic) UILabel *dateLabel;
///
@property (strong, nonatomic) TNCalcDateModel *model;
///
@property (strong, nonatomic) UIImageView *bubleImageView;
///
@property (strong, nonatomic) UILabel *tipsLabel;
@end


@implementation TNTimeLeftCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.dateLabel];
    [self.contentView addSubview:self.bubleImageView];
    [self.bubleImageView addSubview:self.tipsLabel];
}
- (void)setModel:(TNCalcDateModel *)model {
    _model = model;
    self.dateLabel.text = model.showDate;
    self.contentView.backgroundColor = model.isSelected ? [UIColor whiteColor] : HDAppTheme.TinhNowColor.G5;
    if (model.full) {
        if (model.isSelected) {
            self.bubleImageView.hidden = YES;
        } else {
            self.bubleImageView.hidden = NO;
        }
    } else {
        self.bubleImageView.hidden = YES;
    }
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    [self.dateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        if (self.bubleImageView.isHidden) {
            make.centerY.equalTo(self.contentView);
        } else {
            make.centerY.equalTo(self.contentView).offset(-kRealWidth(8));
        }
    }];
    [self.bubleImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateLabel.mas_bottom).offset(1);
        make.centerX.equalTo(self.contentView);
    }];

    [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bubleImageView.mas_left).offset(8);
        make.right.equalTo(self.bubleImageView.mas_right).offset(-8);
        make.top.equalTo(self.bubleImageView.mas_top).offset(4);
        make.bottom.equalTo(self.bubleImageView.mas_bottom).offset(-1);
    }];

    [super updateConstraints];
}
/** @lazy dateLabel */
- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = HDAppTheme.TinhNowFont.standard12;
        _dateLabel.textAlignment = NSTextAlignmentCenter;
        _dateLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _dateLabel.numberOfLines = 2;
        //        _dateLabel.backgroundColor = HDAppTheme.TinhNowColor.G5;
    }
    return _dateLabel;
}
/** @lazy bubleImageView */
- (UIImageView *)bubleImageView {
    if (!_bubleImageView) {
        _bubleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tn_bubble_black"]];
    }
    return _bubleImageView;
}
/** @lazy tipsLabel */
- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _tipsLabel.font = [HDAppTheme.TinhNowFont fontRegular:10];
        _tipsLabel.text = TNLocalizedString(@"tn_full", @"已满");
    }
    return _tipsLabel;
}
@end


@interface TNTimeRightCell : SATableViewCell
/// 时间
@property (strong, nonatomic) UILabel *timeLabel;
///
@property (strong, nonatomic) UILabel *freightLabel;
///
@property (strong, nonatomic) HDLabel *freeFreightTagLabel;
/// 选择按钮
@property (strong, nonatomic) HDUIButton *selectedBtn;
/// 预约已满提示文案
@property (strong, nonatomic) UILabel *tipsLabel;
/// 布局容器
@property (strong, nonatomic) UIView *centerBgView;
/// 下划线
@property (strong, nonatomic) UIView *lineView;
///
@property (strong, nonatomic) TNCalcTimeModel *model;
@end


@implementation TNTimeRightCell
- (void)hd_setupViews {
    [self.contentView addSubview:self.centerBgView];
    [self.contentView addSubview:self.tipsLabel];
    [self.centerBgView addSubview:self.timeLabel];
    [self.centerBgView addSubview:self.freightLabel];
    [self.centerBgView addSubview:self.freeFreightTagLabel];
    [self.contentView addSubview:self.selectedBtn];
    [self.contentView addSubview:self.lineView];
}
- (void)setModel:(TNCalcTimeModel *)model {
    _model = model;
    //    NSString *freight = HDIsObjectNil(model.freight) ? [NSString stringWithFormat:@"%@$0.00", TNLocalizedString(@"tn_delivery_fee", @"运费")]
    //                                                     : [NSString stringWithFormat:@"%@%@", TNLocalizedString(@"tn_delivery_fee", @"运费"), model.freight.thousandSeparatorAmount];
    //    NSString *time = model.timeStr;
    //    self.timeLabel.text = [NSString stringWithFormat:@"%@ %@", time, freight];
    ///运营要求预约时间弹窗隐藏运费显示  15/8 2022
    ///有立即送达的额外运费要展示  快消品3.5.0
    ///预约送达如果设置了运费  也要显示运费  11/4 2023
    //    if (!HDIsObjectNil(model.immediateDeliveryFreight) && [model.immediateDeliveryFreight.cent integerValue] > 0) {
    //        NSString *freight = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"UTgNWIp6", @"额外运费"), model.immediateDeliveryFreight.thousandSeparatorAmount];
    //        self.timeLabel.text = [NSString stringWithFormat:@"%@ %@", model.timeStr, freight];
    //    } else {
    //        self.timeLabel.text = model.timeStr;
    //    }
    NSString *time = model.timeStr;
    if (HDIsStringNotEmpty(time) && HDIsStringNotEmpty(model.date)) {
        time = [NSString stringWithFormat:@"%@ %@", model.date, model.timeStr];
    }
    self.timeLabel.text = time;
    if (model.full) {
        self.selectedBtn.enabled = NO;
        self.timeLabel.textColor = HexColor(0x999999);
        self.tipsLabel.hidden = NO;
        self.selectedBtn.selected = NO;

        self.freightLabel.hidden = YES;
        self.freeFreightTagLabel.hidden = YES;

    } else {
        self.selectedBtn.enabled = YES;
        self.timeLabel.textColor = model.isSelected ? HDAppTheme.TinhNowColor.C1 : HDAppTheme.TinhNowColor.G1;
        self.tipsLabel.hidden = YES;
        self.selectedBtn.selected = model.isSelected;

        if (!HDIsObjectNil(model.additionalFreight) && [model.additionalFreight.cent integerValue] > 0) {
            self.freightLabel.hidden = NO;
            self.freeFreightTagLabel.hidden = YES;
            self.freightLabel.text = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"tn_delivery_fee", @"运费"), model.additionalFreight.thousandSeparatorAmount];
            self.freightLabel.textColor = model.isSelected ? HDAppTheme.TinhNowColor.C1 : HDAppTheme.TinhNowColor.G1;
        } else {
            self.freightLabel.hidden = YES;
            self.freeFreightTagLabel.hidden = NO;
        }
    }
    [self setNeedsUpdateConstraints];
}
- (void)updateConstraints {
    if (!self.freightLabel.isHidden && self.freeFreightTagLabel.isHidden) {
        [self.centerBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(kRealHeight(6));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealHeight(6));
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(20));
            make.right.lessThanOrEqualTo(self.selectedBtn.mas_left).offset(-kRealWidth(10));
        }];
        [self.timeLabel sizeToFit];
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.centerBgView);
        }];
        [self.freightLabel sizeToFit];
        [self.freightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.centerBgView);
        }];
    } else if (self.freightLabel.isHidden && !self.freeFreightTagLabel.isHidden) {
        [self.centerBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).offset(kRealHeight(6));
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealHeight(6));
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(20));
            make.right.lessThanOrEqualTo(self.selectedBtn.mas_left).offset(-kRealWidth(10));
        }];
        [self.timeLabel sizeToFit];
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.centerBgView);
        }];
        [self.freeFreightTagLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.centerBgView);
        }];
    } else if (self.freightLabel.isHidden && self.freeFreightTagLabel.isHidden) {
        [self.centerBgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(20));
            make.right.lessThanOrEqualTo(self.selectedBtn.mas_left).offset(-kRealWidth(10));
        }];
        [self.timeLabel sizeToFit];
        [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.centerBgView);
        }];
    }
    [self.selectedBtn sizeToFit];
    [self.selectedBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.centerBgView);
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
    }];
    if (!self.tipsLabel.isHidden) {
        [self.tipsLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.centerBgView);
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(15));
        }];
    }
    [self.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(0.5);
    }];
    [self.selectedBtn setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.centerBgView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
    [super updateConstraints];
}
/** @lazy timeLabel */
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = HDAppTheme.TinhNowFont.standard12;
        _timeLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _timeLabel.numberOfLines = 2;
    }
    return _timeLabel;
}
/** @lazy selectedBtn */
- (HDUIButton *)selectedBtn {
    if (!_selectedBtn) {
        _selectedBtn = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_selectedBtn setImage:[UIImage imageNamed:@"tn_deliverytime_unselected"] forState:UIControlStateNormal];
        [_selectedBtn setImage:[UIImage imageNamed:@"tn_deliverytime_selected"] forState:UIControlStateSelected];
        [_selectedBtn setImage:[UIImage imageNamed:@"tn_deliverytime_disabled"] forState:UIControlStateDisabled];
        _selectedBtn.userInteractionEnabled = NO;
    }
    return _selectedBtn;
}
/** @lazy tipsLabel */
- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.textColor = HexColor(0x999999);
        _tipsLabel.font = HDAppTheme.TinhNowFont.standard11;
        _tipsLabel.text = TNLocalizedString(@"tn_reserve_full", @"预约已满");
    }
    return _tipsLabel;
}
/** @lazy centerBgView */
- (UIView *)centerBgView {
    if (!_centerBgView) {
        _centerBgView = [[UIView alloc] init];
    }
    return _centerBgView;
}
/** @lazy freightLabel */
- (UILabel *)freightLabel {
    if (!_freightLabel) {
        _freightLabel = [[UILabel alloc] init];
        _freightLabel.font = HDAppTheme.TinhNowFont.standard12;
    }
    return _freightLabel;
}
/** @lazy freeFreightTagLabel */
- (HDLabel *)freeFreightTagLabel {
    if (!_freeFreightTagLabel) {
        _freeFreightTagLabel = [[HDLabel alloc] init];
        _freeFreightTagLabel.font = [HDAppTheme.TinhNowFont fontRegular:10];
        _freeFreightTagLabel.textColor = [UIColor whiteColor];
        _freeFreightTagLabel.hd_edgeInsets = UIEdgeInsetsMake(1, 8, 1, 8);
        _freeFreightTagLabel.textAlignment = NSTextAlignmentCenter;
        _freeFreightTagLabel.text = TNLocalizedString(@"ctJWOdqh", @"免运费");
        _freeFreightTagLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:2];
            view.backgroundColor = [UIColor tn_colorGradientChangeWithSize:precedingFrame.size direction:TNGradientChangeDirectionLevel startColor:HexColor(0xFF9837) endColor:HexColor(0xED590C)];
        };
        [_freeFreightTagLabel sizeToFit];
    }
    return _freeFreightTagLabel;
}
/** @lazy lineView */
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HexColor(0xE9EAEF);
    }
    return _lineView;
}
@end


//立即送达cell
@interface TNImmediateDeliveryRightCell : SATableViewCell
///
@property (strong, nonatomic) UILabel *freightLabel;
///
@property (strong, nonatomic) HDLabel *explanationLabel;
///
@property (strong, nonatomic) HDUIButton *agreeButton;
///
@property (strong, nonatomic) SAOperationButton *confirmButton;
/// 立即送达数据
@property (strong, nonatomic) TNImmediateDeliveryModel *model;
/// 确认按钮点击回调
@property (nonatomic, copy) void (^confirmClickCalBack)(void);
@end

@implementation TNImmediateDeliveryRightCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.freightLabel];
    [self.contentView addSubview:self.explanationLabel];
    [self.contentView addSubview:self.agreeButton];
    [self.contentView addSubview:self.confirmButton];
}
- (void)setModel:(TNImmediateDeliveryModel *)model {
    _model = model;
    self.agreeButton.selected = model.agreeImmediateDelivery;
    self.freightLabel.text = [NSString stringWithFormat:@"%@ %@", TNLocalizedString(@"UTgNWIp6", @"额外运费"), model.freight.thousandSeparatorAmount];
    self.explanationLabel.hidden = HDIsStringEmpty(model.serviceDesc);
    self.explanationLabel.text = model.serviceDesc;
}
- (void)updateConstraints {
    [self.freightLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        make.top.equalTo(self.contentView.mas_top).offset(kRealWidth(12));
        make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
    }];
    if (!self.explanationLabel.isHidden) {
        [self.explanationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(12));
            make.top.equalTo(self.freightLabel.mas_bottom).offset(kRealWidth(8));
            make.right.equalTo(self.contentView.mas_right).offset(-kRealWidth(12));
        }];
    }

    [self.agreeButton sizeToFit];
    [self.agreeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(kRealWidth(12));
        if (!self.explanationLabel.isHidden) {
            make.top.equalTo(self.explanationLabel.mas_bottom).offset(kRealWidth(16));
        } else {
            make.top.equalTo(self.freightLabel.mas_bottom).offset(kRealWidth(20));
        }
    }];
    [self.confirmButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.agreeButton.mas_bottom).offset(kRealHeight(27));
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-kRealHeight(30));
    }];
    [super updateConstraints];
}
/** @lazy freightLabel */
- (UILabel *)freightLabel {
    if (!_freightLabel) {
        _freightLabel = [[UILabel alloc] init];
        _freightLabel.font = [HDAppTheme.TinhNowFont fontSemibold:16];
        _freightLabel.textColor = HDAppTheme.TinhNowColor.G1;
        _freightLabel.numberOfLines = 0;
    }
    return _freightLabel;
}
/** @lazy explanationLabel */
- (HDLabel *)explanationLabel {
    if (!_explanationLabel) {
        _explanationLabel = [[HDLabel alloc] init];
        _explanationLabel.font = HDAppTheme.TinhNowFont.standard12;
        _explanationLabel.textColor = HexColor(0x9F8153);
        _explanationLabel.backgroundColor = [HDAppTheme.TinhNowColor.cFF8824 colorWithAlphaComponent:0.1];
        _explanationLabel.numberOfLines = 0;
        _explanationLabel.hd_edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        _explanationLabel.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:4];
        };
    }
    return _explanationLabel;
}
/** @lazy agreeButton */
- (HDUIButton *)agreeButton {
    if (!_agreeButton) {
        _agreeButton = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [_agreeButton setImage:[UIImage imageNamed:@"tn_deliverytime_unselected"] forState:UIControlStateNormal];
        [_agreeButton setImage:[UIImage imageNamed:@"tn_deliverytime_selected"] forState:UIControlStateSelected];
        [_agreeButton setTitle:TNLocalizedString(@"8NS0KvHv", @"同意") forState:UIControlStateNormal];
        _agreeButton.spacingBetweenImageAndTitle = kRealWidth(6);
        _agreeButton.titleLabel.font = HDAppTheme.TinhNowFont.standard12;
        [_agreeButton setTitleColor:HDAppTheme.TinhNowColor.G1 forState:UIControlStateNormal];
        @HDWeakify(self);
        [_agreeButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            self.model.agreeImmediateDelivery = !self.model.agreeImmediateDelivery;
            btn.selected = self.model.agreeImmediateDelivery;
        }];
    }
    return _agreeButton;
}
/** @lazy confirmButton */
- (SAOperationButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
        [_confirmButton applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.cFF8F1A];
        [_confirmButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:14];
        [_confirmButton setTitle:TNLocalizedString(@"N3BS7pn3", @"确认") forState:UIControlStateNormal];
        _confirmButton.titleEdgeInsets = UIEdgeInsetsMake(kRealHeight(5), kRealWidth(36), kRealHeight(5), kRealWidth(36));
        @HDWeakify(self);
        [_confirmButton addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            @HDStrongify(self);
            if (self.model.agreeImmediateDelivery) {
                !self.confirmClickCalBack ?: self.confirmClickCalBack();
            } else {
                [HDTips showInfo:TNLocalizedString(@"YopSSoSE", @"请勾选同意按钮") inView:self];
            }
        }];
        [_confirmButton sizeToFit];
    }
    return _confirmButton;
}
@end


@interface TNSelectDeliveryTimeAlertView () <UITableViewDelegate, UITableViewDataSource>
/// 标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 关闭按钮
@property (nonatomic, strong) HDUIButton *closeBTN;
/// 确定按钮
//@property (nonatomic, strong) SAOperationButton *doneBtn;
///
@property (strong, nonatomic) UIView *tableViewContainer;
/// 左边一级分类
@property (strong, nonatomic) UITableView *leftTableView;
/// 左边一级分类
@property (strong, nonatomic) UITableView *rightTableView;
/// 日期数据源
@property (strong, nonatomic) NSMutableArray<TNCalcDateModel *> *leftDataArr;
///
@property (strong, nonatomic) NSArray *rightDataArr;
/// 时间选中需要滚动的index
@property (nonatomic, assign) NSInteger scrollerIndex;
/// 立即送达数据
@property (strong, nonatomic) TNImmediateDeliveryModel *immediateDeliveryModel;
@end


@implementation TNSelectDeliveryTimeAlertView

- (instancetype)initWithDataArr:(NSArray<TNCalcDateModel *> *)dataArr
           selectedDeliveryTime:(NSString *)selectedDeliveryTime
        selectedAppointmentType:(TNOrderAppointmentType)selectedAppointmentType
                          title:(nonnull NSString *)title
         immediateDeliveryModel:(TNImmediateDeliveryModel *)immediateDeliveryModel {
    if (self = [super init]) {
        self.leftDataArr = [NSMutableArray arrayWithArray:dataArr];
        self.immediateDeliveryModel = immediateDeliveryModel;
        //拼接立即送达
        if (!HDIsObjectNil(self.immediateDeliveryModel)) {
            TNCalcDateModel *model = [[TNCalcDateModel alloc] init];
            model.showDate = TNLocalizedString(@"ycHB01cL", @"立即送达");
            model.isImmediateDeliveryItem = YES;
            if (selectedAppointmentType == TNOrderAppointmentTypeImmediately) {
                model.isSelected = YES;
                self.immediateDeliveryModel.agreeImmediateDelivery = YES;
                self.rightDataArr = @[self.immediateDeliveryModel];
            }
            [self.leftDataArr addObject:model];
        }

        if (HDIsStringNotEmpty(selectedDeliveryTime)) {
            NSArray<NSString *> *tempArr = [selectedDeliveryTime componentsSeparatedByString:@" "];
            if (tempArr.count == 2) {
                NSString *date = HDIsStringNotEmpty(tempArr.firstObject) ? tempArr.firstObject : @"";
                NSString *time = HDIsStringNotEmpty(tempArr.lastObject) ? tempArr.lastObject : @"";
                __block BOOL bigo = NO;
                [self.leftDataArr enumerateObjectsUsingBlock:^(TNCalcDateModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    if ([obj.date isEqualToString:date]) {
                        bigo = YES;
                        obj.isSelected = YES;
                        self.rightDataArr = obj.deliveryTimeList;
                        [obj.deliveryTimeList enumerateObjectsUsingBlock:^(TNCalcTimeModel *_Nonnull subObj, NSUInteger idx, BOOL *_Nonnull stop) {
                            if (HDIsStringNotEmpty(subObj.timeStr) && [subObj.timeStr isEqualToString:time]) {
                                subObj.isSelected = YES;
                                self.scrollerIndex = idx;
                                *stop = YES;
                            }
                        }];
                        *stop = YES;
                    }
                }];
                if (bigo == NO) {
                    [self setFirstDataSelectedWithselectedDeliveryTime:selectedDeliveryTime];
                }
            } else {
                if (selectedAppointmentType != TNOrderAppointmentTypeImmediately) {
                    [self setFirstDataSelectedWithselectedDeliveryTime:selectedDeliveryTime];
                }
            }
        } else {
            [self setFirstDataSelectedWithselectedDeliveryTime:selectedDeliveryTime];
        }
        self.titleLabel.text = title;
        self.transitionStyle = HDActionAlertViewTransitionStyleSlideFromBottom;
    }
    return self;
}
/// 设置 第一个数据选中
- (void)setFirstDataSelectedWithselectedDeliveryTime:(NSString *)selectedDeliveryTime {
    if (!HDIsArrayEmpty(self.leftDataArr)) {
        TNCalcDateModel *leftModel = self.leftDataArr.firstObject;
        leftModel.isSelected = YES;
        self.rightDataArr = leftModel.deliveryTimeList;
        [self.rightDataArr enumerateObjectsUsingBlock:^(TNCalcTimeModel *_Nonnull subObj, NSUInteger idx, BOOL *_Nonnull stop) {
            if (HDIsStringNotEmpty(selectedDeliveryTime) & HDIsStringNotEmpty(subObj.timeStr) && [subObj.timeStr isEqualToString:selectedDeliveryTime]) {
                subObj.isSelected = YES;
                self.scrollerIndex = idx;
                *stop = YES;
            }
        }];
    }
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
    self.allowTapBackgroundDismiss = YES;
    self.containerView.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerTopLeft | UIRectCornerTopRight radius:10];
    };
}

- (void)setupContainerSubViews {
    [self.containerView addSubview:self.titleLabel];
    [self.containerView addSubview:self.closeBTN];
    [self.containerView addSubview:self.tableViewContainer];
    [self.tableViewContainer addSubview:self.leftTableView];
    [self.tableViewContainer addSubview:self.rightTableView];
    //    [self.containerView addSubview:self.doneBtn];

    [self.leftTableView reloadData];


    [self.rightTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.scrollerIndex > 3 && self.scrollerIndex < self.rightDataArr.count) {
            [self.rightTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.scrollerIndex inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }

        if (self.immediateDeliveryModel.agreeImmediateDelivery && !HDIsArrayEmpty(self.leftDataArr)) {
            [self.leftTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.leftDataArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    });

    @HDWeakify(self);
    self.didDismissHandler = ^(HDActionAlertView *_Nonnull alertView) {
        @HDStrongify(self);
        [self.leftDataArr enumerateObjectsUsingBlock:^(TNCalcDateModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.isSelected = NO;
            [obj.deliveryTimeList enumerateObjectsUsingBlock:^(TNCalcTimeModel *_Nonnull subObj, NSUInteger idx, BOOL *_Nonnull stop) {
                subObj.isSelected = NO;
            }];
        }];
    };
}

- (void)layoutContainerViewSubViews {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self.containerView);
        make.height.mas_equalTo(kRealWidth(50));
    }];
    [self.closeBTN sizeToFit];
    [self.closeBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.right.equalTo(self.containerView.mas_right).offset(-kRealWidth(15));
    }];
    [self.tableViewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.containerView);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.mas_equalTo(kRealWidth(350));
        make.bottom.equalTo(self.containerView.mas_bottom).offset(-kiPhoneXSeriesSafeBottomHeight);
    }];
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.tableViewContainer);
        make.width.mas_equalTo(kRealWidth(100));
    }];
    [self.rightTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.tableViewContainer);
        make.left.equalTo(self.leftTableView.mas_right);
    }];
    //    [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.left.right.equalTo(self.containerView);
    //        make.height.mas_equalTo(kRealWidth(45));
    //        make.top.equalTo(self.tableViewContainer.mas_bottom);
    //        make.bottom.equalTo(self.containerView.mas_bottom).offset(-kiPhoneXSeriesSafeBottomHeight);
    //    }];
}
#pragma mark -确认点击
- (void)doneClick {
    __block NSString *date = nil;
    __block NSString *time = nil;
    __block NSString *showStr = nil;
    __block SAMoneyModel *additionalFreight = nil;
    __block TNOrderAppointmentType appointmentType = TNOrderAppointmentTypeReserve;
    [self.leftDataArr enumerateObjectsUsingBlock:^(TNCalcDateModel *_Nonnull dateObj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (dateObj.isSelected) {
            date = dateObj.date;
            [self.rightDataArr enumerateObjectsUsingBlock:^(TNCalcTimeModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                if (obj.isSelected) {
                    time = obj.timeStr;
                    additionalFreight = obj.additionalFreight;
                    showStr = obj.immediateDeliveryStr;
                    if (obj.appointmentType == TNOrderAppointmentTypeImmediately) {
                        appointmentType = TNOrderAppointmentTypeImmediately;
                    }
                    //                    if (HDIsStringNotEmpty(obj.soonDelivery)) {
                    //                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    //                        [formatter setDateFormat:@"dd/MM/yyyy"];
                    //                        NSDate *date = [formatter dateFromString:dateObj.date];
                    //                        if (date.sa_isToday == YES) {
                    //                            showStr = [NSString stringWithFormat:@"%@(%@)", obj.soonDelivery, obj.timeStr];
                    //                        } else {
                    //                            NSArray *dateArr = [dateObj.date componentsSeparatedByString:@"/"];
                    //                            if (dateArr.count == 3) {
                    //                                NSString *tempDate = [[dateArr subarrayWithRange:NSMakeRange(0, 2)] componentsJoinedByString:@"/"];
                    //                                NSString *showTime = [NSString stringWithFormat:@"%@ %@", tempDate, obj.timeStr];
                    //                                showStr = [NSString stringWithFormat:@"%@(%@)", obj.soonDelivery, showTime];
                    //                            } else {
                    //                                showStr = [NSString stringWithFormat:@"%@(%@ %@)", obj.soonDelivery, dateObj.date, obj.timeStr];
                    //                            }
                    //                        }
                    //                    }
                    *stop = YES;
                }
            }];
            *stop = YES;
        }
    }];
    if (HDIsStringNotEmpty(date) && HDIsStringNotEmpty(time)) {
        !self.selectedCallBack ?: self.selectedCallBack(date, time, showStr, appointmentType);
    }
    [self dismiss];
}

#pragma mark - tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return self.leftDataArr.count;
    } else {
        return self.rightDataArr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        TNTimeLeftCell *cell = [TNTimeLeftCell cellWithTableView:tableView];
        TNCalcDateModel *model = self.leftDataArr[indexPath.row];
        cell.model = model;
        return cell;
    } else {
        id model = self.rightDataArr[indexPath.row];
        if ([model isKindOfClass:[TNCalcTimeModel class]]) {
            TNTimeRightCell *cell = [TNTimeRightCell cellWithTableView:tableView];
            cell.model = model;
            return cell;
        } else {
            TNImmediateDeliveryRightCell *cell = [TNImmediateDeliveryRightCell cellWithTableView:tableView];
            cell.model = model;
            @HDWeakify(self);
            cell.confirmClickCalBack = ^{
                @HDStrongify(self);
                //之前的选中 全部清空
                [self.leftDataArr enumerateObjectsUsingBlock:^(TNCalcDateModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                    [obj.deliveryTimeList enumerateObjectsUsingBlock:^(TNCalcTimeModel *_Nonnull timeObj, NSUInteger idx, BOOL *_Nonnull stop) {
                        timeObj.isSelected = NO;
                    }];
                }];
                !self.selectedCallBack ?:
                    self.selectedCallBack(@"", self.immediateDeliveryModel.immediateDeliveryStr, self.immediateDeliveryModel.immediateDeliveryStr, TNOrderAppointmentTypeImmediately);
                [self dismiss];
            };
            return cell;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        return kRealHeight(50);
    } else {
        id model = self.rightDataArr[indexPath.row];
        if ([model isKindOfClass:TNCalcTimeModel.class]) {
            return kRealHeight(50);
            ;
        } else {
            return UITableViewAutomaticDimension;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.leftTableView) {
        TNCalcDateModel *model = self.leftDataArr[indexPath.row];
        if (model.isSelected) {
            return;
        }
        [self.leftDataArr enumerateObjectsUsingBlock:^(TNCalcDateModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            obj.isSelected = NO;
        }];
        model.isSelected = YES;
        if (model.isImmediateDeliveryItem && !HDIsObjectNil(self.immediateDeliveryModel)) {
            self.rightDataArr = @[self.immediateDeliveryModel];
        } else {
            self.rightDataArr = model.deliveryTimeList;
        }

        [self.leftTableView reloadData];
        [self.rightTableView reloadData];
    } else {
        id model = self.rightDataArr[indexPath.row];
        if ([model isKindOfClass:TNCalcTimeModel.class]) {
            TNCalcTimeModel *timeModel = model;
            if (timeModel.full) {
                return;
            }
            if (timeModel.isSelected) {
                return;
            }
            //之前的选中 全部清空
            [self.leftDataArr enumerateObjectsUsingBlock:^(TNCalcDateModel *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
                [obj.deliveryTimeList enumerateObjectsUsingBlock:^(TNCalcTimeModel *_Nonnull timeObj, NSUInteger idx, BOOL *_Nonnull stop) {
                    timeObj.isSelected = NO;
                }];
            }];
            timeModel.isSelected = YES;
            [self.rightTableView reloadData];
            [self doneClick];
        }
    }
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
//- (SAOperationButton *)doneBtn {
//    if (!_doneBtn) {
//        SAOperationButton *button = [SAOperationButton buttonWithStyle:SAOperationButtonStyleSolid];
//        button.cornerRadius = 0;
//        button.titleLabel.font = [HDAppTheme.TinhNowFont fontMedium:16];
//        [button addTarget:self action:@selector(doneClick) forControlEvents:UIControlEventTouchUpInside];
//        [button applyPropertiesWithBackgroundColor:HDAppTheme.TinhNowColor.C1];
//        [button setTitle:TNLocalizedString(@"tn_button_confirm_title", @"确定") forState:UIControlStateNormal];
//        _doneBtn = button;
//    }
//    return _doneBtn;
//}
/** @lazy tableViewContainer */
- (UIView *)tableViewContainer {
    if (!_tableViewContainer) {
        _tableViewContainer = [[UIView alloc] init];
    }
    return _tableViewContainer;
}
/** @lazy leftTableView */
- (UITableView *)leftTableView {
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _leftTableView.allowsSelection = YES;
        _leftTableView.rowHeight = kRealWidth(50);
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.showsHorizontalScrollIndicator = NO;
        _leftTableView.backgroundColor = HexColor(0xF7F7F9);
        if (@available(iOS 15.0, *)) {
            _leftTableView.sectionHeaderTopPadding = 0;
        }
    }
    return _leftTableView;
}
/** @lazy rightTableView */
- (UITableView *)rightTableView {
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.allowsSelection = YES;
        //        _rightTableView.rowHeight = kRealWidth(50);
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.showsVerticalScrollIndicator = NO;
        _rightTableView.showsHorizontalScrollIndicator = NO;
        if (@available(iOS 15.0, *)) {
            _rightTableView.sectionHeaderTopPadding = 0;
        }
    }
    return _rightTableView;
}
@end
