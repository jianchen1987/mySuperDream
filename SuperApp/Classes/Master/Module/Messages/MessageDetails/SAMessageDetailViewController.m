//
//  SAMessageDetailViewController.m
//  SuperApp
//
//  Created by VanJay on 2020/6/2.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAMessageDetailViewController.h"
#import "SAMessageDTO.h"
#import "SAMessageDetailRspModel.h"
#import "SAMessageManager.h"


@interface SAMessageDetailViewController ()
/// 业务线
@property (nonatomic, copy) SAClientType clientType;
/// 消息发送流水号
@property (nonatomic, copy) NSString *sendSerialNumber;
/// DTO
@property (nonatomic, strong) SAMessageDTO *messageDTO;
/// 标题
@property (nonatomic, strong) SALabel *titleLB;
/// 时间
@property (nonatomic, strong) SALabel *timeLB;
/// 内容
@property (nonatomic, strong) SALabel *contentLB;
@end


@implementation SAMessageDetailViewController

- (instancetype)initWithRouteParameters:(NSDictionary<NSString *, id> *)parameters {
    self = [super initWithRouteParameters:parameters];
    if (!self)
        return nil;

    self.sendSerialNumber = [parameters objectForKey:@"sendSerialNumber"];
    self.clientType = [parameters objectForKey:@"clientType"];
    if ([parameters[@"shouldCallRead"] boolValue] && !HDIsStringEmpty(self.sendSerialNumber)) {
        [self messageReadAction];
    }

    if (HDIsStringEmpty(self.sendSerialNumber)) {
        SAMessageDetailRspModel *model = SAMessageDetailRspModel.new;
        model.messageName = [[SAInternationalizationModel alloc] initWithCN:self.parameters[@"title"] en:self.parameters[@"title"] kh:self.parameters[@"title"]];
        model.messageContent = [[SAInternationalizationModel alloc] initWithCN:self.parameters[@"content"] en:self.parameters[@"content"] kh:self.parameters[@"content"]];
        model.sendTime = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970] * 1000];
        [self reloadDataWithRspModel:model];
    }

    return self;
}

- (void)messageReadAction {
    [SAMessageManager.share updateMessageReadStateWithMessageNo:self.sendSerialNumber messageType:SAAppInnerMessageTypePersonal];
}

- (void)hd_setupNavigation {
    self.boldTitle = SALocalizedString(@"message_detail", @"消息详情");
}

- (void)hd_setupViews {
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.scrollViewContainer];
    [self.scrollViewContainer addSubview:self.titleLB];
    [self.scrollViewContainer addSubview:self.timeLB];
    [self.scrollViewContainer addSubview:self.contentLB];
}

- (void)updateViewConstraints {
    [self.scrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hd_navigationBar.mas_bottom);
        make.left.width.bottom.equalTo(self.view);
    }];
    [self.scrollViewContainer mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.scrollView).offset(-UIEdgeInsetsGetHorizontalValue(HDAppTheme.value.padding));
        make.top.bottom.centerX.equalTo(self.scrollView);
    }];
    [self.titleLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollViewContainer).offset(kRealWidth(20));
        make.left.right.equalTo(self.scrollViewContainer);
    }];
    [self.timeLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(kRealWidth(10));
        make.left.right.equalTo(self.scrollViewContainer);
    }];
    [self.contentLB mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLB.mas_bottom).offset(kRealWidth(10));
        make.left.right.equalTo(self.scrollViewContainer);
        make.bottom.equalTo(self.scrollViewContainer).offset(-kRealWidth(15));
    }];
    [super updateViewConstraints];
}

- (void)hd_getNewData {
    if (HDIsStringEmpty(self.sendSerialNumber)) {
        return;
    }
    [self showloading];
    @HDWeakify(self);
    [self.messageDTO getMessageDetailWithClientType:self.clientType messageNo:nil sendSerialNumber:self.sendSerialNumber success:^(SAMessageDetailRspModel *_Nonnull rspModel) {
        @HDStrongify(self);
        [self dismissLoading];

        [self reloadDataWithRspModel:rspModel];
    } failure:^(SARspModel *_Nullable rspModel, CMResponseErrorType errorType, NSError *_Nullable error) {
        @HDStrongify(self);
        [self dismissLoading];
    }];
}

#pragma mark - private methods
- (void)reloadDataWithRspModel:(SAMessageDetailRspModel *)rspModel {
    self.titleLB.text = rspModel.messageName.desc;

    NSDate *date = [NSDate dateWithTimeIntervalSince1970:rspModel.sendTime.integerValue / 1000.0];
    NSString *dateStr = [SAGeneralUtil getDateStrWithDate:date format:@"dd/MM/yyyy HH:mm"];
    self.timeLB.text = dateStr;
    self.contentLB.text = rspModel.messageContent.desc;

    [self.view setNeedsUpdateConstraints];
}

#pragma mark - lazy load

- (SAMessageDTO *)messageDTO {
    return _messageDTO ?: ({ _messageDTO = SAMessageDTO.new; });
}

- (SALabel *)titleLB {
    if (!_titleLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard2Bold;
        label.textColor = HDAppTheme.color.G1;
        label.numberOfLines = 0;
        _titleLB = label;
    }
    return _titleLB;
}

- (SALabel *)timeLB {
    if (!_timeLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G3;
        label.numberOfLines = 0;
        _timeLB = label;
    }
    return _timeLB;
}

- (SALabel *)contentLB {
    if (!_contentLB) {
        SALabel *label = SALabel.new;
        label.font = HDAppTheme.font.standard3;
        label.textColor = HDAppTheme.color.G2;
        label.numberOfLines = 0;
        _contentLB = label;
    }
    return _contentLB;
}

@end
