//
//  CMSInfoGroupCardView.m
//  SuperApp
//
//  Created by Chaos on 2021/7/16.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "CMSInfoGroupCardView.h"
#import "CMNetworkRequest.h"
#import "CMSInfoGroupItemConfig.h"
#import "SAInfoView.h"


@interface CMSInfoGroupCardView ()

@property (nonatomic, strong) NSArray<CMSInfoGroupItemConfig *> *dataSource;
@property (nonatomic, strong) CMNetworkRequest *request;

@end


@implementation CMSInfoGroupCardView

- (void)dealloc {
    [_request cancel];
}

- (void)configSubView {
    [self.containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if (HDIsArrayEmpty(self.dataSource)) {
        return;
    }
    UIView *lastView = nil;
    for (int i = 0; i < self.dataSource.count; i++) {
        CMSInfoGroupItemConfig *itemConfig = self.dataSource[i];
        SAInfoView *infoView = [self createInfoViewWithItemConfig:itemConfig];
        [self.containerView addSubview:infoView];
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.containerView);
            if (lastView == nil) {
                make.top.equalTo(self.containerView);
            } else {
                make.top.equalTo(lastView.mas_bottom);
            }
            if (i == self.dataSource.count - 1) {
                make.bottom.equalTo(self.containerView);
            }
        }];
        lastView = infoView;
    }
    [self setNeedsUpdateConstraints];
}

#pragma mark - OverWrite
- (CGFloat)heightOfCardView {
    __block CGFloat height = 0;

    [self.dataSource enumerateObjectsUsingBlock:^(CMSInfoGroupItemConfig *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        CGFloat lineHeight = 0;
        CGFloat iconHeight = HDIsStringEmpty(obj.imageUrl) ? 0 : 18;
        CGFloat titleHeight = HDIsStringEmpty(obj.title) ? 0 : [obj.title boundingAllRectWithSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX) font:[UIFont systemFontOfSize:obj.titleFont]].height;
        CGFloat subTitleHight = HDIsStringEmpty(obj.subTitle) ? 0 : [obj.subTitle boundingAllRectWithSize:CGSizeMake(kScreenWidth, CGFLOAT_MAX) font:[UIFont systemFontOfSize:obj.subTitleFont]].height;
        lineHeight = MAX(iconHeight, MAX(titleHeight, subTitleHight));
        lineHeight += kRealWidth(24);
        height += lineHeight;
    }];
    height += [self.titleView heightOfTitleView];
    height += UIEdgeInsetsGetVerticalValue(self.config.contentEdgeInsets);

    return height;
}

#pragma mark - setter
- (void)setConfig:(SACMSCardViewConfig *)config {
    [super setConfig:config];

    self.dataSource = [NSArray yy_modelArrayWithClass:CMSInfoGroupItemConfig.class json:self.config.getAllNodeContents];
    [self configSubView];
}

#pragma mark - private methods
- (SAInfoView *)createInfoViewWithItemConfig:(CMSInfoGroupItemConfig *)itemConfig {
    SAInfoViewModel *model = [[SAInfoViewModel alloc] init];
    model.backgroundColor = UIColor.whiteColor;
    model.keyText = itemConfig.title;
    model.keyFont = [UIFont systemFontOfSize:itemConfig.titleFont];
    model.keyColor = [UIColor hd_colorWithHexString:itemConfig.titleColor];
    model.valueFont = [UIFont systemFontOfSize:itemConfig.subTitleFont];
    model.valueColor = [UIColor hd_colorWithHexString:itemConfig.subTitleColor];
    model.lineWidth = ([self.dataSource indexOfObject:itemConfig] == (self.dataSource.count - 1)) ? 0 : PixelOne;
    model.leftImageSize = CGSizeMake(18, 18);
    if (HDIsStringNotEmpty(itemConfig.imageUrl)) {
        model.leftImageURL = itemConfig.imageUrl;
    }
    if (HDIsStringNotEmpty(itemConfig.link)) {
        model.rightButtonImage = [UIImage imageNamed:@"black_arrow"];
        model.enableTapRecognizer = true;
        @HDWeakify(self);
        model.eventHandler = ^{
            @HDStrongify(self);
            !self.clickNode ?:
                              self.clickNode(self,
                               self.config.nodes[[self.dataSource indexOfObject:itemConfig]],
                               itemConfig.link,
                               [NSString stringWithFormat:@"node@%zd", [self.dataSource indexOfObject:itemConfig]]);
        };
    }
    if (HDIsStringEmpty(itemConfig.dataSource) && HDIsStringNotEmpty(itemConfig.subTitle)) {
        model.valueText = itemConfig.subTitle;
    }
    SAInfoView *infoView = [SAInfoView infoViewWithModel:model];
    if (HDIsStringNotEmpty(itemConfig.dataSource)) {
        if ([itemConfig.dataSource isEqualToString:CMSDataSourceCurrentVersion]) {
            model.valueText = HDDeviceInfo.appVersion;
        } else if ([itemConfig.dataSource isEqualToString:CMSDataSourceCurrentLanguage]) {
            model.valueText = SAMultiLanguageManager.currentLanguageDisplayName;
        } else {
            self.request.requestURI = itemConfig.dataSource;
            NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithCapacity:3];
            if ([SAUser hasSignedIn]) {
                [params setObject:SAUser.shared.operatorNo forKey:@"operatorNo"];
            }
            self.request.requestParameter = params;
            [self.request startWithSuccess:^(HDNetworkResponse *_Nonnull response) {
                model.valueText = [response.responseObject[@"data"][@"count"] stringValue];
                [infoView setNeedsUpdateContent];
            } failure:^(HDNetworkResponse *_Nonnull response) {
                model.valueText = @"";
                [infoView setNeedsUpdateContent];
            }];
        }
        [infoView setNeedsUpdateContent];
    }

    return infoView;
}

#pragma mark - lazy load
- (CMNetworkRequest *)request {
    if (!_request) {
        CMNetworkRequest *request = CMNetworkRequest.new;
        request.retryCount = 2;
        request.isNeedLogin = NO;
        request.shouldAlertErrorMsgExceptSpecCode = NO;
        _request = request;
    }
    return _request;
}

@end
