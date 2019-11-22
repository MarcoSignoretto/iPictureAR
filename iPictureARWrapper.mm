//
//  iPictureARWrapper.mm
//  iPictureAR
//
//  Created by Marco Signoretto on 15/11/2019.
//  Copyright © 2019 Marco Signoretto. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "IPictureARWrapper.h"
#import "marker.h"
#import "utils.h"
#import <vector>

@implementation IPictureARWrapper

- (cv::Mat)cvMatFromUIImage:(UIImage *)image {
    return cvMatFromUIImage(image);
}

const cv::Mat cvMatFromUIImage(const UIImage* image){
  CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
  CGFloat cols = image.size.width;
  CGFloat rows = image.size.height;

  cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)

  CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to  data
                                                 cols,                       // Width of bitmap
                                                 rows,                       // Height of bitmap
                                                 8,                          // Bits per component
                                                 cvMat.step[0],              // Bytes per row
                                                 colorSpace,                 // Colorspace
                                                 kCGImageAlphaNoneSkipLast |
                                                 kCGBitmapByteOrderDefault); // Bitmap info flags

  CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
  CGContextRelease(contextRef);

  return cvMat;
}

const cv::Mat cvMatFromUIImage(const UIImage* image, const int rows, const int cols){
    cv::Mat mat = cvMatFromUIImage(image);
    
    cv::Mat resized(rows, cols, CV_8UC4); // 8 bits per component, 4 channels (color channels + alpha)
    cv::resize(mat, resized, cv::Size(cols,rows));
    return resized;
}


- (cv::Mat)cvMatGrayFromUIImage:(UIImage *)image {
    return cvMatGrayFromUIImage(image);
}

const cv::Mat cvMatGrayFromUIImage(const UIImage * image) {
  CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
  CGFloat cols = image.size.width;
  CGFloat rows = image.size.height;

  cv::Mat cvMat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels

  CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to data
                                                 cols,                       // Width of bitmap
                                                 rows,                       // Height of bitmap
                                                 8,                          // Bits per component
                                                 cvMat.step[0],              // Bytes per row
                                                 colorSpace,                 // Colorspace
                                                 kCGImageAlphaNoneSkipLast |
                                                 kCGBitmapByteOrderDefault); // Bitmap info flags

  CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
  CGContextRelease(contextRef);

  return cvMat;
}

const cv::Mat cvMatGrayFromUIImage(const UIImage * image, const int rows, const int cols) {
    cv::Mat mat = cvMatGrayFromUIImage(image);
    
    cv::Mat resized(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
    cv::resize(mat, resized, cv::Size(cols,rows));
    return resized;
}

-(UIImage *)UIImageFromCVMat:(cv::Mat)cvMat {
    return UIImageFromCVMat(cvMat);
}

UIImage * UIImageFromCVMat(cv::Mat& cvMat){
  NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
  CGColorSpaceRef colorSpace;

  if (cvMat.elemSize() == 1) {
      colorSpace = CGColorSpaceCreateDeviceGray();
  } else {
      colorSpace = CGColorSpaceCreateDeviceRGB();
  }

  CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);

  // Creating CGImage from cv::Mat
  CGImageRef imageRef = CGImageCreate(
     cvMat.cols,                                 //width
     cvMat.rows,                                 //height
     8,                                          //bits per component
     8 * cvMat.elemSize(),                       //bits per pixel
     cvMat.step[0],                            //bytesPerRow
     colorSpace,                                 //colorspace
     kCGImageAlphaNoneSkipLast|kCGBitmapByteOrderDefault,// bitmap info
     provider,                                   //CGDataProviderRef
     NULL,                                       //decode
     false,                                      //should interpolate
     kCGRenderingIntentDefault                   //intent
  );


  // Getting UIImage from CGImage
  UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
  CGImageRelease(imageRef);
  CGDataProviderRelease(provider);
  CGColorSpaceRelease(colorSpace);

  return finalImage;
 }

+ (NSString *)myPrintNative {
    return @"Hi";
//    [NSString stringWithCString:myPrint().c_str()
//    encoding:[NSString defaultCStringEncoding]];
}

+ (UIImage *) applyAR:(UIImage *)img_0p And:(UIImage *)img_1p And:(UIImage *)img_0m And:(UIImage *)img_1m frame:(UIImage *)frame {
    
    cv::Mat img_0p_ = cvMatFromUIImage(img_0p);
    cv::Mat img_1p_ = cvMatFromUIImage(img_1p);
    cv::Mat img_0m_th = cvMatGrayFromUIImage(img_0m);
    cv::Mat img_1m_th = cvMatGrayFromUIImage(img_1m);
    
    cv::Mat frame_ = cvMatFromUIImage(frame);
    
    try {
//        //Threshold img_0m
//        cv::threshold(img_0m_th, img_0m_th, 0, 255, cv::THRESH_OTSU);
//
//        // Threshold img_1m
//        cv::threshold(img_1m_th, img_1m_th, 0, 255, cv::THRESH_OTSU);
                
        const mcv::Matcher matcher{
            std::vector<const cv::Mat*>{&img_0m_th, &img_1m_th},
            std::vector<const cv::Mat*>{&img_0p_, &img_1p_}
        };
    
    
        mcv::marker::apply_AR(matcher, frame_, false);
    } catch (const cv::Exception &e) {
        // TODO report here somehow
    }
    return UIImageFromCVMat(frame_);
}


@end
