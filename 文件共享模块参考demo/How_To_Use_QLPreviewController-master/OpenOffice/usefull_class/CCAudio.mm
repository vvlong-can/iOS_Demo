//
//  CCAudio.mm
//  CCFC
//
//  Created by xichen on 11-12-18.
//  Copyright 2011 ccteam. All rights reserved.
//

#import "CCAudio.h"
#import <AudioToolbox/AudioToolbox.h>
#import "CCLog.h"

@implementation CCAudio

+ (int)playSound:(NSString *)soundFullPath
{
	SystemSoundID soundId; 
	NSURL *filePath = [NSURL fileURLWithPath:soundFullPath isDirectory:NO];
	
	OSStatus status = AudioServicesCreateSystemSoundID((CFURLRef)filePath, &soundId);
	if(status != 0)
		return status;
	
	AudioServicesPlaySystemSound(soundId);
	return status;
}

+ (void)playSystemSound:(uint)sysSoundId
{
	AudioServicesPlaySystemSound(sysSoundId);
}

+ (void)playSystemKeyboardClick
{
	AudioServicesPlaySystemSound(0x450);
}

// get current route of the play or record route, eg, headphone, speaker, and so on
// eg, it returns @"Speaker", @"Headphone" and so on
+ (NSString *)getCurrentRoute
{
	UInt32 dataSize = sizeof(CFStringRef); 
	CFStringRef currentRoute = NULL;
	AudioSessionInitialize(NULL, NULL, NULL, NULL); 
	AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &dataSize, &currentRoute); 
	
	return (NSString *)currentRoute;
}

@end


void onBufferCallback(void					*inUserData,
					  AudioQueueRef			inAQ,
					  AudioQueueBufferRef	inCompleteAQBuffer)
{
	CCLocalAudioPlayer *player = (CCLocalAudioPlayer *)inUserData;
	
	UInt32 numBytes;
	UInt32 nPackets = player.numPacketsToRead;
	OSStatus status = AudioFileReadPackets(player.audioFile, false, 
										   &numBytes, 
										   inCompleteAQBuffer->mPacketDescriptions, 
										   player.currentPacket, 
										   &nPackets, 
										   inCompleteAQBuffer->mAudioData);
	if (status)
		printf("AudioFileReadPackets failed: %d", (int)status);
	if (nPackets > 0) 
	{
		inCompleteAQBuffer->mAudioDataByteSize = numBytes;		
		inCompleteAQBuffer->mPacketDescriptionCount = nPackets;		
		status = AudioQueueEnqueueBuffer(inAQ, inCompleteAQBuffer, 0, NULL);
		if(status != 0)
		{
			printf("AudioQueueEnqueueBuffer failed: %d", (int)status);
			return;
		}
		player.currentPacket += nPackets;
	} 	
	else 
	{
		status = AudioQueueStop(inAQ, false);
		if(status != 0)
		{
			printf("AudioQueueStop failed: %d", (int)status);
			return;
		}
	}
}

void isRunningProc(void						*inUserData,
				   AudioQueueRef			inAQ,
				   AudioQueuePropertyID		inID)
{
	CCLocalAudioPlayer *player = (CCLocalAudioPlayer *)inUserData;
	UInt32 size = 4;
	OSStatus status = AudioQueueGetProperty(inAQ, 
											kAudioQueueProperty_IsRunning, 
											&player->_isRunning, 
											&size);
	if(status != 0)
	{
		printf("AudioQueueGetProperty failed: %d", (int)status);
		return;
	}
	if (!player.isRunning)
		[[NSNotificationCenter defaultCenter] postNotificationName:@"playbackQueueStopped" object:nil];
}


@implementation CCLocalAudioPlayer

@synthesize path = _path;
@synthesize numPacketsToRead = _numPacketsToRead;
@synthesize audioFile = _audioFile;
@synthesize currentPacket = _currentPacket;
@synthesize isRunning = _isRunning;

- (void)calculateBytesForTime:(AudioStreamBasicDescription *)inDesc 
				maxPacketSize:(UInt32)inMaxPacketSize 
					  seconds:(Float64)inSeconds 
				outBufferSize:(UInt32 *)outBufferSize 
				outNumPackets:(UInt32 *)outNumPackets
{
	static const int maxBufferSize = 0x10000;	//	64K
	static const int minBufferSize = 0x4000;	//	16K
	
	if (inDesc->mFramesPerPacket) 
	{
		Float64 numPacketsForTime = inDesc->mSampleRate / inDesc->mFramesPerPacket * inSeconds;
		*outBufferSize = numPacketsForTime * inMaxPacketSize;
	} else 
	{
		*outBufferSize = maxBufferSize > inMaxPacketSize ? maxBufferSize : inMaxPacketSize;
	}
	
	if (*outBufferSize > maxBufferSize && *outBufferSize > inMaxPacketSize)
		*outBufferSize = maxBufferSize;
	else 
	{
		if (*outBufferSize < minBufferSize)
			*outBufferSize = minBufferSize;
	}
	*outNumPackets = *outBufferSize / inMaxPacketSize;
}


- (id)initWithPath:(NSString *)path
{
	self = [super init];
	if(self)
	{
		self.path = path;
		_playStatus = CC_AP_PLAYING_STATUS_UNKOWN;
	}
	return self;
}

- (void)dealloc
{
	[_path release];
	
	if (_queue)
	{
		AudioQueueDispose(_queue, true);
		_queue = NULL;
	}
	if (_audioFile)
	{		
		AudioFileClose(_audioFile);
		_audioFile = 0;
	}
	
	[super dealloc];
}


//播放控制
- (OSStatus)play
{
	char	*cookie = NULL;
	AudioChannelLayout *acl = NULL;
	BOOL isFormatVBR;
	UInt32 size;
	
	_playStatus = CC_AP_PLAYING_STATUS_INITING;
	
	OSStatus status = AudioFileOpenURL((CFURLRef)[NSURL fileURLWithPath:_path]
					 , kAudioFileReadPermission
					 , 0
					 , &_audioFile);
	if(status != 0)
		goto end;
	
	size = sizeof(_dataFormat);
	status = AudioFileGetProperty(_audioFile, 
						 kAudioFilePropertyDataFormat, &size, &_dataFormat);
	if(status != 0)
		goto end;
	
	status = AudioQueueNewOutput(&_dataFormat, onBufferCallback, self, 
						CFRunLoopGetCurrent(), kCFRunLoopCommonModes, 0, &_queue);
	if(status != 0)
		goto end;
	
	UInt32 bufferByteSize;		
	UInt32 maxPacketSize;
	size = sizeof(maxPacketSize);
	status = AudioFileGetProperty(_audioFile, 
				kAudioFilePropertyPacketSizeUpperBound, &size, &maxPacketSize);
	if(status != 0)
		goto end;
	
	[self calculateBytesForTime:&_dataFormat
				  maxPacketSize:maxPacketSize
						seconds:0.5f
				  outBufferSize:&bufferByteSize
				  outNumPackets:&_numPacketsToRead];

	size = sizeof(UInt32);
	status = AudioFileGetPropertyInfo (_audioFile, kAudioFilePropertyMagicCookieData, &size, NULL);
	
	if (!status && size) 
	{
		cookie = new char [size];
		status = AudioFileGetProperty (_audioFile, kAudioFilePropertyMagicCookieData, &size, cookie);
		if(status != 0)
			goto end;
		status = AudioQueueSetProperty(_queue, kAudioQueueProperty_MagicCookie, cookie, size);
		if(status != 0)
			goto end;
		delete []cookie;
		cookie = NULL;
	}
	
	status = AudioFileGetPropertyInfo(_audioFile, kAudioFilePropertyChannelLayout, &size, NULL);
	if (status != 0 && size > 0) 
	{
		acl = (AudioChannelLayout *)malloc(size);
		status = AudioFileGetProperty(_audioFile, kAudioFilePropertyChannelLayout, &size, acl);
		if(status != 0)
			goto end;
		status = AudioQueueSetProperty(_queue, kAudioQueueProperty_ChannelLayout, acl, size);
		if(status != 0)
			goto end;
		free(acl);
		acl = NULL;
	}
	
	status = AudioQueueAddPropertyListener(_queue, kAudioQueueProperty_IsRunning, 
								  isRunningProc, self);
	if(status != 0)
		goto end;
	
	isFormatVBR = (_dataFormat.mBytesPerPacket == 0 
						|| _dataFormat.mFramesPerPacket == 0);
	for (int i = 0; i < kNumberBuffers; ++i) 
	{
		status = AudioQueueAllocateBufferWithPacketDescriptions(_queue, 
										bufferByteSize, 
										(isFormatVBR ? _numPacketsToRead : 0), 
										&_buffers[i]);
		if(status != 0)
			goto end;
	}	
	
	status = AudioQueueSetParameter(_queue, kAudioQueueParam_Volume, 1.0);
	if(status != 0)
		goto end;
	
	for (int i = 0; i < kNumberBuffers; ++i) 
	{
		onBufferCallback(self, _queue, _buffers[i]);			
	}
	_playStatus = CC_AP_PLAYING_STATUS_INIT_OK;
	
	
	status = AudioQueueStart(_queue, NULL);
	if(status == 0)
		_playStatus = CC_AP_PLAYING_STATUS_PLAYING;
	else
	{
		printf("CCAudio play failed\n");
	}
		
	return status;
	
end:
	printf("CCAudio play failed\n");
	delete []cookie;
	free(acl);
	return status;
}

- (OSStatus)pause
{
	OSStatus status = AudioQueuePause(_queue);
	if (status != 0)
	{
		printf("CCAudio pause failed\n");
	}
	else
	{
		_playStatus = CC_AP_PLAYING_STATUS_PAUSED;
	}
	return status;
}

- (OSStatus)resume
{
	OSStatus status = AudioQueueStart(_queue, NULL);
	if (status != 0)
	{
		printf("CCAudio resume failed\n");
	}
	else
	{
		_playStatus = CC_AP_PLAYING_STATUS_PLAYING;
	}
	return status;
}

- (OSStatus)stop
{
	OSStatus status = AudioQueueStop(_queue, true);
	if (status != 0)
	{
		printf("CCAudio stop failed\n");
	}
	else
	{
		_playStatus = CC_AP_PLAYING_STATUS_STOPPED;
	}
	
	if (_queue)
	{
		AudioQueueDispose(_queue, true);
		_queue = NULL;
	}
	if (_audioFile)
	{		
		AudioFileClose(_audioFile);
		_audioFile = 0;
	}
	
	memset(_buffers, 0, kNumberBuffers * sizeof(AudioQueueBufferRef));
	_numPacketsToRead = 0;
	_currentPacket = 0;
	
	return status;
}

//音量控制
- (float)getVolume
{
	return _volume;
}

- (OSStatus)setVolume:(float)newVolume
{
	OSStatus status = AudioQueueSetParameter(_queue, kAudioQueueParam_Volume, newVolume);	
	if(status != noErr)
	{
		return status;
	}
	_volume = newVolume;
	return noErr;
}

- (int)getDuration		// 歌曲总时长,以秒为单位
{
	NSTimeInterval duration = 0;
	UInt32 size = sizeof(duration);
	
	OSStatus status;
	status = AudioFileGetProperty(_audioFile, 
								  kAudioFilePropertyEstimatedDuration, 
								  &size, 
								  &duration);
	if(status != noErr)
	{
		NSLog(@"****CCAudio getDuration error!");
		return -1;
	}
	return (int)duration;
}

- (int)getCurrentPlayTime			// 歌曲当前播放的时间
{
	int currentTime = -1;
			
	AudioTimeStamp queueTime;
	Boolean discontinuity;
	
	OSStatus status;
	status = AudioQueueGetCurrentTime(_queue, NULL, &queueTime, &discontinuity);
	if (status == noErr)
	{
		double temp = queueTime.mSampleTime / _dataFormat.mSampleRate;
		if (temp < 0.0)
		{
			temp = 0.0;
		}
		
		currentTime = (int)temp;
	}
	return currentTime;
}

- (BOOL)isPlaying								// 返回是否处于播放状态
{
	return _playStatus == CC_AP_PLAYING_STATUS_PLAYING;
}

- (CCAudioPlayerPlayingStatus)getPlayStatus	// 返回播放状态
{
	return _playStatus;
}


@end


@interface CCRecorder(privateApi)

- (void)setRecordPacket:(SInt64)newRecordPacket;
- (BOOL)isRunning;

@end

// CCRecorder

void inputBufferHandler(void *								inUserData,
						AudioQueueRef						inAQ,
						AudioQueueBufferRef					inBuffer,
						const AudioTimeStamp 				*inStartTime,
						UInt32								inNumPackets,
						const AudioStreamPacketDescription	*inPacketDesc)
{
	CCRecorder *recorder = (CCRecorder *)inUserData;
	if (inNumPackets > 0) 
	{
		NSLog(@"CCRecorder inputBufferHandler: inNumPackets:%d", inNumPackets);
		AudioFileWritePackets([recorder getRecordFile], 
							  FALSE, 
							  inBuffer->mAudioDataByteSize,
							  inPacketDesc, 
							  [recorder getRecordPacket], 
							  &inNumPackets, 
							  inBuffer->mAudioData);
		[recorder setRecordPacket:[recorder getRecordPacket] + inNumPackets];
	}
	
	if ([recorder isRunning])
		AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, NULL);
}

@implementation CCRecorder

@synthesize path = _path;

- (id)initWithPath:(NSString *)path
{
	self = [super init];
	if(self)
	{
		self.path = path;
	}
	return self;
}

- (void)dealloc
{
	[_path release];
	
	AudioQueueDispose(_queue, true);
	AudioFileClose(_recordFile);
	
	[super dealloc];
}

- (void)setupCommonAudioFormat:(UInt32)formatID
{
	memset(&_mRecordFormat, 0, sizeof(_mRecordFormat));
	
	UInt32 size = sizeof(_mRecordFormat.mSampleRate);
	AudioSessionGetProperty(	
							kAudioSessionProperty_CurrentHardwareSampleRate,
							&size, 
							&_mRecordFormat.mSampleRate);
		
	size = sizeof(_mRecordFormat.mChannelsPerFrame);
	AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareInputNumberChannels, 
							&size, 
							&_mRecordFormat.mChannelsPerFrame);
	
	_mRecordFormat.mFormatID = formatID;
	if (formatID == kAudioFormatLinearPCM)
	{
		_mRecordFormat.mFormatFlags = kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked;
		_mRecordFormat.mBitsPerChannel = 16;
		_mRecordFormat.mBytesPerPacket = 2;
		_mRecordFormat.mChannelsPerFrame = 1;
		_mRecordFormat.mBytesPerFrame = (_mRecordFormat.mBitsPerChannel / 8) * _mRecordFormat.mChannelsPerFrame;
		_mRecordFormat.mFramesPerPacket = 1;
		_mRecordFormat.mSampleRate = 16000;
		
	}
}

- (void)setRecordToPCM
{
	[self setupCommonAudioFormat:kAudioFormatLinearPCM];
}


- (void)copyEncoderCookieToFile
{
	UInt32 propertySize;	
	OSStatus status = AudioQueueGetPropertySize(_queue, kAudioQueueProperty_MagicCookie, &propertySize);
	
	if (status == noErr && propertySize > 0) 
	{
		Byte *magicCookie = new Byte[propertySize];
		UInt32 magicCookieSize;
		AudioQueueGetProperty(_queue, kAudioQueueProperty_MagicCookie, magicCookie, &propertySize);
		magicCookieSize = propertySize;	
		
		UInt32 willEatTheCookie = false;
		status = AudioFileGetPropertyInfo(_recordFile, kAudioFilePropertyMagicCookieData, NULL, &willEatTheCookie);
		if (status == noErr && willEatTheCookie) 
		{
			status = AudioFileSetProperty(_recordFile, kAudioFilePropertyMagicCookieData, magicCookieSize, magicCookie);
		}
		delete[] magicCookie;
	}
}

- (int)computeRecordBufferSize:(const AudioStreamBasicDescription *)format
					   seconds:(float)seconds
{
	int packets, frames, bytes = 0;

	frames = (int)ceil(seconds * format->mSampleRate);
	
	if (format->mBytesPerFrame > 0)
		bytes = frames * format->mBytesPerFrame;
	else 
	{
		UInt32 maxPacketSize;
		if (format->mBytesPerPacket > 0)
			maxPacketSize = format->mBytesPerPacket;	
		else {
			UInt32 propertySize = sizeof(maxPacketSize);
			OSStatus status = AudioQueueGetProperty(_queue, kAudioQueueProperty_MaximumOutputPacketSize, &maxPacketSize,
												&propertySize);
			if(status != noErr)
				return 0;
		}
		if (format->mFramesPerPacket > 0)
			packets = frames / format->mFramesPerPacket;
		else
			packets = frames;	
		if (packets == 0)		
			packets = 1;
		bytes = packets * maxPacketSize;
	}	
	return bytes;
}


- (OSStatus)start
{
	OSStatus status;
	UInt32 size;
	
	status = AudioQueueNewInput(
						&_mRecordFormat,
						inputBufferHandler,
						self, 
						NULL, 
						NULL,
						0,
						&_queue);
	
	if(status != noErr)
		return status;
	
	_mRecordPacket = 0;
	
	size = sizeof(_mRecordFormat);
	status = AudioQueueGetProperty(_queue, kAudioQueueProperty_StreamDescription,	
										&_mRecordFormat, &size);
	if(status != noErr)
		return status;
	
	status = AudioFileCreateWithURL((CFURLRef)[NSURL fileURLWithPath:_path], 
						   kAudioFileCAFType, 
						   &_mRecordFormat, 
						   kAudioFileFlags_EraseFile,
						   &_recordFile);
	if(status != noErr)
		return status;
	[self copyEncoderCookieToFile];
	
	int bufferByteSize = [self computeRecordBufferSize:&_mRecordFormat seconds:0.5f];
	
	for (int i = 0; i < kNumberBuffers; ++i) 
	{
		status = AudioQueueAllocateBuffer(_queue, bufferByteSize, &_buffers[i]);
		if(status != noErr)
			return status;
		
		status = AudioQueueEnqueueBuffer(_queue, _buffers[i], 0, NULL);
		if(status != noErr)
			return status;
	}
	
	status = AudioQueueStart(_queue, NULL);
	if(status == noErr)
		_isRunning = TRUE;
	
	return status;
}

- (void)stop
{
	AudioQueueStop(_queue, true);
	
	[self copyEncoderCookieToFile];
	
	AudioQueueDispose(_queue, true);
	AudioFileClose(_recordFile);
	
	_isRunning = FALSE;
}

- (BOOL)isRunning
{
	return _isRunning;
}

- (AudioFileID)getRecordFile
{
	return _recordFile;
}
 
- (SInt64)getRecordPacket
{
	return _mRecordPacket;
}

- (void)setRecordPacket:(SInt64)newRecordPacket
{
	_mRecordPacket = newRecordPacket;
}

@end


