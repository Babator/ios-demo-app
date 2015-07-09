//
//  BBTFileDownloadInfo.h
//  Babator
//
//  Created by Andrey Kulinskiy on 7/1/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBTFileDownloadInfo : NSObject

@property (nonatomic, assign) NSInteger videoID;
@property (nonatomic, strong) NSString *pathToFile;
@property (nonatomic, assign) NSInteger durationSec;
@property (nonatomic, strong) NSOutputStream* outputStream;
@property (nonatomic, strong) NSString *downloadSource;
@property (nonatomic, strong) NSURLSessionDataTask * dataTask;
@property (nonatomic, assign) BOOL isDownloading;
@property (nonatomic, assign) BOOL downloadComplete;
@property (nonatomic, assign) unsigned long taskIdentifier;

- (id)initWithPathToFile:(NSString *)pathToFile downloadSource:(NSString *)source durationSec:(NSInteger)durationSec;

@end
