//
//  chapter_1.c
//  Maxmoo
//
//  Created by 程超 on 2024/5/7.
//

#include "chapter_1.h"
#include <libavutil/avutil.h>

int hello(void) {
    av_log(NULL, AV_LOG_INFO, "Hello World\n");
    return 0;
}
