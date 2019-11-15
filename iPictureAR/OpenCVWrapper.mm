//
//  OpenCVWrapper.mm
//  iPictureAR
//
//  Created by Marco Signoretto on 15/11/2019.
//  Copyright © 2019 Marco Signoretto. All rights reserved.
//

#import "OpenCVWrapper.h"
#import <opencv2/opencv.hpp>

@implementation OpenCVWrapper

+ (NSString *)openCVVersionString {
    return [NSString stringWithFormat:@"OpenCV Version %s",  CV_VERSION];
}

@end
