//
//  StudyVideoViewController.m
//  Maxmoo
//
//  Created by 程超 on 2024/5/7.
//

#import "StudyVideoViewController.h"
#import "Maxmoo-Swift.h"
#include "chapter_1.h"
#include "chapter_2.h"
#include "chapter_3.h"
#include "ff_decode_video.h"

@interface StudyVideoViewController ()

@end

@implementation StudyVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    //    [self videoDemo];
    [self videoStudy];
}

- (void)videoDemo {
    NSString *videoPath = [NSString stringWithFormat:@"%@%@",[CCFileManager shared].document, @"/test.mp4"];
    NSString *outPath = [NSString stringWithFormat:@"%@%@",[CCFileManager shared].document, @"/out_test.mp4"];
    [[CCFileManager shared] createFileWithUrlString:[CCFileManager shared].document fileName:@"/out_test.mp4"];
//    start([videoPath UTF8String]);
}

- (void)videoStudy {
//    NSString *videoPath = [NSString stringWithFormat:@"%@%@",[CCFileManager shared].document, @"/fuzhou.mp4"];
    NSString *outPath = [NSString stringWithFormat:@"%@%@",[CCFileManager shared].document, @"/empty.mp4"];
    
    NSString *videoPath = [[NSBundle mainBundle] pathForResource:@"i-see-fire" ofType:@"mp4"];
    //empty.mp4
//    NSString *outPath = [[NSBundle mainBundle] pathForResource:@"empty" ofType:@"mp4"];
    
    const char *file_name = [videoPath UTF8String];
    const char *out_file_name = [outPath UTF8String];
    
    // ff examples
//    c_decode_video(file_name, out_file_name);
    
    // 1
//    hello();
    // 2
//    chapter_2(file_name);
    // 3
    chapter_3(file_name, out_file_name);

}

@end
