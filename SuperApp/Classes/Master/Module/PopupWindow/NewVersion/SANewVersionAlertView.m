//
//  SANewVersionAlertView.m
//  SuperApp
//
//  Created by VanJay on 2020/4/6.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SANewVersionAlertView.h"
#import <HDUIKit/HDAppTheme.h>
#import <Masonry/Masonry.h>


@implementation SANewVersionAlertView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"new_version_img"]];
        [self addSubview:self.logo];
        [self.logo mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.centerX.mas_equalTo(0);
        }];

        self.title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
        self.title.textAlignment = NSTextAlignmentCenter;
        self.title.font = HDAppTheme.font.standard2;
        self.title.textColor = HDAppTheme.color.G1;
        [self addSubview:self.title];
        [self.title mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.logo.mas_bottom).offset(22);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.width.mas_equalTo(frame.size.width);
        }];

        self.content = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 40)];
        self.content.numberOfLines = 0;
        self.content.textAlignment = NSTextAlignmentLeft;
        self.content.font = HDAppTheme.font.standard3;
        self.content.textColor = HDAppTheme.color.G2;

        [self addSubview:self.content];
        [self.content mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.mas_bottom).offset(20);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(20);
        }];
    }
    return self;
}
@end
