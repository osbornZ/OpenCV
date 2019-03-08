//
//  OsbornOpenCV+OsbornOpenCVEX.h
//  OpenCV
//
//  Created by osborn on 2019/3/7.
//  Copyright © 2019 osborn. All rights reserved.
//

#import "OsbornOpenCV.h"

NS_ASSUME_NONNULL_BEGIN

@interface OsbornOpenCV ()

+ (cv::Mat)cvMatFromUIImage:(UIImage *)image;
+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat;


@end

NS_ASSUME_NONNULL_END
