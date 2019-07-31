//
//  UIColor+Hex.h
//  PhotoEditor
//
//  Created by osborn on 2018/7/4.
//  Copyright © 2018年 YR. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kMaxColor [UIColor colorWithHex:0xD5D5D6]
#define kMinColor [UIColor colorWithHex:0x2D2E32]

@interface UIColor (Hex)

//颜色分量提取，即R,G,B,A，请保证当前颜色域为RGB模式，否则无法获取
@property (nonatomic, assign, readonly) CGFloat red;
@property (nonatomic, assign, readonly) CGFloat green;
@property (nonatomic, assign, readonly) CGFloat blue;
@property (nonatomic, assign, readonly) CGFloat alpha;

+ (UIColor *)colorWithHexString:(NSString *)hexString;

+ (UIColor *)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue alpha:(CGFloat)alpha;

+ (UIColor *)colorWithHex:(long)hexColor;

+ (UIColor *)colorWithHex:(long)hexColor alpha:(CGFloat)alpha;

- (NSString *)hexString;

+ (UIColor *)colorWithHexString: (NSString *)hexString alpha:(CGFloat)alpha;

@end
