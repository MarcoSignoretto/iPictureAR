//
//  iPictureARWrapper.h
//  iPictureAR
//
//  Created by Marco Signoretto on 15/11/2019.
//  Copyright © 2019 Marco Signoretto. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IPictureARWrapper : NSObject

+ (UIImage *) applyAR:(UIImage *)img_0p And:(UIImage *)img_1p And:(UIImage *)img_0m And:(UIImage *)img_1m frame:(UIImage *)frame;

@end

NS_ASSUME_NONNULL_END
