//
//  UIImage+Mask.h
//  IPCamera
//
//  Created by thomas on 13-2-1.
//  Copyright (c) 2013年 thomas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (expanded)

- (UIImage *)imageAtRect:(CGRect)rect;

- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;

- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)fixOrientation;

- (UIImage *) imageWithWaterMask:(UIImage*)mask inRect:(CGRect)rect;
- (UIImage *) imageWithWaterText:(NSString*)text inRect:(CGRect)rect;

- (UIImage *)croppedImage:(CGRect)bounds;
//- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
//          transparentBorder:(NSUInteger)borderSize
//               cornerRadius:(NSUInteger)cornerRadius
//       interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

-(UIImage*)rotate:(UIImageOrientation)orient;
- (UIImage*)resizeImageWithNewSize:(CGSize)newSize;



/* 下载图片数据 生成image */
+ (UIImage *)imageWithContentsOfURLStr:(NSString *)urlStr;//DEPRECATED
+ (UIImage *)imageWithContentsOfURL:(NSURL *)url;//DEPRECATED

/* 给UIImage添加生成圆角图片的扩展API：这是on-screen-rendering */
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;

@end
