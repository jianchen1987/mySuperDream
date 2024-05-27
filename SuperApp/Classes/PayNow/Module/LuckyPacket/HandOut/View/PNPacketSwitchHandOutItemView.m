//
//  PNPacketSwitchHandOutItemView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/12/7.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPacketSwitchHandOutItemView.h"
#import "PNHandOutViewModel.h"
#import "PNInfoView.h"
#import "PNSingleSelectedAlertView.h"


@interface PNPacketSwitchHandOutItemView ()
@property (nonatomic, strong) PNHandOutViewModel *viewModel;
@property (nonatomic, strong) PNInfoView *switchInfoView;
@end


@implementation PNPacketSwitchHandOutItemView
- (instancetype)initWithViewModel:(id<SAViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}

- (void)hd_setupViews {
    self.backgroundColor = HDAppTheme.PayNowColor.cFFFFFF;
    self.hd_frameDidChangeBlock = ^(__kindof UIView *_Nonnull view, CGRect precedingFrame) {
        [view setRoundedCorners:UIRectCornerAllCorners radius:kRealWidth(8)];
    };
    [self addSubview:self.switchInfoView];
}

- (void)updateConstraints {
    [self.switchInfoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];

    [super updateConstraints];
}

#pragma mark
- (void)clickHandler {
    PNSingleSelectedModel *model = [[PNSingleSelectedModel alloc] init];
    model.name = PNLocalizedString(@"pn_Normal_packet", @"普通红包");
    model.itemId = [NSString stringWithFormat:@"%zd", PNPacketType_Nor];
    if (self.viewModel.model.packetType == [model.itemId integerValue]) {
        model.isSelected = YES;
    }

    PNSingleSelectedModel *model2 = [[PNSingleSelectedModel alloc] init];
    model2.name = PNLocalizedString(@"pn_lucky_packet", @"口令红包");
    model2.itemId = [NSString stringWithFormat:@"%zd", PNPacketType_Password];
    if (self.viewModel.model.packetType == [model2.itemId integerValue]) {
        model2.isSelected = YES;
    }

    NSArray *arr = @[model, model2];

    PNSingleSelectedAlertView *alertView = [[PNSingleSelectedAlertView alloc] initWithDataArr:arr title:PNLocalizedString(@"pn_packet_type", @"红包类型")];
    @HDWeakify(self);
    alertView.selectedCallback = ^(PNSingleSelectedModel *_Nonnull model) {
        @HDStrongify(self);
        if (self.viewModel.model.packetType == model.itemId.integerValue) {
            return;
        }

        self.viewModel.model.packetType = model.itemId.integerValue;
        self.viewModel.currentPacketType = self.viewModel.model.packetType;
        /// 清除
        self.viewModel.model.qty = 0;
        self.viewModel.model.amt = @"";
        self.viewModel.model.remarks = @"";
        self.viewModel.ruleLimitFlag = !self.viewModel.ruleLimitFlag;
    };
    [alertView show];
}

- (void)setPacketType:(PNPacketType)packetType {
    _packetType = packetType;

    NSString *str = self.packetType == PNPacketType_Nor ? PNLocalizedString(@"pn_Normal_packet", @"普通红包") : PNLocalizedString(@"pn_lucky_packet", @"口令红包");
    self.switchInfoView.model.keyText = str;
    [self.switchInfoView setNeedsUpdateContent];
}

#pragma mark
- (PNInfoView *)switchInfoView {
    if (!_switchInfoView) {
        PNInfoView *infoView = PNInfoView.new;
        PNInfoViewModel *model = [[PNInfoViewModel alloc] init];
        model.keyFont = HDAppTheme.PayNowFont.standard14M;
        model.keyColor = HDAppTheme.PayNowColor.c333333;
        model.rightButtonImage = [UIImage imageNamed:@"pn_arrow_gray_small"];
        model.enableTapRecognizer = YES;
        model.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(20), kRealWidth(12), kRealWidth(20), kRealWidth(12));

        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            self.viewModel.hideKeyBoardFlag = !self.viewModel.hideKeyBoardFlag;
            self.viewModel.clearFlag = !self.viewModel.clearFlag;
            [self clickHandler];
        };
        infoView.model = model;

        _switchInfoView = infoView;
    }
    return _switchInfoView;
}

@end
