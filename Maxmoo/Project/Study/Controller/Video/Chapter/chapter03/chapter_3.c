//
//  chapter_3.c
//  Maxmoo
//
//  Created by 程超 on 2024/5/8.
//

#include "chapter_3.h"
#include <stdio.h>
#include <libavformat/avformat.h>
#include <libavcodec/avcodec.h>
#include <libavutil/avutil.h>

extern void cc_log(void *avcl, int level, const char *fmt, ...);

int c_copy(const char *file_name, const char *out_file_name) {
    const char *src_name = file_name;
    const char *dest_name = out_file_name;

    AVFormatContext *in_fmt_ctx = NULL; // 输入文件的封装器实例
    // 打开音视频文件
    int ret = avformat_open_input(&in_fmt_ctx, src_name, NULL, NULL);
    if (ret < 0) {
        cc_log(NULL, AV_LOG_ERROR, "Can't open file %s.\n", src_name);
        return -1;
    }
    cc_log(NULL, AV_LOG_INFO, "Success open input_file %s.\n", src_name);
    // 查找音视频文件中的流信息
    ret = avformat_find_stream_info(in_fmt_ctx, NULL);
    if (ret < 0) {
        cc_log(NULL, AV_LOG_ERROR, "Can't find stream information.\n");
        return -1;
    }
    AVStream *src_video = NULL;
    // 找到视频流的索引
    int video_index = av_find_best_stream(in_fmt_ctx, AVMEDIA_TYPE_VIDEO, -1, -1, NULL, 0);
    if (video_index >= 0) {
        src_video = in_fmt_ctx->streams[video_index];
    }
    AVStream *src_audio = NULL;
    // 找到音频流的索引
    int audio_index = av_find_best_stream(in_fmt_ctx, AVMEDIA_TYPE_AUDIO, -1, -1, NULL, 0);
    if (audio_index >= 0) {
        src_audio = in_fmt_ctx->streams[audio_index];
    }
    
    AVFormatContext *out_fmt_ctx; // 输出文件的封装器实例
    // 分配音视频文件的封装实例
    ret = avformat_alloc_output_context2(&out_fmt_ctx, NULL, NULL, dest_name);
    if (ret < 0) {
        cc_log(NULL, AV_LOG_ERROR, "Can't alloc output_file %s.\n", dest_name);
        return -1;
    }
    // 打开输出流
    ret = avio_open(&out_fmt_ctx->pb, dest_name, AVIO_FLAG_READ_WRITE);
    if (ret < 0) {
        cc_log(NULL, AV_LOG_ERROR, "Can't open output_file %s.\n", dest_name);
        return -1;
    }
    cc_log(NULL, AV_LOG_INFO, "Success open output_file %s.\n", dest_name);
    
    AVCodecParameters *excodecpar = (AVCodecParameters *)malloc(sizeof(src_video->codecpar));
    AVStream *dest_video = avformat_new_stream(out_fmt_ctx, NULL); // 创建数据流
    dest_video->codecpar = excodecpar;

    if (video_index >= 0) { // 源文件有视频流，就给目标文件创建视频流
        // 把源文件的视频参数原样复制过来
        avcodec_parameters_copy(dest_video->codecpar, src_video->codecpar);
        dest_video->time_base = src_video->time_base;
        dest_video->codecpar->codec_tag = 0;
    }
    
    if (audio_index >= 0) { // 源文件有音频流，就给目标文件创建音频流
        // 把源文件的音频参数原样复制过来
        avcodec_parameters_copy(dest_video->codecpar, src_audio->codecpar);
        dest_video->codecpar->codec_tag = 0;
    }
    ret = avformat_write_header(out_fmt_ctx, NULL); // 写文件头
    if (ret < 0) {
        cc_log(NULL, AV_LOG_ERROR, "write file_header occur error %d.\n", ret);
        return -1;
    }
    cc_log(NULL, AV_LOG_INFO, "Success write file_header.\n");
    
    AVPacket *packet = av_packet_alloc(); // 分配一个数据包
    while (av_read_frame(in_fmt_ctx, packet) >= 0) { // 轮询数据包
        // 有的文件视频流没在第一路，需要调整到第一路，因为目标的视频流默认第一路
        if (packet->stream_index == video_index) { // 视频包
            packet->stream_index = 0;
            ret = av_write_frame(out_fmt_ctx, packet); // 往文件写入一个数据包
        } else { // 音频包
            packet->stream_index = 1;
            ret = av_write_frame(out_fmt_ctx, packet); // 往文件写入一个数据包
        }
        if (ret < 0) {
            cc_log(NULL, AV_LOG_ERROR, "write frame occur error %d.\n", ret);
            break;
        }
        av_packet_unref(packet); // 清除数据包
    }
    av_write_trailer(out_fmt_ctx); // 写文件尾
    cc_log(NULL, AV_LOG_INFO, "Success copy file.\n");
    
    av_packet_free(&packet); // 释放数据包资源
    avio_close(out_fmt_ctx->pb); // 关闭输出流
    avformat_free_context(out_fmt_ctx); // 释放封装器的实例
    avformat_close_input(&in_fmt_ctx); // 关闭音视频文件
    return 0;
}

int c_fps(const char *file_name, const char *out_file_name) {
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
    cc_log(NULL, AV_LOG_INFO, "duration=%d\n", fmt_ctx->duration); // 持续时间，单位微秒
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
        // 查找视频解码器
        AVCodec *video_codec = (AVCodec*) avcodec_find_decoder(video_codec_id);
        if (!video_codec) {
            cc_log(NULL, AV_LOG_ERROR, "video_codec not found\n");
            return -1;
        }
        cc_log(NULL, AV_LOG_INFO, "video_codec name=%s\n", video_codec->name);
        AVCodecParameters *video_codecpar = video_stream->codecpar;
        // 计算帧率，每秒有几个视频帧
        int fps = video_stream->r_frame_rate.num/video_stream->r_frame_rate.den;
        //int fps = av_q2d(video_stream->r_frame_rate);
        cc_log(NULL, AV_LOG_INFO, "video_codecpar bit_rate=%d\n", video_codecpar->bit_rate);
        cc_log(NULL, AV_LOG_INFO, "video_codecpar width=%d\n", video_codecpar->width);
        cc_log(NULL, AV_LOG_INFO, "video_codecpar height=%d\n", video_codecpar->height);
        cc_log(NULL, AV_LOG_INFO, "video_codecpar fps=%d\n", fps);
        int per_video = 1000 / fps; // 计算每个视频帧的持续时间
        cc_log(NULL, AV_LOG_INFO, "one video frame's duration is %dms\n", per_video);
    }
    // 找到音频流的索引
    int audio_index = av_find_best_stream(fmt_ctx, AVMEDIA_TYPE_AUDIO, -1, -1, NULL, 0);
    cc_log(NULL, AV_LOG_INFO, "audio_index=%d\n", audio_index);
    if (audio_index >= 0) {
        AVStream *audio_stream = fmt_ctx->streams[audio_index];
        enum AVCodecID audio_codec_id = audio_stream->codecpar->codec_id;
        // 查找音频解码器
        AVCodec *audio_codec = (AVCodec*) avcodec_find_decoder(audio_codec_id);
        if (!audio_codec) {
            cc_log(NULL, AV_LOG_ERROR, "audio_codec not found\n");
            return -1;
        }
        cc_log(NULL, AV_LOG_INFO, "audio_codec name=%s\n", audio_codec->name);
        AVCodecParameters *audio_codecpar = audio_stream->codecpar;
        cc_log(NULL, AV_LOG_INFO, "audio_codecpar bit_rate=%d\n", audio_codecpar->bit_rate);
        cc_log(NULL, AV_LOG_INFO, "audio_codecpar frame_size=%d\n", audio_codecpar->frame_size);
        cc_log(NULL, AV_LOG_INFO, "audio_codecpar sample_rate=%d\n", audio_codecpar->sample_rate);
        cc_log(NULL, AV_LOG_INFO, "audio_codecpar nb_channels=%d\n", audio_codecpar->ch_layout.nb_channels);
        // 计算音频帧的持续时间。frame_size为每个音频帧的采样数量，sample_rate为音频帧的采样频率
        int per_audio = 1000 * audio_codecpar->frame_size / audio_codecpar->sample_rate;
        cc_log(NULL, AV_LOG_INFO, "one audio frame's duration is %dms\n", per_audio);
    }
    avformat_close_input(&fmt_ctx); // 关闭音视频文件
    return 0;
}


int chapter_3(const char *file_name, const char *out_file_name) {
    cc_log(NULL, AV_LOG_INFO, "-------------copy-------------");
//    c_copy(file_name, out_file_name);
    cc_log(NULL, AV_LOG_INFO, "-------------fps-------------");
    c_fps(file_name, out_file_name);
    return 0;
}
