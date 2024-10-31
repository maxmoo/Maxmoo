//
//  OCStudyViewController.m
//  Maxmoo
//
//  Created by 程超 on 2024/1/15.
//

#import "OCStudyViewController.h"
#import "avformat.h"
#include <libavcodec/avcodec.h>

@interface OCStudyViewController ()

@end

@implementation OCStudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    printf("%s",avcodec_configuration());
}

- (NSAttributedString *)attLeftValue:(NSString *)leftValue rightValue:(NSString *)rightValue unit:(NSString *)unitString {
    
    NSString *baseStr = [NSString stringWithFormat:@"%@%@-%@%@",leftValue, unitString, rightValue, unitString];

    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:baseStr];

    UIFont *bigFont = [UIFont systemFontOfSize:30.0];
    UIFont *smallFont = [UIFont systemFontOfSize:14.0];

    UIColor *blackColor = [UIColor blackColor];
    [attributedString addAttribute:NSForegroundColorAttributeName value:blackColor range:NSMakeRange(0, [baseStr length])];

    [attributedString addAttribute:NSFontAttributeName value:bigFont range:[baseStr rangeOfString:leftValue]];
    [attributedString addAttribute:NSFontAttributeName value:bigFont range:[baseStr rangeOfString:rightValue]];

    CGFloat baselineOffset = (bigFont.capHeight - smallFont.capHeight) / 2.0;
    // 前一个单位
    NSRange percentSignRange1 = [baseStr rangeOfString:unitString];
    [attributedString addAttribute:NSFontAttributeName value:smallFont range:percentSignRange1];
    [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(baselineOffset) range:percentSignRange1];

    // 后一个单位
    NSRange percentSignRange2 = [baseStr rangeOfString:unitString options:NSBackwardsSearch];
    [attributedString addAttribute:NSFontAttributeName value:smallFont range:percentSignRange2];
    [attributedString addAttribute:NSBaselineOffsetAttributeName value:@(baselineOffset) range:percentSignRange2];
    
    return attributedString;
}

@end
