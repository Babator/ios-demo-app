//
//  AKPlayerView.h
//  Babator
//
//  Created by Andrey Kulinskiy on 6/3/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVPlayer;

@interface AKPlayerView : UIView

@property (nonatomic, strong) AVPlayer* player;
@property (nonatomic, readonly) BOOL isReadyForDisplay;

@end
