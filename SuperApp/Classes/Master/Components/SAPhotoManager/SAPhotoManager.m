//
//  SAPhotoManager.m
//  SuperApp
//
//  Created by VanJay on 2020/5/21.
//  Copyright © 2020 chaos network technology. All rights reserved.
//

#import "SAPhotoManager.h"
#import "SAMultiLanguageManager.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDUIKit/HDAppTheme.h>


@implementation SAPhotoManager
- (instancetype)initWithType:(HXPhotoManagerSelectedType)type {
    if (self = [super initWithType:type]) {
        self.configuration.albumShowMode = HXPhotoAlbumShowModePopup;
        self.configuration.openCamera = YES;
        self.configuration.popupTableViewCellHeight = 64;
        self.configuration.popupTableViewCellAlbumNameColor = HDAppTheme.color.G1;
        self.configuration.popupTableViewCellAlbumNameFont = HDAppTheme.font.standard3;
        self.configuration.popupTableViewCellPhotoCountColor = HDAppTheme.color.G3;
        self.configuration.popupTableViewCellPhotoCountFont = HDAppTheme.font.standard3;
        self.configuration.photoMaxNum = 9;
        self.configuration.themeColor = HDAppTheme.color.C1;
        self.configuration.photoCanEdit = false;
        self.configuration.popupTableViewHeight = kScreenHeight * 0.8;
        self.configuration.supportRotation = false;
        HXPhotoLanguageType type = HXPhotoLanguageTypeEn;
        if (SAMultiLanguageManager.isCurrentLanguageCN) {
            type = HXPhotoLanguageTypeSc;
        }
        self.configuration.languageType = type;
    }
    return self;
}
@end
