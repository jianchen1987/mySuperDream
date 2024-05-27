//
//  PNPhotoView.m
//  SuperApp
//
//  Created by xixi_wen on 2022/11/11.
//  Copyright © 2022 chaos network technology. All rights reserved.
//

#import "PNPhotoView.h"
#import "HDAppTheme+PayNow.h"
#import "PNMultiLanguageManager.h"
#import "SAMultiLanguageManager.h"
#import <HDKitCore/HDCommonDefines.h>
#import <HDKitCore/UIView+HD_Extension.h>
#import <HDUIKit/HDImageUploadAddImageView.h>


@implementation PNPhotoView

+ (instancetype)photoManager:(HXPhotoManager *)manager {
    return [PNPhotoView photoManager:manager addViewBackgroundColor:nil];
}

+ (instancetype)photoManager:(HXPhotoManager *)manager addViewBackgroundColor:(UIColor *_Nullable)color {
    PNPhotoView *view = [super photoManager:manager];
    // clang-format off
    BeginIgnoreClangWarning(-Wundeclared-selector);
    if ([view respondsToSelector:@selector(addModel)]) {
        EndIgnoreClangWarning;
        // clang-format on
        HXPhotoModel *addModel = [view valueForKey:@"addModel"];
        if ([addModel isKindOfClass:HXPhotoModel.class]) {
            HDImageUploadAddImageView *addImageView = [[HDImageUploadAddImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];

            addImageView.cameraImageView.image = [UIImage imageNamed:@"pn_icon_camera"];
            addImageView.descLabel.text = PNLocalizedString(@"pn_add_picture", @"添加照片");
            addImageView.descLabel.textColor = HDAppTheme.PayNowColor.c999999;
            addImageView.descLabel.font = HDAppTheme.PayNowFont.standard12;
            if (color) {
                addImageView.backgroundColor = color;
            }
            [addImageView setNeedsLayout];
            [addImageView layoutIfNeeded];
            UIImage *addImage = [addImageView snapshotImage];
            addModel.thumbPhoto = addImage;
        }
    }
    return view;
}
@end
