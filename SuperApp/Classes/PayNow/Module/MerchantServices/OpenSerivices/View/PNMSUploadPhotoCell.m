//
//  PNMSUploadPhotoCell.m
//  SuperApp
//
//  Created by xixi_wen on 2022/6/8.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNMSUploadPhotoCell.h"
#import "PNUploadIDImageView.h"


@interface PNMSUploadPhotoCell ()
@property (nonatomic, strong) PNUploadIDImageView *photoContentView;
@end


@implementation PNMSUploadPhotoCell

- (void)hd_setupViews {
    [self.contentView addSubview:self.photoContentView];
}

- (void)updateConstraints {
    [self.photoContentView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    [super updateConstraints];
}

+ (BOOL)requiresConstraintBasedLayout {
    return YES;
}

#pragma mark
- (void)setModel:(PNMSUploadPhotoModel *)model {
    _model = model;

    self.photoContentView.leftURL = model.leftURL;
    self.photoContentView.rightURL = model.rightURL;
}

#pragma mark
- (PNUploadIDImageView *)photoContentView {
    if (!_photoContentView) {
        _photoContentView = [[PNUploadIDImageView alloc] init];
        @HDWeakify(self);
        _photoContentView.refreshLeftResultBlock = ^(NSString *_Nonnull leftURL) {
            @HDStrongify(self);
            HDLog(@"leftURL: %@", leftURL);
            self.model.leftURL = leftURL;
            //            [self ruleLimit];
        };
        _photoContentView.refreshRightResultBlock = ^(NSString *_Nonnull rightURL) {
            @HDStrongify(self);
            HDLog(@"rightURL: %@", rightURL);
            self.model.rightURL = rightURL;
            //            [self ruleLimit];
        };
    }
    return _photoContentView;
}

@end


@implementation PNMSUploadPhotoModel

@end
