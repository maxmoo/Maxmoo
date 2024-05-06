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

@end
