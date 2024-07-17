//
//  CCTextTools.m
//  Maxmoo
//
//  Created by 程超 on 2024/7/2.
//

#import "CCTextTools.h"
#import <CoreText/CoreText.h>

@implementation CCTextTools

/// 截取固定宽度字符串
+ (NSString *)getVisibleStringWithWidth:(CGFloat)width font:(UIFont *)font str:(NSString*)str {
    NSMutableParagraphStyle *p = [[NSMutableParagraphStyle alloc] init];
    p.lineBreakMode = NSLineBreakByCharWrapping;
    NSAttributedString *namesAtt = [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName:font, NSParagraphStyleAttributeName:p}];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)namesAtt);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, width, 45.)];
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, str.length), path.CGPath, NULL);
    CFRange range = CTFrameGetVisibleStringRange(frame);
    CFRelease(framesetter);
    CFRelease(frame);
    return [str substringWithRange:NSMakeRange(range.location, range.length)];
}

@end
