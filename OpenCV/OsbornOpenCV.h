//
//  OsbornOpenCV.h
//  OpenCV
//
//  Created by osborn on 2018/9/14.
//  Copyright © 2018年 osborn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface OsbornOpenCV : NSObject

+ (UIImage *)autoContrast:(UIImage *)image;

+ (UIImage *)gray:(UIImage *)image;

+ (UIImage *)maskImage:(UIImage *)image;

//
+ (double)sharpness:(UIImage *)image ;

//低通滤波
+ (UIImage *)lowpassImage:(UIImage *)image;

//中值滤波
+ (UIImage *)medianfilter:(UIImage *)image;

//颜色变换
+ (UIImage *)changeColor:(UIImage *)image;

//风格变换
+ (UIImage *)changeStyle:(UIImage *)image;


//清晰度判断
+ (BOOL) whetherTheImageBlurry:(UIImage*)image;

@end
