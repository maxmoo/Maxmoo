//
//  JKScreenRecorder.m
//  JKScreenRecorder
//
//  Created by Jakey on 2017/2/5.
//  Copyright © 2017年 www.skyfox.org. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "ZYSScreenRecorder.h"

// 录屏倍数
//#define kScreenScale ([UIScreen mainScreen].scale)
#define kScreenScale (2)

@interface ZYSScreenRecorder ()
{
    CVPixelBufferPoolRef _outputBufferPool;
    CGColorSpaceRef _rgbColorSpace;
}

@property (nonatomic, assign) NSTimeInterval duration;
@property (nonatomic, strong) NSString *videoPath;

@property (nonatomic, copy) ZYSScreenRecording screenRecording;
@property (nonatomic, copy) ZYSScreenRecordStop screenRecordStop;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger frameCount;
@property (nonatomic, strong) AVAssetWriter *videoWriter;
@property (nonatomic, strong) AVAssetWriterInput *videoWriterInput;
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *adaptor;

@property (nonatomic, assign) BOOL isPausing;

@end

@implementation ZYSScreenRecorder

- (void)dealloc {
    CGColorSpaceRelease(_rgbColorSpace);
    if (_outputBufferPool != NULL) {
        CVPixelBufferPoolRelease(_outputBufferPool);
    }
}

#pragma mark - life cycle
- (instancetype)init {
    if (self = [super init]) {
        // set default frame rate to 24.
        self.frameRate = 24;
        self.duration = 0;
        self.isPausing = false;
        _rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    return self;
}

#pragma mark - start / stop
- (void)startRecording {
    NSLog(@"录制开始");
    self.frameCount = 0;
    if (self.isPausing == NO) {
        __weak typeof(self) weakSelf = self;
        [self setupVideoWriter:^{
            [weakSelf startTimer];
        }];
    } else {
        self.isPausing = false;
        [self startTimer];
    }
}

- (void)startTimer {
    // init timer
    NSDate *nowDate = [NSDate date];
    self.timer = [[NSTimer alloc] initWithFireDate:nowDate interval:1.0 / self.frameRate target:self selector:@selector(drawFrame) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)pauseRecording {
    self.isPausing = true;
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)stopRecordingWithHandler:(ZYSScreenRecordStop)handler {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    [self.videoWriterInput markAsFinished];
    [self.videoWriter finishWritingWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler(self.videoPath);
            }
        });
        
        self.adaptor = nil;
        self.videoWriterInput = nil;
        self.videoWriter = nil;
    }];
}

#pragma mark - recording method, send duration
- (void)screenRecording:(ZYSScreenRecording)screenRecording {
    self.screenRecording = [screenRecording copy];
}

#pragma mark - private methods
- (void)drawFrame {
    self.duration += 1.0 / self.frameRate;
    [self makeFrame];

    if (self.screenRecording) {
        __weak typeof (self) weakself = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakself.screenRecording(weakself.duration);
        });
    }
}

/// make per frame
- (void)makeFrame {
    self.frameCount++;
    CMTime frameTime = CMTimeMake(self.frameCount, (int32_t)self.frameRate);
    [self appendVideoFrameAtTime:frameTime];
}


/// append image to video
- (void)appendVideoFrameAtTime:(CMTime)frameTime {
//    CGImageRef newImage = [self fetchScreenshot].CGImage;
    
    if (![self.videoWriterInput isReadyForMoreMediaData]) {
        NSLog(@"Not ready for video data");
    } else {
        if (self.adaptor.assetWriterInput.readyForMoreMediaData) {
            NSLog(@"Processing video frame (%zd)", self.frameCount);
            
//            CVPixelBufferRef buffer = [self pixelBufferFromCGImage:newImage];
            CVPixelBufferRef buffer = [self pixelBufferFromOther];
            if(![self.adaptor appendPixelBuffer:buffer withPresentationTime:frameTime]){
                NSError *error = self.videoWriter.error;
                if(error) {
                    NSLog(@"Unresolved error %@,%@.", error, [error userInfo]);
                }
            }
            CVPixelBufferRelease(buffer);
        } else {
            printf("adaptor not ready %zd\n", self.frameCount);
        }
        NSLog(@"**************************************************");
    }
}

/// init video writer
- (BOOL)setupVideoWriter: (void(^)(void))complete {
    NSLog(@"******start********************************************");
    CGSize size = self.captureView.bounds.size;
    
    NSString *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    self.videoPath = [documents stringByAppendingPathComponent:@"video.mp4"];
    
    [[NSFileManager defaultManager] removeItemAtPath:self.videoPath error:nil];
    NSLog(@"******1********************************************");

    NSError *error;
    // Configure videoWriter
    NSURL *fileUrl = [NSURL fileURLWithPath:self.videoPath];
    self.videoWriter = [[AVAssetWriter alloc] initWithURL:fileUrl fileType:AVFileTypeMPEG4 error:&error];
    NSParameterAssert(self.videoWriter);
    NSLog(@"******2********************************************");
    // Configure videoWriterInput
    NSDictionary *videoCompressionProps = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:(size.width * kScreenScale) * (size.height * kScreenScale)], AVVideoAverageBitRateKey, nil];
    
    NSDictionary *videoSettings = @{AVVideoCodecKey: AVVideoCodecH264,
                                    AVVideoWidthKey: @(size.width * kScreenScale),
                                    AVVideoHeightKey: @(size.height * kScreenScale),
                                    AVVideoCompressionPropertiesKey: videoCompressionProps};
    
    NSDictionary *bufferAttributes = @{(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA),
                                       (id)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES,
                                       (id)kCVPixelBufferWidthKey : @(size.width * kScreenScale),
                                       (id)kCVPixelBufferHeightKey : @(size.height * kScreenScale),
                                       (id)kCVPixelBufferBytesPerRowAlignmentKey : @(size.width * kScreenScale * 4)
                                       };
    if (_outputBufferPool != NULL) {
        CVPixelBufferPoolRelease(_outputBufferPool);
    }
    _outputBufferPool = NULL;
    CVPixelBufferPoolCreate(NULL, NULL, (__bridge CFDictionaryRef)(bufferAttributes), &_outputBufferPool);
    
    self.videoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    NSLog(@"******3********************************************");

    NSParameterAssert(self.videoWriterInput);
    self.videoWriterInput.expectsMediaDataInRealTime = YES;
//    NSDictionary *bufferAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
    
    self.adaptor = [AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:self.videoWriterInput sourcePixelBufferAttributes:bufferAttributes];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"******4********************************************");
        // add input
        [self.videoWriter addInput:self.videoWriterInput];
        NSLog(@"******5********************************************");
        [self.videoWriter startWriting];
        NSLog(@"******6********************************************");
        [self.videoWriter startSessionAtSourceTime:kCMTimeZero];
        NSLog(@"******end********************************************");
        dispatch_async(dispatch_get_main_queue(), ^{
            complete();
        });
    });
    
    return YES;
}

- (CVPixelBufferRef)pixelBufferFromOther {
    CVPixelBufferRef pixelBuffer = NULL;
    CGContextRef bitmapContext = [self createPixelBufferAndBitmapContext:&pixelBuffer];
    UIGraphicsPushContext(bitmapContext); {
        @synchronized (self) {
            [_captureView drawViewHierarchyInRect:_captureView.bounds afterScreenUpdates:NO];
        }
    }; UIGraphicsPopContext();
    return  pixelBuffer;
}

- (CGContextRef)createPixelBufferAndBitmapContext:(CVPixelBufferRef *)pixelBuffer
{
    CVPixelBufferPoolCreatePixelBuffer(NULL, _outputBufferPool, pixelBuffer);
    CVPixelBufferLockBaseAddress(*pixelBuffer, 0);
    
    CGContextRef bitmapContext = NULL;
    bitmapContext = CGBitmapContextCreate(CVPixelBufferGetBaseAddress(*pixelBuffer),
                                          CVPixelBufferGetWidth(*pixelBuffer),
                                          CVPixelBufferGetHeight(*pixelBuffer),
                                          8, CVPixelBufferGetBytesPerRow(*pixelBuffer), _rgbColorSpace,
                                          kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst
                                          );
    CGContextScaleCTM(bitmapContext, kScreenScale, kScreenScale);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, _captureView.bounds.size.height);
    CGContextConcatCTM(bitmapContext, flipVertical);
    
    return bitmapContext;
}

/// image => PixelBuffer
- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image {
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey,
                             nil];
    
    CVPixelBufferRef pxbuffer = NULL;
    
    CGFloat frameWidth = CGImageGetWidth(image);
    CGFloat frameHeight = CGImageGetHeight(image);
    
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault,frameWidth,frameHeight,kCVPixelFormatType_32ARGB,(__bridge CFDictionaryRef) options, &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, frameWidth, frameHeight, 8,CVPixelBufferGetBytesPerRow(pxbuffer),rgbColorSpace,(CGBitmapInfo)kCGImageAlphaNoneSkipFirst);
    
    NSParameterAssert(context);
    CGContextConcatCTM(context, CGAffineTransformIdentity);
    CGContextDrawImage(context, CGRectMake(0, 0,frameWidth,frameHeight),  image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}

/// view => screen shot image
- (UIImage *)fetchScreenshot {
    UIImage *image = nil;
    
    if (self.captureView) {
        NSLock *aLock = [NSLock new];
        [aLock lock];
        
        CGSize imageSize = self.captureView.bounds.size;
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.captureView.layer renderInContext:context];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        [aLock unlock];
    }
    
    return image;
}


@end
