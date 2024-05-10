//
//  CVideoHelper.m
//  Maxmoo
//
//  Created by 程超 on 2024/5/8.
//

#import "CVideoHelper.h"
#import "Maxmoo-Swift.h"

@implementation CVideoHelper

+ (CVPixelBufferRef)transAVFrame: (AVFrame *)frame {
    return [[CCVideoHelper shared] makeCVPixelBufferFrom:frame];
}

@end
