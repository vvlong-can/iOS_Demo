//
//  CCAudio.h
//  CCFC
//
//  Created by xichen on 11-12-18.
//  Copyright 2011 ccteam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface CCAudio : NSObject 
{
 
}

+ (int)playSound:(NSString *)soundFullPath;
+ (void)playSystemSound:(uint)sysSoundId;
+ (void)playSystemKeyboardClick;

// get current route of the play or record route, eg, headphone, speaker, and so on
+ (NSString *)getCurrentRoute;

@end


// 歌曲的播放状态
typedef enum _CCAudioPlayerPlayingStatus
{
	CC_AP_PLAYING_STATUS_INITING,
	CC_AP_PLAYING_STATUS_INIT_OK,
	CC_AP_PLAYING_STATUS_PLAYING,
	CC_AP_PLAYING_STATUS_PAUSED,
	CC_AP_PLAYING_STATUS_STOPPED,					
	CC_AP_PLAYING_STATUS_UNKOWN,
	
	CC_AP_SONG_STATUS_MAX
}CCAudioPlayerPlayingStatus;


@class CCLocalAudioPlayer;


#define	kNumberBuffers		3

// a player for playing local file
@interface CCLocalAudioPlayer : NSObject 
{	
	NSString							*_path;
	
@private
	AudioQueueRef						_queue;
	AudioFileID							_audioFile;
	AudioStreamBasicDescription			_dataFormat;
	UInt32								_numPacketsToRead;
	AudioQueueBufferRef					_buffers[kNumberBuffers];
	SInt64								_currentPacket;
	float								_volume;
	CCAudioPlayerPlayingStatus			_playStatus;
	
@public
	UInt32								_isRunning;
}

@property (nonatomic, copy)		NSString							*path;
@property (nonatomic, assign)	UInt32								numPacketsToRead;
@property (nonatomic, assign)	AudioFileID							audioFile;
@property (nonatomic, assign)	SInt64								currentPacket;
@property (nonatomic, assign)	UInt32								isRunning;

- (id)initWithPath:(NSString *)path;
- (void)dealloc;

//播放控制
- (OSStatus)play;
- (OSStatus)pause;
- (OSStatus)resume;
- (OSStatus)stop;

//音量控制
- (float)getVolume;
- (OSStatus)setVolume:(float)newVolume;

- (int)getDuration;					// 歌曲总时长,以秒为单位
- (int)getCurrentPlayTime;			// 歌曲当前播放的时间

- (BOOL)isPlaying;								// 返回是否处于播放状态
- (CCAudioPlayerPlayingStatus)getPlayStatus;	// 返回播放状态


@end


// it doesn't support for amr recording
@interface CCRecorder : NSObject 
{	
	NSString							*_path;
	
@private
	AudioQueueRef						_queue;
	AudioFileID							_recordFile;
	AudioStreamBasicDescription			_mRecordFormat;
	AudioQueueBufferRef					_buffers[kNumberBuffers];
	SInt64								_mRecordPacket;
	
@public
	BOOL								_isRunning;
}

@property (nonatomic, copy)		NSString							*path;

- (id)initWithPath:(NSString *)path;
- (void)dealloc;

- (void)setupCommonAudioFormat:(UInt32)formatID;
- (void)setRecordToPCM;

- (OSStatus)start;
- (void)stop;

- (AudioFileID)getRecordFile;
- (SInt64)getRecordPacket;

@end



