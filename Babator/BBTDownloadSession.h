//
//  BBTDownloadSession.h
//  Babator
//
//  Created by Andrey Kulinskiy on 7/1/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BBTFileDownloadInfo;
@protocol BBTDownloadSessionDelegate;

@interface BBTDownloadSession : NSObject

@property (nonatomic, weak) id <BBTDownloadSessionDelegate> delegate;
@property (nonatomic, readonly) BBTFileDownloadInfo* fileInfo;

- (id)initWithFileDownloadInfo:(BBTFileDownloadInfo*)fileDownloadInfo fullCaching:(BOOL)fullCaching;
- (void)fullCachingVideo;
- (void)removeData;

@end

@protocol BBTDownloadSessionDelegate <NSObject>

- (void)readyToPlayDownloadSession:(BBTDownloadSession*)downloadSession size:(unsigned long)size;

@end
