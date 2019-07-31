//
//  OsbornSlider.m
//  OpenCV
//
//  Created by osborn on 2019/7/30.
//  Copyright © 2019 osborn. All rights reserved.
//

#import "OsbornSlider.h"
//#import <FrameAccessor/FrameAccessor.h>

#define  ImageNamed(name) [UIImage imageNamed:name]
#define  kMainDefaultFontName   @"PingFangSC-Regular"

#define  KFrameSizeWidth     (self.frame.size.width)
#define  KFrameSizeheight    (self.frame.size.height)


@interface OsbornSlider ()
{
    CGRect _thumbRect;
}

@property(nonatomic, strong) UILabel *sliderValueLabel;
@property(nonatomic, strong) UIImageView *labelBgImageView;

@end

@implementation OsbornSlider

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat lineH = 1.0;
    //底线
//    [kMaxColor setFill];
    [[UIColor grayColor] setFill];
    CGFloat lineX = 3;
    UIRectFill(CGRectMake(lineX, KFrameSizeheight/2-lineH/2, KFrameSizeWidth-lineX*2, lineH));
    
    //原点
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat dotW = 3.0;
    CGFloat dotH = 3.0;
    CGFloat dotX = lineX-dotW/2;
    CGFloat dotY = KFrameSizeheight/2-dotH/2;
    if ([self isZeroInCenter]) {
        dotX = KFrameSizeWidth/2.0-dotW/2;
    }
    CGContextAddEllipseInRect(context, CGRectMake(dotX, dotY, dotW, dotH));
//    [kMinColor set];
    [[UIColor whiteColor] setFill];
    
    
    //绘制
    CGContextDrawPath(context, kCGPathFillStroke);
    
    //改变了的颜色线
    [[UIColor whiteColor] setFill];
    
    CGPoint zeroPoint = CGPointMake([self isZeroInCenter] ? KFrameSizeWidth/2 : lineX, KFrameSizeheight/2-lineH/2);
    CGPoint thumbCenter = CGPointMake(_thumbRect.origin.x+_thumbRect.size.width/2, _thumbRect.origin.y+_thumbRect.size.height/2);
    CGRect lineRect = CGRectZero;
    if (self.value > 0) {
        lineRect = CGRectMake(zeroPoint.x, zeroPoint.y, thumbCenter.x-zeroPoint.x, lineH);
    } else {
        lineRect = CGRectMake(thumbCenter.x, zeroPoint.y, zeroPoint.x-thumbCenter.x, lineH);
    }
    UIRectFill(lineRect);
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self =  [super initWithFrame:frame];
    if (self)
    {
        UIImage *thumbImage = [UIImage imageNamed:@"slider_thumb"];
        [self setThumbImage:thumbImage forState:UIControlStateHighlighted];
        [self setThumbImage:thumbImage forState:UIControlStateNormal];
        self.maximumTrackTintColor = [UIColor clearColor];
        self.minimumTrackTintColor = [UIColor clearColor];
        
        self.labelBgImageView = [[UIImageView alloc] init];
        self.labelBgImageView.image = ImageNamed(@"slider_thumb_bg");
        [self addSubview:self.labelBgImageView];
        self.labelBgImageView.alpha = 0;
        
        self.sliderValueLabel = [[UILabel alloc] init];
        self.sliderValueLabel.textAlignment = NSTextAlignmentCenter;
        self.sliderValueLabel.font = [UIFont fontWithName:kMainDefaultFontName size:12];
        self.sliderValueLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.sliderValueLabel];
        self.sliderValueLabel.alpha = 0;
    }
    return self;
}

- (BOOL)isZeroInCenter
{
    return (self.minimumValue + self.maximumValue == 0);
}

#pragma mark -
- (void)setHiddenNumber:(BOOL)hiddenNumber
{
    _hiddenNumber = hiddenNumber;
    self.sliderValueLabel.hidden = hiddenNumber;
}

#pragma mark - 横线粗细
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    CGFloat h = 1.0;
    return CGRectMake(0, (KFrameSizeheight-h)/2, bounds.size.width, h);
}

#pragma mark - 小图标
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value
{
    CGRect thumbRect = [super thumbRectForBounds:bounds trackRect:rect value:value];
    _thumbRect = thumbRect;
    thumbRect = CGRectInset([super thumbRectForBounds:bounds trackRect:thumbRect value:value], 0, 0);
    
    //    if ([self isZeroInCenter]) {//如果value默认在中间时，滑到(-3，3)时，直接跳到0
    //        if (self.value>-3 && self.value<3) {
    //            thumbRect.origin.x = (bounds.size.width-thumbRect.size.width)/2;
    //            self.value = 0;
    //        }
    //    }
    
    self.sliderValueLabel.text = [NSString stringWithFormat:@"%.0f", self.value];
    if ([self.sliderValueLabel.text isEqualToString:@"-0"]) {//有时候会显示 -0 的问题
        self.sliderValueLabel.text = @"0";
        self.value = 0;
    }
    [self.sliderValueLabel sizeToFit];
   
//
//    float labelX = thumbRect.origin.x+(thumbRect.size.width-_sliderValueLabel.width)/2;
//    float labelY = thumbRect.origin.y - _sliderValueLabel.height - 18;
//    [self.sliderValueLabel setViewOrigin:CGPointMake(labelX, labelY)];
//    self.labelBgImageView.frame = CGRectMake(0, 0, 42, 31);
//    self.labelBgImageView.center = CGPointMake(self.sliderValueLabel.centerX, self.sliderValueLabel.centerY+3);
    
    [self setNeedsDisplay];
    
    return thumbRect;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    if (!_hiddenNumber) {
        self.sliderValueLabel.alpha = 0;
        self.labelBgImageView.alpha = 0;
        [UIView animateWithDuration:0.2 animations:^{
            self.sliderValueLabel.alpha = 1;
            self.labelBgImageView.alpha = 1;
        }];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    if (!_hiddenNumber) {
        self.sliderValueLabel.alpha = 1;
        self.labelBgImageView.alpha = 1;
        [UIView animateWithDuration:0.2 animations:^{
            self.sliderValueLabel.alpha = 0;
            self.labelBgImageView.alpha = 0;
        }];
    }
}

@end
