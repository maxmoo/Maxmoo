//
//  chapter_2.c
//  Maxmoo
//
//  Created by 程超 on 2024/5/7.
//

#include "chapter_2.h"
#include <libavformat/avformat.h>
#include <libavcodec/avcodec.h>
#include <libavfilter/avfilter.h>
#include <libavutil/avutil.h>
#include <libavutil/opt.h>

void cc_log(void *avcl, int level, const char *fmt, ...) {
    va_list args;
    fprintf( stderr, "LOG: " );
    va_start( args, fmt );
    vfprintf( stderr, fmt, args );
    va_end( args );
    fprintf( stderr, "\n" );
}

int c_read(const char *file_name) {
    AVFormatContext *fmt_ctx = NULL;
    // 打开音视频文件
    int ret = avformat_open_input(&fmt_ctx, file_name, NULL, NULL);
    if (ret < 0) {
        cc_log(NULL, AV_LOG_DEBUG, "Can't open file %s.\n", file_name);
        return -1;
    }
    cc_log(NULL, AV_LOG_DEBUG, "Success open input_file %s.\n", file_name);
    // 查找音视频文件中的流信息
    ret = avformat_find_stream_info(fmt_ctx, NULL);
    if (ret < 0) {
        cc_log(NULL, AV_LOG_DEBUG, "Can't find stream information.\n");
        return -1;
    }
    cc_log(NULL, AV_LOG_DEBUG, "Success find stream information.\n");
    const AVInputFormat* iformat = fmt_ctx->iformat;
    cc_log(NULL, AV_LOG_DEBUG, "format name is %s.\n", iformat->name);
    cc_log(NULL, AV_LOG_DEBUG, "format long_name is %s\n", iformat->long_name);
    // 关闭音视频文件
    avformat_close_input(&fmt_ctx);
    
    return 0;
}

int c_look(const char *file_name) {
    const char *filename = file_name;
    
    AVFormatContext *fmt_ctx = NULL;
    // 打开音视频文件
    int ret = avformat_open_input(&fmt_ctx, filename, NULL, NULL);
    if (ret < 0) {
        cc_log(NULL, AV_LOG_ERROR, "Can't open file %s.\n", filename);
        return -1;
    }
    cc_log(NULL, AV_LOG_INFO, "Success open input_file %s.\n", filename);
    // 查找音视频文件中的流信息
    ret = avformat_find_stream_info(fmt_ctx, NULL);
    if (ret < 0) {
        cc_log(NULL, AV_LOG_ERROR, "Can't find stream information.\n");
        return -1;
    }
    cc_log(NULL, AV_LOG_INFO, "Success find stream information.\n");
    // 格式化输出文件信息
    av_dump_format(fmt_ctx, 0, filename, 0);
    cc_log(NULL, AV_LOG_INFO, "duration=%d\n", fmt_ctx->duration); // 持续时间，单位微秒
    cc_log(NULL, AV_LOG_INFO, "bit_rate=%d\n", fmt_ctx->bit_rate); // 比特率，单位比特每秒
    cc_log(NULL, AV_LOG_INFO, "nb_streams=%d\n", fmt_ctx->nb_streams); // 数据流的数量
    cc_log(NULL, AV_LOG_INFO, "max_streams=%d\n", fmt_ctx->max_streams); // 数据流的最大数量
    // 找到视频流的索引
    int video_index = av_find_best_stream(fmt_ctx, AVMEDIA_TYPE_VIDEO, -1, -1, NULL, 0);
    cc_log(NULL, AV_LOG_INFO, "video_index=%d\n", video_index);
    if (video_index >= 0) {
        AVStream *video_stream = fmt_ctx->streams[video_index];
        cc_log(NULL, AV_LOG_INFO, "video_stream index=%d\n", video_stream->index);
        cc_log(NULL, AV_LOG_INFO, "video_stream start_time=%d\n", video_stream->start_time);
        cc_log(NULL, AV_LOG_INFO, "video_stream nb_frames=%d\n", video_stream->nb_frames);
        cc_log(NULL, AV_LOG_INFO, "video_stream duration=%d\n", video_stream->duration);
    }
    // 找到音频流的索引
    int audio_index = av_find_best_stream(fmt_ctx, AVMEDIA_TYPE_AUDIO, -1, -1, NULL, 0);
    cc_log(NULL, AV_LOG_INFO, "audio_index=%d\n", audio_index);
    if (audio_index >= 0) {
        AVStream *audio_stream = fmt_ctx->streams[audio_index];
        cc_log(NULL, AV_LOG_INFO, "audio_stream index=%d\n", audio_stream->index);
        cc_log(NULL, AV_LOG_INFO, "audio_stream start_time=%d\n", audio_stream->start_time);
        cc_log(NULL, AV_LOG_INFO, "audio_stream nb_frames=%d\n", audio_stream->nb_frames);
        cc_log(NULL, AV_LOG_INFO, "audio_stream duration=%d\n", audio_stream->duration);
    }
    avformat_close_input(&fmt_ctx); // 关闭音视频文件
    
    return 0;
}

int c_para(const char *file_name) {
    const char *filename = file_name;

    AVFormatContext *fmt_ctx = NULL;
    // 打开音视频文件
    int ret = avformat_open_input(&fmt_ctx, filename, NULL, NULL);
    if (ret < 0) {
        cc_log(NULL, AV_LOG_ERROR, "Can't open file %s.\n", filename);
        return -1;
    }
    cc_log(NULL, AV_LOG_INFO, "Success open input_file %s.\n", filename);
    // 查找音视频文件中的流信息
    ret = avformat_find_stream_info(fmt_ctx, NULL);
    if (ret < 0) {
        cc_log(NULL, AV_LOG_ERROR, "Can't find stream information.\n");
        return -1;
    }
    cc_log(NULL, AV_LOG_INFO, "Success find stream information.\n");
    cc_log(NULL, AV_LOG_INFO, "duration=%lld\n", fmt_ctx->duration); // 持续时间，单位微秒
    cc_log(NULL, AV_LOG_INFO, "nb_streams=%d\n", fmt_ctx->nb_streams); // 数据流的数量
    cc_log(NULL, AV_LOG_INFO, "max_streams=%d\n", fmt_ctx->max_streams); // 数据流的最大数量
    cc_log(NULL, AV_LOG_INFO, "video_codec_id=%d\n", fmt_ctx->video_codec_id);
    cc_log(NULL, AV_LOG_INFO, "audio_codec_id=%d\n", fmt_ctx->audio_codec_id);
    // 找到视频流的索引
    int video_index = av_find_best_stream(fmt_ctx, AVMEDIA_TYPE_VIDEO, -1, -1, NULL, 0);
    cc_log(NULL, AV_LOG_INFO, "video_index=%d\n", video_index);
    if (video_index >= 0) {
        AVStream *video_stream = fmt_ctx->streams[video_index];
        enum AVCodecID video_codec_id = video_stream->codecpar->codec_id;
        cc_log(NULL, AV_LOG_INFO, "video_stream codec_id=%d\n", video_codec_id);
        // 查找视频解码器
        AVCodec *video_codec = (AVCodec*) avcodec_find_decoder(video_codec_id);
        if (!video_codec) {
            cc_log(NULL, AV_LOG_ERROR, "video_codec not found\n");
            return -1;
        }
        cc_log(NULL, AV_LOG_INFO, "video_codec name=%s\n", video_codec->name);
        cc_log(NULL, AV_LOG_INFO, "video_codec long_name=%s\n", video_codec->long_name);
        // 下面的type字段来自AVMediaType定义，为0表示AVMEDIA_TYPE_VIDEO，为1表示AVMEDIA_TYPE_AUDIO
        cc_log(NULL, AV_LOG_INFO, "video_codec type=%d\n", video_codec->type);
        
        AVCodecContext *video_decode_ctx = NULL; // 视频解码器的实例
        video_decode_ctx = avcodec_alloc_context3(video_codec); // 分配解码器的实例
        if (!video_decode_ctx) {
            cc_log(NULL, AV_LOG_ERROR, "video_decode_ctx is null\n");
            return -1;
        }
        // 把视频流中的编解码参数复制给解码器的实例
        avcodec_parameters_to_context(video_decode_ctx, video_stream->codecpar);
        cc_log(NULL, AV_LOG_INFO, "Success copy video parameters_to_context.\n");
        cc_log(NULL, AV_LOG_INFO, "video_decode_ctx width=%d\n", video_decode_ctx->width);
        cc_log(NULL, AV_LOG_INFO, "video_decode_ctx height=%d\n", video_decode_ctx->height);
        ret = avcodec_open2(video_decode_ctx, video_codec, NULL); // 打开解码器的实例
        cc_log(NULL, AV_LOG_INFO, "Success open video codec.\n");
        if (ret < 0) {
            cc_log(NULL, AV_LOG_ERROR, "Can't open video_decode_ctx.\n");
            return -1;
        }
        cc_log(NULL, AV_LOG_INFO, "video_decode_ctx profile=%d\n", video_decode_ctx->profile);
        avcodec_close(video_decode_ctx); // 关闭解码器的实例
        avcodec_free_context(&video_decode_ctx); // 释放解码器的实例
    }
    // 找到音频流的索引
    int audio_index = av_find_best_stream(fmt_ctx, AVMEDIA_TYPE_AUDIO, -1, -1, NULL, 0);
    cc_log(NULL, AV_LOG_INFO, "audio_index=%d\n", audio_index);
    if (audio_index >= 0) {
        AVStream *audio_stream = fmt_ctx->streams[audio_index];
        enum AVCodecID audio_codec_id = audio_stream->codecpar->codec_id;
        cc_log(NULL, AV_LOG_INFO, "audio_stream codec_id=%d\n", audio_codec_id);
        // 查找音频解码器
        AVCodec *audio_codec = (AVCodec*) avcodec_find_decoder(audio_codec_id);
        if (!audio_codec) {
            cc_log(NULL, AV_LOG_ERROR, "audio_codec not found\n");
            return -1;
        }
        cc_log(NULL, AV_LOG_INFO, "audio_codec name=%s\n", audio_codec->name);
        cc_log(NULL, AV_LOG_INFO, "audio_codec long_name=%s\n", audio_codec->long_name);
        cc_log(NULL, AV_LOG_INFO, "audio_codec type=%d\n", audio_codec->type);
        
        AVCodecContext *audio_decode_ctx = NULL; // 音频解码器的实例
        audio_decode_ctx = avcodec_alloc_context3(audio_codec); // 分配解码器的实例
        if (!audio_decode_ctx) {
            cc_log(NULL, AV_LOG_ERROR, "audio_decode_ctx is null\n");
            return -1;
        }
        // 把音频流中的编解码参数复制给解码器的实例
        avcodec_parameters_to_context(audio_decode_ctx, audio_stream->codecpar);
        cc_log(NULL, AV_LOG_INFO, "Success copy audio parameters_to_context.\n");
        cc_log(NULL, AV_LOG_INFO, "audio_decode_ctx profile=%d\n", audio_decode_ctx->profile);
        cc_log(NULL, AV_LOG_INFO, "audio_decode_ctx nb_channels=%d\n", audio_decode_ctx->ch_layout.nb_channels);
        ret = avcodec_open2(audio_decode_ctx, audio_codec, NULL); // 打开解码器的实例
        cc_log(NULL, AV_LOG_INFO, "Success open audio codec.\n");
        if (ret < 0) {
            cc_log(NULL, AV_LOG_ERROR, "Can't open audio_decode_ctx.\n");
            return -1;
        }
        avcodec_close(audio_decode_ctx); // 关闭解码器的实例
        avcodec_free_context(&audio_decode_ctx); // 释放解码器的实例
    }
    avformat_close_input(&fmt_ctx); // 关闭音视频文件
    
    return 0;
}

#pragma mark - 滤镜
AVFilterContext *buffersrc_ctx = NULL; // 输入滤镜的实例
AVFilterContext *buffersink_ctx = NULL; // 输出滤镜的实例
AVFilterGraph *filter_graph = NULL; // 滤镜图

// 初始化滤镜（也称过滤器、滤波器）。第一个参数是视频流，第二个参数是解码器实例，第三个参数是过滤字符串
int init_filter(AVStream *video_stream, AVCodecContext *video_decode_ctx, const char *filters_desc) {
    int ret = 0;
    const AVFilter *buffersrc = avfilter_get_by_name("buffer"); // 获取输入滤镜
    const AVFilter *buffersink = avfilter_get_by_name("buffersink"); // 获取输出滤镜
    AVFilterInOut *inputs = avfilter_inout_alloc(); // 分配滤镜的输入输出参数
    AVFilterInOut *outputs = avfilter_inout_alloc(); // 分配滤镜的输入输出参数
    AVRational time_base = video_stream->time_base;
    enum AVPixelFormat pix_fmts[] = { AV_PIX_FMT_YUV420P, AV_PIX_FMT_NONE };
    filter_graph = avfilter_graph_alloc(); // 分配一个滤镜图
    if (!outputs || !inputs || !filter_graph) {
        ret = AVERROR(ENOMEM);
        return ret;
    }
    char args[512]; // 临时字符串，存放输入源的媒体参数信息，比如视频的宽高、像素格式等
    snprintf(args, sizeof(args),
        "video_size=%dx%d:pix_fmt=%d:time_base=%d/%d:pixel_aspect=%d/%d",
        video_decode_ctx->width, video_decode_ctx->height, video_decode_ctx->pix_fmt,
        time_base.num, time_base.den,
        video_decode_ctx->sample_aspect_ratio.num, video_decode_ctx->sample_aspect_ratio.den);
    cc_log(NULL, AV_LOG_INFO, "args : %s\n", args);
    // 创建输入滤镜的实例，并将其添加到现有的滤镜图
    ret = avfilter_graph_create_filter(&buffersrc_ctx, buffersrc, "in",
        args, NULL, filter_graph);
    if (ret < 0) {
        cc_log(NULL, AV_LOG_ERROR, "Cannot create buffer source\n");
        return ret;
    }
    // 创建输出滤镜的实例，并将其添加到现有的滤镜图
    ret = avfilter_graph_create_filter(&buffersink_ctx, buffersink, "out",
        NULL, NULL, filter_graph);
    if (ret < 0) {
        cc_log(NULL, AV_LOG_ERROR, "Cannot create buffer sink\n");
        return ret;
    }
    // 将二进制选项设置为整数列表，此处给输出滤镜的实例设置像素格式
    ret = av_opt_set_int_list(buffersink_ctx, "pix_fmts", pix_fmts,
        AV_PIX_FMT_NONE, AV_OPT_SEARCH_CHILDREN);
    if (ret < 0) {
        cc_log(NULL, AV_LOG_ERROR, "Cannot set output pixel format\n");
        return ret;
    }
    // 设置滤镜的输入输出参数
    outputs->name = av_strdup("in");
    outputs->filter_ctx = buffersrc_ctx;
    outputs->pad_idx = 0;
    outputs->next = NULL;
    // 设置滤镜的输入输出参数
    inputs->name = av_strdup("out");
    inputs->filter_ctx = buffersink_ctx;
    inputs->pad_idx = 0;
    inputs->next = NULL;
    // 把采用过滤字符串描述的图形添加到滤镜图
    ret = avfilter_graph_parse_ptr(filter_graph, filters_desc, &inputs, &outputs, NULL);
    if (ret < 0) {
        cc_log(NULL, AV_LOG_ERROR, "Cannot parse graph string\n");
        return ret;
    }
    // 检查过滤字符串的有效性，并配置滤镜图中的所有前后连接和图像格式
    ret = avfilter_graph_config(filter_graph, NULL);
    if (ret < 0) {
        cc_log(NULL, AV_LOG_ERROR, "Cannot config filter graph\n");
        return ret;
    }
    avfilter_inout_free(&inputs); // 释放滤镜的输入参数
    avfilter_inout_free(&outputs); // 释放滤镜的输出参数
    cc_log(NULL, AV_LOG_INFO, "Success initialize filter.\n");
    return ret;
}

int c_filter(const char *file_name) {
    const char *filename = file_name;

    AVFormatContext *fmt_ctx = NULL;
    // 打开音视频文件
    int ret = avformat_open_input(&fmt_ctx, filename, NULL, NULL);
    if (ret < 0) {
        cc_log(NULL, AV_LOG_ERROR, "Can't open file %s.\n", filename);
        return -1;
    }
    cc_log(NULL, AV_LOG_INFO, "Success open input_file %s.\n", filename);
    // 查找音视频文件中的流信息
    ret = avformat_find_stream_info(fmt_ctx, NULL);
    if (ret < 0) {
        cc_log(NULL, AV_LOG_ERROR, "Can't find stream information.\n");
        return -1;
    }
    cc_log(NULL, AV_LOG_INFO, "Success find stream information.\n");
    
    // 找到视频流的索引
    int video_index = av_find_best_stream(fmt_ctx, AVMEDIA_TYPE_VIDEO, -1, -1, NULL, 0);
    cc_log(NULL, AV_LOG_INFO, "video_index=%d\n", video_index);
    if (video_index >= 0) {
        AVStream *video_stream = fmt_ctx->streams[video_index];
        enum AVCodecID video_codec_id = video_stream->codecpar->codec_id;
        cc_log(NULL, AV_LOG_INFO, "video_stream codec_id=%d\n", video_codec_id);
        // 查找视频解码器
        AVCodec *video_codec = (AVCodec*) avcodec_find_decoder(video_codec_id);
        if (!video_codec) {
            cc_log(NULL, AV_LOG_INFO, "video_codec not found\n");
            return -1;
        }
        cc_log(NULL, AV_LOG_INFO, "video_codec name=%s\n", video_codec->name);
        cc_log(NULL, AV_LOG_INFO, "video_codec long_name=%s\n", video_codec->long_name);
        // 下面的type字段来自AVMediaType定义，为0表示AVMEDIA_TYPE_VIDEO，为1表示AVMEDIA_TYPE_AUDIO
        cc_log(NULL, AV_LOG_INFO, "video_codec type=%d\n", video_codec->type);
        
        AVCodecContext *video_decode_ctx = NULL; // 视频解码器的实例
        video_decode_ctx = avcodec_alloc_context3(video_codec); // 分配解码器的实例
        if (!video_decode_ctx) {
            cc_log(NULL, AV_LOG_INFO, "video_decode_ctx is null\n");
            return -1;
        }
        // 把视频流中的编解码参数复制给解码器的实例
        avcodec_parameters_to_context(video_decode_ctx, video_stream->codecpar);
        cc_log(NULL, AV_LOG_INFO, "Success copy video parameters_to_context.\n");
        ret = avcodec_open2(video_decode_ctx, video_codec, NULL); // 打开解码器的实例
        cc_log(NULL, AV_LOG_INFO, "Success open video codec.\n");
        if (ret < 0) {
            cc_log(NULL, AV_LOG_ERROR, "Can't open video_decode_ctx.\n");
            return -1;
        }
        // 初始化滤镜
        ret = init_filter(video_stream, video_decode_ctx, "fps=25");
        avcodec_close(video_decode_ctx); // 关闭解码器的实例
        avcodec_free_context(&video_decode_ctx); // 释放解码器的实例
        if (ret > 0) {
            if (buffersrc_ctx != NULL) {
                avfilter_free(buffersrc_ctx); // 释放输入滤镜的实例
            }
            if (buffersink_ctx != NULL) {
                avfilter_free(buffersink_ctx); // 释放输出滤镜的实例
            }
            if (filter_graph != NULL) {
                avfilter_graph_free(&filter_graph); // 释放滤镜图资源
            }
        } else {
            cc_log(NULL, AV_LOG_ERROR, "init_filter error.\n");
        }
    } else {
        cc_log(NULL, AV_LOG_ERROR, "Can't find video stream.\n");
        return -1;
    }
    
    avformat_close_input(&fmt_ctx); // 关闭音视频文件
    return 0;
}

#pragma mark - main
int chapter_2(const char *file_name) {
    cc_log(NULL, AV_LOG_ERROR, "------------read------------\n");
    c_read(file_name);
    cc_log(NULL, AV_LOG_ERROR, "------------look------------\n");
    c_look(file_name);
    cc_log(NULL, AV_LOG_ERROR, "------------para------------\n");
    c_para(file_name);
    cc_log(NULL, AV_LOG_ERROR, "------------filter------------\n");
    c_filter(file_name);
    return 0;
}
