//
//  OsbornOpenCV.m
//  OpenCV
//
//  Created by osborn on 2018/9/14.
//  Copyright © 2018年 osborn. All rights reserved.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgproc/types_c.h>
#import <opencv2/imgcodecs/ios.h>
#import <opencv2/core/core_c.h>

#import "OsbornOpenCV.h"
#import "OsbornOpenCV+OsbornOpenCVEX.h"

//方差参考值
const double delta = 100;

using namespace cv;

@implementation OsbornOpenCV

+ (UIImage *)gray:(UIImage *)image {
    Mat mat;
    UIImageToMat(image, mat);
    
    Mat grayMat;
    cvtColor(mat, grayMat, CV_BGR2GRAY);
    
    double HistRed[256]   = {0};
    double HistGreen[256] = {0};
    double HistBlue[256]  = {0};

    double dlowcut = 0.1;
    double dhighcut = 0.1;
    for (int i=0;i<grayMat.rows;i++)
    {
        for (int j=0;j<grayMat.cols;j++)
        {
            int iblue =grayMat.at<uchar>(i,j);
//            int igreen=grayMat.at<uchar>(i,j)[1];
//            int ired  =grayMat.at<uchar>(i,j)[2];
            
            HistBlue[iblue]++;
//            HistGreen[igreen]++;
//            HistRed[ired]++;
        }
    }
    
    UIImage *result = MatToUIImage(grayMat);
    return result;
}

//对比度
+ (UIImage *)maskImage:(UIImage *)image {
    Mat src;
    UIImageToMat(image, src);
    
//    Mat mask = Mat::zeros(src.size(), CV_8UC1);
//    Rect2i r = Rect2i(120, 80, 100, 100);
//    mask(r).setTo(255);
//
//    Mat dst;
//    src.copyTo(dst, mask);
    
    Mat dst;
//    Mat kernel = (Mat_<char>(3, 3) << 0, -1, 0, -1, 5, -1, 0, -1, 0);
    Mat kernel = (Mat_<char>(3, 3) << 0, -2, 0, -2, 9, -2, 0, -2, 0);
    filter2D(src, dst, src.depth(), kernel);
    
    UIImage *result = MatToUIImage(dst);
    return result;
}


+ (double )sharpness:(UIImage *)image {
    
    Mat mat;
    UIImageToMat(image, mat);
    
    Mat grayMat;
    cvtColor(mat, grayMat, CV_BGR2GRAY);
    
    Mat dst;
    Laplacian(grayMat, dst, mat.depth());
    
//    Sobel(mat, dst, mat.depth(), 1, 1);
    
//高阈值，opencv建议是低阈值的3倍
//    Canny(mat, dst, 50, 150);
    
//    标准差
    Mat meanImage, meanstdImage;
    meanStdDev(grayMat, meanImage, meanstdImage);

    double meanValue = 0.0;
    meanValue = meanstdImage.at<double>(0, 0);

    return meanValue;
    
//    waitKey();
    
//    UIImage *imageN = MatToUIImage(dst);
//    return imageN;
    
}

//低通滤波
+ (UIImage *)lowpassImage:(UIImage *)image {
    Mat src;
    UIImageToMat(image, src);

    Mat dst;
//    blur(src, dst, cv::Size(5,5));
    GaussianBlur(src, dst, cv::Size(5,5), 5.5);
    
    UIImage *result = MatToUIImage(dst);
    return result;
}

//中值滤波 (非线性滤波 有效去除椒盐噪点)
+ (UIImage *)medianfilter:(UIImage *)image {
    Mat src;
    UIImageToMat(image, src);
    
    Mat dst;
    medianBlur(src, dst, 9);

    UIImage *result = MatToUIImage(dst);
    return result;
}

+ (UIImage *)doubleSlider:(UIImage *)image {
    Mat src;
    UIImageToMat(image, src);
    
    Mat dst;
    bilateralFilter(src, dst, 15, 150, 3);
    
    UIImage *result = MatToUIImage(dst);
    return result;
}

+ (UIImage *)blendWith:(UIImage *)image another:(UIImage *)image2 {
    Mat src1,src2, dst;
    UIImageToMat(image, src1);
    UIImageToMat(image2, src2);
    if (src1.data && src2.data ) {
        double alpha = 0.5;    //权值，系数
        addWeighted(src1, alpha, src2, (1.0 - alpha), 0.0, dst);
        
        UIImage *result = MatToUIImage(dst);
        return result;
    }
    return nil;
}


+ (UIImage *)changeColor:(UIImage *)image {
    Mat src;
    UIImageToMat(image, src);
    Mat dst;
    
    cvtColor(src, dst, COLOR_BGR2Lab);   //翻转色彩
    
    UIImage *result = MatToUIImage(dst);
    return result;

}


+ (UIImage *)changeStyle:(UIImage *)image {
    
    Mat src;
    UIImageToMat(image, src);
    Mat dst1, dst2;
    
//    pencilSketch(src, dst1, dst2);
      detailEnhance(src, dst1);
//    edgePreservingFilter(src, dst1);
    
    UIImage *result = MatToUIImage(dst1);
    return result;

}

+ (UIImage *)equalHist:(UIImage *)image {

    Mat src, dst;
    UIImageToMat(image, src);
    
    cvtColor( src, src, COLOR_BGR2GRAY );
    equalizeHist( src, dst );
    
    UIImage *result = MatToUIImage(dst);
    return result;
}


+ (UIImage *)autoContrast:(UIImage *)image {
    //iplimage 转换成 mat
    Mat src;
    UIImageToMat(image, src);
    
    Mat mat2;
//    mat2 = src;
    
    //自动对比度转换
//    BrightnessAndContrastAuto(src,mat2,1);

    mat2 = myAutocontrost(src);
    
    UIImage *newImage = MatToUIImage(mat2);
    return newImage;
}

void BrightnessAndContrastAuto(const cv::Mat &src, cv::Mat &dst, float clipHistPercent)
{
    CV_Assert(clipHistPercent >= 0);
    CV_Assert((src.type() == CV_8UC1) || (src.type() == CV_8UC3) || (src.type() == CV_8UC4));
    
    int histSize = 256;
    float alpha, beta;
    double minGray = 0, maxGray = 0;
    
    //to calculate grayscale histogram
    cv::Mat gray;
    if (src.type() == CV_8UC1) gray = src;
    else if (src.type() == CV_8UC3) cvtColor(src, gray, CV_BGR2GRAY);
    else if (src.type() == CV_8UC4) cvtColor(src, gray, CV_BGRA2GRAY);
    if (clipHistPercent == 0)
    {
        // keep full available range
        cv::minMaxLoc(gray, &minGray, &maxGray);
    }
    else
    {
        cv::Mat hist; //the grayscale histogram
        
        float range[] = { 0, 256 };
        const float* histRange = { range };
        bool uniform = true;
        bool accumulate = false;
        cv::calcHist(&gray, 1, 0, cv::Mat (), hist, 1, &histSize, &histRange, uniform, accumulate);
        
        // calculate cumulative distribution from the histogram
        std::vector<float> accumulator(histSize);
        accumulator[0] = hist.at<float>(0);
        for (int i = 1; i < histSize; i++)
        {
            accumulator[i] = accumulator[i - 1] + hist.at<float>(i);
        }
        
        // locate points that cuts at required value
        float max = accumulator.back();
        clipHistPercent *= (max / 100.0); //make percent as absolute
        clipHistPercent /= 2.0; // left and right wings
        // locate left cut
        minGray = 0;
        while (accumulator[minGray] < clipHistPercent)
            minGray++;
        
        // locate right cut
        maxGray = histSize - 1;
        while (accumulator[maxGray] >= (max - clipHistPercent))
            maxGray--;
    }
    
    // current range
    float inputRange = maxGray - minGray;
    
    alpha = (histSize - 1) / inputRange;   // alpha expands current range to histsize range
    beta = -minGray * alpha;             // beta shifts current range so that minGray will go to 0
    
    // Apply brightness and contrast normalization
    // convertTo operates with saurate_cast
    src.convertTo(dst, -1, alpha, beta);
    
    // restore alpha channel from source
    if (dst.type() == CV_8UC4)
    {
        int from_to[] = { 3, 3};
        cv::mixChannels(&src, 4, &dst,1, from_to, 1);
    }
    return;
}

Mat autocontrost(Mat matface)
{
    //进行自动对比度校正
    double HistRed[256]  ={0};
    double HistGreen[256]={0};
    double HistBlue[256] ={0};
    int bluemap[256]     ={0};
    int redmap[256]      ={0};
    int greenmap[256]    ={0};
    
    double dlowcut = 0.1;
    double dhighcut = 0.1;
    for (int i=0;i<matface.rows;i++)
    {
        for (int j=0;j<matface.cols;j++)
        {
            int iblue =matface.at<Vec3b>(i,j)[0];
            int igreen=matface.at<Vec3b>(i,j)[1];
            int ired  =matface.at<Vec3b>(i,j)[2];
            HistBlue[iblue]++;
            HistGreen[igreen]++;
            HistRed[ired]++;
        }
    }
    int PixelAmount = matface.rows*matface.cols;
    int isum = 0;
    // blue
    int iminblue=0;int imaxblue=0;
    for (int y = 0;y<256;y++)
    {
        isum= isum+HistBlue[y];
        if (isum>=PixelAmount*dlowcut*0.01)
        {
            iminblue = y;
            break;
        }
    }
    isum = 0;
    for (int y=255;y>=0;y--)
    {
        isum=isum+HistBlue[y];
        if (isum>=PixelAmount*dhighcut*0.01)
        {
            imaxblue=y;
            break;
        }
    }
    //red
    isum=0;
    int iminred=0;int imaxred=0;
    for (int y = 0;y<256;y++)//这两个操作我基本能够了解了
    {
        isum= isum+HistRed[y];
        if (isum>=PixelAmount*dlowcut*0.01)
        {
            iminred = y;
            break;
        }
    }
    isum = 0;
    for (int y=255;y>=0;y--)
    {
        isum=isum+HistRed[y];
        if (isum>=PixelAmount*dhighcut*0.01)
        {
            imaxred=y;
            break;
        }
    }
    //green
    isum=0;
    int imingreen=0;int imaxgreen=0;
    for (int y = 0;y<256;y++)//这两个操作我基本能够了解了
    {
        isum= isum+HistGreen[y];
        if (isum>=PixelAmount*dlowcut*0.01)
        {
            imingreen = y;
            break;
        }
    }
    isum = 0;
    for (int y=255;y>=0;y--)
    {
        isum=isum+HistGreen[y];
        if (isum>=PixelAmount*dhighcut*0.01)
        {
            imaxgreen=y;
            break;
        }
    }
    
    /////////自动色阶
    //自动对比度   （找出 RGB最大最小值）
    int imin = 255;int imax =0;
    if (imin>iminblue)
        imin = iminblue;
    if (imin>iminred)
        imin = iminred;
    if (imin>imingreen)
        imin = imingreen;
    iminblue = imin    ;
    imingreen=imin;
    iminred = imin    ;
    if (imax<imaxblue)
        imax    = imaxblue;
    if (imax<imaxgreen)
        imax    =imaxgreen;
    if (imax<imaxred)
        imax    =imaxred;
    imaxred = imax;
    imaxgreen = imax;
    imaxblue=imax;
    /////////////////
    
//    鲁棒性判断
    if (imaxblue == iminblue) {
        NSLog(@"蓝色");
    }
    if (imaxred == iminred) {
        NSLog(@"红色");
    }
    if (imaxgreen == imingreen) {
        NSLog(@"绿色");
    }

    
    //blue
    for (int y=0;y<256;y++)
    {
        if (y<=iminblue)
        {
            bluemap[y]=0;
        }
        else
        {
            if (y>imaxblue)
            {
                bluemap[y]=255;
            }
            else
            {
                //  BlueMap(Y) = (Y - MinBlue) / (MaxBlue - MinBlue) * 255     线性隐射
                float ftmp = (float)(y-iminblue)/(imaxblue-iminblue);
                bluemap[y]=(int)(ftmp*255);
            }
        }
        
    }
    //red
    for (int y=0;y<256;y++)
    {
        if (y<=iminred)
        {
            redmap[y]=0;
        }
        else
        {
            if (y>imaxred)
            {
                redmap[y]=255;
            }
            else
            {
                //  BlueMap(Y) = (Y - MinBlue) / (MaxBlue - MinBlue) * 255      '线性隐射
                float ftmp = (float)(y-iminred)/(imaxred-iminred);
                redmap[y]=(int)(ftmp*255);
            }
        }
        
    }
    //green
    for (int y=0;y<256;y++)
    {
        if (y<=imingreen)
        {
            greenmap[y]=0;
        }
        else
        {
            if (y>imaxgreen)
            {
                greenmap[y]=255;
            }
            else
            {
                //  BlueMap(Y) = (Y - MinBlue) / (MaxBlue - MinBlue) * 255      '线性隐射
                float ftmp = (float)(y-imingreen)/(imaxgreen-imingreen);
                greenmap[y]=(int)(ftmp*255);
            }
        }
        
    }
    
    
    //查表映射
    for (int i=0;i<matface.cols;i++)
    {
        for (int j=0;j<matface.rows;j++)
        {
            matface.at<Vec3b>(i,j)[0]=bluemap[matface.at<Vec3b>(i,j)[0]];
            matface.at<Vec3b>(i,j)[1]=greenmap[matface.at<Vec3b>(i,j)[1]];
            matface.at<Vec3b>(i,j)[2]=redmap[matface.at<Vec3b>(i,j)[2]];
        }
    }
    
    return matface;
}

Mat myAutocontrost(Mat matface)
{
    //进行自动对比度校正
    double HistRed[256]   = {0};
    double HistGreen[256] = {0};
    double HistBlue[256]  = {0};
    
    double dlowcut = 0.1;
    double dhighcut = 0.1;
    for (int i=0;i<matface.rows;i++)
    {
        for (int j=0;j<matface.cols;j++)
        {
            int iblue =matface.at<Vec3b>(i,j)[0];
            int igreen=matface.at<Vec3b>(i,j)[1];
            int ired  =matface.at<Vec3b>(i,j)[2];
            HistBlue[iblue]++;
            HistGreen[igreen]++;
            HistRed[ired]++;
        }
    }
    
    int PixelAmount = matface.rows*matface.cols;
    int isum = 0;
    // blue
    int iminblue=0;int imaxblue=0;
    for (int y = 0;y<256;y++)
    {
        isum= isum+HistBlue[y];
        if (isum>=PixelAmount*dlowcut*0.1)
        {
            iminblue = y;
            break;
        }
    }
    isum = 0;
    for (int y=255;y>=0;y--)
    {
        isum=isum+HistBlue[y];
        if (isum>=PixelAmount*dhighcut*0.1)
        {
            imaxblue=y;
            break;
        }
    }
    //red
    isum=0;
    int iminred=0;int imaxred=0;
    for (int y = 0;y<256;y++)//这两个操作我基本能够了解了
    {
        isum= isum+HistRed[y];
        if (isum>=PixelAmount*dlowcut*0.1)
        {
            iminred = y;
            break;
        }
    }
    isum = 0;
    for (int y=255;y>=0;y--)
    {
        isum=isum+HistRed[y];
        if (isum>=PixelAmount*dhighcut*0.1)
        {
            imaxred=y;
            break;
        }
    }
    //green
    isum=0;
    int imingreen=0;int imaxgreen=0;
    for (int y = 0;y<256;y++)//这两个操作我基本能够了解了
    {
        isum= isum+HistGreen[y];
        if (isum>=PixelAmount*dlowcut*0.1)
        {
            imingreen = y;
            break;
        }
    }
    isum = 0;
    for (int y=255;y>=0;y--)
    {
        isum=isum+HistGreen[y];
        if (isum>=PixelAmount*dhighcut*0.1)
        {
            imaxgreen=y;
            break;
        }
    }
    
//自动对比度
//    重新对比出各通道的上下限的最小值和最大值
    
//下限
    int imin = 0;int imax =0;
    if (iminblue < imingreen) {
        imin = iminblue;
    }else {
        imin = imingreen;
    }
    if (imin > iminred) {
        imin = iminred;
    }
    
//上限
    if ( imaxblue > imaxgreen) {
        imax = imaxblue;
    }else {
        imax = imaxgreen;
    }
    if (imaxred > imax) {
        imax = imaxred;
    }
    
//重新计算映射表
    int allmap[256]={0};
    for (int y=0;y<256;y++)
    {
        if (y<=imin)
        {
            allmap[y]=0;
        }
        else
        {
            if (y>imax)
            {
                allmap[y]=255;
            }
            else
            {
                //  BlueMap(Y) = (Y - MinBlue) / (MaxBlue - MinBlue) * 255     线性隐射
                float ftmp = (float)(y-imin)/(imax-imin);
                allmap[y]=(int)(ftmp*255);
            }
        }
        
    }
    
    //查表映射，对应红绿蓝进行处理
    for (int i=0;i<matface.rows;i++)
    {
        for (int j=0;j<matface.cols;j++)
        {
            matface.at<Vec3b>(i,j)[0]=allmap[matface.at<Vec3b>(i,j)[0]];
            matface.at<Vec3b>(i,j)[1]=allmap[matface.at<Vec3b>(i,j)[1]];
            matface.at<Vec3b>(i,j)[2]=allmap[matface.at<Vec3b>(i,j)[2]];
        }
    }
    
    return matface;
}


#pragma mark --Extension

+ (cv::Mat)cvMatFromUIImage:(UIImage *)image {
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

+ (UIImage *)UIImageFromCVMat:(cv::Mat)cvMat {
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {//可以根据这个决定使用哪种
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
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

+ (BOOL) whetherTheImageBlurry:(UIImage*)image{
    
    unsigned char *data;
    int height,width,step;
    
    int Iij;
    
    double Iave = 0, Idelta = 0;
    
    cv::Mat mat = [OsbornOpenCV cvMatFromUIImage:image];
    
    if(!mat.empty()){
        cv::Mat gray;
        cv::Mat outGray;
        // 将图像转换为灰度显示
        cv::cvtColor(mat,gray,CV_RGB2GRAY);
        // 用openCV的Laplacian函数做灰度图做拉普拉斯计算，得到outGray
        cv::Laplacian(gray, outGray, gray.depth());
        //将得到的outGray转化为图片信息类IplImage
        IplImage ipl_image(outGray);
        
        data   = (uchar*)ipl_image.imageData;  //图片像素信息
        height = ipl_image.height;             //图片像素高度
        width  = ipl_image.width;              //图片像素宽度
        step   = ipl_image.widthStep;          //排列的图像行大小，以字节为单位
        
        for(int i=0;i<height;i++){    //求方差
            for(int j=0;j<width;j++)
            {
                Iij    = (int) data
                [i*width+j];
                Idelta    = Idelta + (Iij-Iave)*(Iij-Iave);
            }
        }
        Idelta = Idelta/(width*height);
        
        std::cout<<"矩阵方差为："<<Idelta<<std::endl;
    }
    
    return (Idelta > delta) ? YES : NO;
}


@end
