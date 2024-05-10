//
//  CVideoHelper.h
//  Maxmoo
//
//  Created by 程超 on 2024/5/8.
//

#import <UIKit/UIKit.h>
#import <MetalKit/MetalKit.h>
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libavfilter/avfilter.h>
#include <libavfilter/buffersrc.h>
#include <libavfilter/buffersink.h>
#include <libavutil/opt.h>

NS_ASSUME_NONNULL_BEGIN

@interface CVideoHelper : NSObject

+ (CVPixelBufferRef)transAVFrame: (AVFrame *)frame;

@end

NS_ASSUME_NONNULL_END
