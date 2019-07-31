//
//  UIColor+Hex.m
//  PhotoEditor
//
//  Created by osborn on 2018/7/4.
//  Copyright © 2018年 YR. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

- (CGFloat)red {
    CGColorRef color = self.CGColor;
    CGFloat const *components = CGColorGetComponents(color);
    if(CGColorSpaceGetModel(CGColorGetColorSpace(color)) == kCGColorSpaceModelMonochrome)
    {
        return components[0];
    }
    else if (CGColorSpaceGetModel(CGColorGetColorSpace(color)) == kCGColorSpaceModelRGB) {
        return components[0];
    }
    
    return -1;
}
    
- (CGFloat)green {
    CGColorRef color = self.CGColor;
    CGFloat const *components = CGColorGetComponents(color);
    if(CGColorSpaceGetModel(CGColorGetColorSpace(color)) == kCGColorSpaceModelMonochrome)
    {
        return components[0];
    }
    else if (CGColorSpaceGetModel(CGColorGetColorSpace(color)) == kCGColorSpaceModelRGB)
    {
        return components[1];
    }
    return -1;
}
    
- (CGFloat)blue {
    CGColorRef color = self.CGColor;
    CGFloat const *components = CGColorGetComponents(color);
    if(CGColorSpaceGetModel(CGColorGetColorSpace(color)) == kCGColorSpaceModelMonochrome)
    {
        return components[0];
    }
    else if (CGColorSpaceGetModel(CGColorGetColorSpace(color)) == kCGColorSpaceModelRGB)
    {
        return components[2];
    }
    return -1;
}
    
- (CGFloat)alpha {
    return CGColorGetAlpha(self.CGColor);
}

+ (UIColor *) colorWithHexString: (NSString *)hexString {
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    //hexString应该6到8个字符
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    //如果hexString 有@"0X"前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    
    //如果hexString 有@"#""前缀
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    //RGB转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //R
    NSString *rString = [cString substringWithRange:range];
    //G
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //B
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r/255.0f) green:((float) g/255.0f) blue:((float) b/255.0f) alpha:1.0f];
}

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue alpha:(CGFloat)alpha {
    
    return [UIColor colorWithRed:((float) red/255.0f) green:((float) green/255.0f) blue:((float) blue/255.0f) alpha:alpha];

}

+ (UIColor *)colorWithHex:(long)hexColor {
    CGFloat red = ((CGFloat)((hexColor & 0xFF0000) >> 16))/255.0f;
    CGFloat green = ((CGFloat)((hexColor & 0xFF00) >> 8))/255.0f;
    CGFloat blue = ((CGFloat)(hexColor & 0xFF))/255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

+ (UIColor *)colorWithHex:(long)hexColor alpha:(CGFloat)alpha{
    CGFloat red = ((CGFloat)((hexColor & 0xFF0000) >> 16))/255.0f;
    CGFloat green = ((CGFloat)((hexColor & 0xFF00) >> 8))/255.0f;
    CGFloat blue = ((CGFloat)(hexColor & 0xFF))/255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (NSString *)hexString {
    //颜色值个数，rgb和alpha
    NSInteger cpts = CGColorGetNumberOfComponents(self.CGColor);
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    CGFloat r = components[0];//红色
    CGFloat g = components[1];//绿色
    CGFloat b = components[2];//蓝色
    if (cpts == 4) {
        CGFloat a = components[3];//透明度
        return [NSString stringWithFormat:@"%02lX%02lX%02lX%02lX", lroundf(a * 255), lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
    } else {
        return [NSString stringWithFormat:@"%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255)];
    }
}

+ (UIColor *) colorWithHexString: (NSString *)hexString alpha:(CGFloat)alpha {
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    //hexString应该6到8个字符
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    //如果hexString 有@"0X"前缀
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    
    //如果hexString 有@"#""前缀
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    //RGB转换
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //R
    NSString *rString = [cString substringWithRange:range];
    //G
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //B
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r/255.0f) green:((float) g/255.0f) blue:((float) b/255.0f) alpha:alpha];
}

@end
