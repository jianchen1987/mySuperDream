//
//  PNPacketPasswordItemView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketPasswordItemView.h"
#import "NSString+HD_Util.h"
#import "NSString+Random.h"
#import "NSString+matchs.h"
#import "PNAlertInputView.h"
#import "PNCollectionView.h"
#import "PNHandOutViewModel.h"
#import "PNPacketSubPwdItemCell.h"

static NSInteger const maxLength = 8;
static NSString *const kNumberAndLetter = @"^[a-zA-Z0-9]+$";


@interface PNPacketPasswordItemView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) PNHandOutViewModel *viewModel;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) SALabel *titleLabel;
@property (nonatomic, strong) PNCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSourceArray;
@property (nonatomic, strong) HDUIButton *customBtn;
///记录第一次生成
@property (nonatomic, copy) NSString *passwordFirst;
@end


@implementation PNPacketPasswordItemView

- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self.passwordFirst = [NSString getRandomStringWithNum:maxLength].uppercaseString;
    HDLog(@"口令：%@", self.passwordFirst);
    self.viewModel.model.keyType = PNPacketKeyType_System;
    self.viewModel.model.password = self.passwordFirst;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.backgroundColor;

    [self addSubview:self.bgView];
    [self.bgView addSubview:self.titleLabel];
    [self.bgView addSubview:self.collectionView];
    [self addSubview:self.customBtn];

    @HDWeakify(self);
    [self.KVOController hd_observe:self.collectionView keyPath:@"contentSize" block:^(id _Nullable observer, id _Nonnull object, NSDictionary<NSString *, id> *_Nonnull change) {
        @HDStrongify(self);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(self.collectionView.contentSize.height);
            }];
        });
    }];

    self.pwdStr = self.viewModel.model.password;
}

- (void)updateConstraints {
    [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self);
    }];

    [self.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.bgView.mas_left).offset(kRealWidth(12));
        make.top.mas_equalTo(self.bgView.mas_top).offset(kRealWidth(20));
        if (WJIsObjectNil(self.dataSourceArray) || self.dataSourceArray.count <= 0) {
            make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-kRealWidth(20));
        }
    }];

    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).offset(kRealWidth(12));
        make.right.mas_equalTo(self.bgView.mas_right).offset(-kRealWidth(12));
        make.top.mas_equalTo(self.bgView.mas_top).offset(kRealWidth(20));
        make.bottom.mas_equalTo(self.bgView.mas_bottom).offset(-kRealWidth(20));
    }];

    [self.customBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.bgView.mas_right);
        make.top.mas_equalTo(self.bgView.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];

    [super updateConstraints];
}

- (void)setPwdStr:(NSString *)pwdStr {
    _pwdStr = pwdStr;

    self.dataSourceArray = [NSMutableArray arrayWithArray:[self.pwdStr hd_charArray]];

    [self.collectionView successGetNewDataWithNoMoreData:YES];

    [self.collectionView setNeedsLayout];
    [self.collectionView layoutIfNeeded];

    [self.bgView setNeedsLayout];
    [self.bgView layoutIfNeeded];

    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark
- (void)showAlertInputView {
    PNAlertInputViewConfig *config = [PNAlertInputViewConfig defulatConfig];
    config.title = PNLocalizedString(@"pn_packet_Customized_number", @"自定义口令");
    config.subTitle = PNLocalizedString(@"pn_packet_number_tips", @"为了您的资金安全，口令不宜过于简单\n8位英文大写字母、数字、不支持符号");
    config.cancelButtonTitle = PNLocalizedString(@"BUTTON_TITLE_CANCEL", @"取消");
    config.doneButtonTitle = PNLocalizedString(@"BUTTON_TITLE_SURE", @"确定");
    config.maxInputLength = maxLength;

    @HDWeakify(self);
    config.cancelHandler = ^(PNAlertInputView *_Nonnull alertView) {
        HDLog(@"点击取消了");
        [alertView dismiss];
    };

    config.doneHandler = ^(NSString *_Nonnull inputText, PNAlertInputView *_Nonnull alertView) {
        HDLog(@"%@", inputText);
        @HDStrongify(self);
        if (WJIsStringNotEmpty(inputText)) {
            if (inputText.length != maxLength || ![inputText.uppercaseString matches:kNumberAndLetter]) {
                [NAT showToastWithTitle:nil content:PNLocalizedString(@"pn_capital_letters_or_number", @"8位英文大写字母、数字、不支持符号") type:HDTopToastTypeError];
                return;
            }

            NSString *password = inputText.uppercaseString;
            self.viewModel.model.password = password;
            self.viewModel.model.keyType = PNPacketKeyType_Custom;
            self.customBtn.selected = YES;
            self.pwdStr = password;
            [alertView dismiss];
        }
    };
    PNAlertInputView *alert = [[PNAlertInputView alloc] initAlertWithConfig:config];
    [alert show];
}

#pragma mark
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    PNPacketSubPwdItemCell *cell = [PNPacketSubPwdItemCell cellWithCollectionView:collectionView forIndexPath:indexPath];
    cell.content = [self.dataSourceArray objectAtIndex:indexPath.item];
    return cell;
}

#pragma mark
- (PNCollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];

        flowLayout.minimumLineSpacing = kRealWidth(4);
        flowLayout.minimumInteritemSpacing = kRealWidth(4);
        flowLayout.itemSize = UICollectionViewFlowLayoutAutomaticSize;
        flowLayout.estimatedItemSize = CGSizeMake(kRealWidth(24), kRealWidth(24));

        _collectionView = [[PNCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        _collectionView.needRecognizeSimultaneously = NO;
        _collectionView.needRefreshFooter = NO;
        _collectionView.needRefreshHeader = NO;

        SEL sel = NSSelectorFromString(@"_setRowAlignmentsOptions:");
        if ([_collectionView.collectionViewLayout respondsToSelector:sel]) {
            ((void (*)(id, SEL, NSDictionary *))objc_msgSend)(_collectionView.collectionViewLayout, sel, @{
                @"UIFlowLayoutCommonRowHorizontalAlignmentKey": @(NSTextAlignmentRight),
                @"UIFlowLayoutLastRowHorizontalAlignmentKey": @(NSTextAlignmentRight),
                @"UIFlowLayoutRowVerticalAlignmentKey": @(NSTextAlignmentCenter)
            });
        }
    }
    return _collectionView;
}

- (SALabel *)titleLabel {
    if (!_titleLabel) {
        SALabel *label = [[SALabel alloc] init];
        label.textColor = HDAppTheme.PayNowColor.c333333;
        label.font = HDAppTheme.PayNowFont.standard14M;
        label.text = PNLocalizedString(@"pn_packet_lucky_number", @"口令");
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UIView *)bgView {
    if (!_bgView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
        view.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
            [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(8)];
        };
        _bgView = view;
    }
    return _bgView;
}

- (HDUIButton *)customBtn {
    if (!_customBtn) {
        HDUIButton *button = [HDUIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:PNLocalizedString(@"pn_packet_Customized_number", @"自定义口令") forState:UIControlStateNormal];
        [button setTitle:PNLocalizedString(@"pn_packet_system_number", @"系统推荐口令") forState:UIControlStateSelected];
        [button setTitleColor:[UIColor hd_colorWithHexString:@"#0085FF"] forState:0];
        button.titleLabel.font = HDAppTheme.PayNowFont.standard12;
        button.titleEdgeInsets = UIEdgeInsetsMake(kRealWidth(8), 0, kRealWidth(4), 0);

        @HDWeakify(self);
        [button addTouchUpInsideHandler:^(UIButton *_Nonnull btn) {
            HDLog(@"click");
            @HDStrongify(self);
            if (!btn.selected) {
                [self showAlertInputView];
            } else {
                self.viewModel.model.password = self.passwordFirst;
                self.viewModel.model.keyType = PNPacketKeyType_System;
                self.pwdStr = self.passwordFirst;
                btn.selected = NO;
            }
        }];

        _customBtn = button;
    }
    return _customBtn;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray array];
    }
    return _dataSourceArray;
}

@end
