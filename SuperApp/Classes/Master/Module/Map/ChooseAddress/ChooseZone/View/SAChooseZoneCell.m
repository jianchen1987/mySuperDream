//
//  SAChooseZoneCell.m
//  SuperApp
//
//  Created by Chaos on 2021/3/23.
//  Copyright © 2021 chaos network technology. All rights reserved.
//

#import "SAChooseZoneCell.h"
#import "SAInfoView.h"
#import "SAAddressZoneModel.h"


@interface SAChooseZoneCell ()

@property (nonatomic, strong) SAInfoView *infoView;

@end


@implementation SAChooseZoneCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.infoView];
}

- (void)updateConstraints {
    [self.infoView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark - setter
- (void)setModel:(SAAddressZoneModel *)model {
    _model = model;

    SAInfoViewModel *infoModel = SAInfoViewModel.new;
    infoModel.contentEdgeInsets = UIEdgeInsetsMake(kRealWidth(12), kRealWidth(33), kRealWidth(12), kRealWidth(33));
    infoModel.keyText = model.message.desc;
    infoModel.keyFont = HDAppTheme.font.standard3;
    infoModel.keyColor = HDAppTheme.color.G2;
    self.infoView.model = infoModel;
    [self setNeedsUpdateConstraints];
}

#pragma mark - lazy load
- (SAInfoView *)infoView {
    return _infoView ?: ({ _infoView = SAInfoView.new; });
}

@end
