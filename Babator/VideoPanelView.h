//
//  VideoPanelView.h
//  Babator
//
//  Created by Andrey Kulinskiy on 6/4/15.
//  Copyright (c) 2015 Andrey Kulinskiy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VideoPanelViewDelegate;

@interface VideoPanelView : UIView

@property (nonatomic, weak) id<VideoPanelViewDelegate> delegate;
@property (nonatomic, assign) BOOL isPlay;
@property (nonatomic, assign) float sliderValue;
@property (nonatomic, strong) UISlider* slider;

- (void)setCurrentTime:(Float64)currentTime duration:(Float64)duration;

@end

@protocol VideoPanelViewDelegate <NSObject>

- (void)clickPlayForVideoPanelView:(VideoPanelView*)videoPanelView;
- (void)clickPauseForVideoPanelView:(VideoPanelView*)videoPanelView;
- (void)clickBackForVideoPanelView:(VideoPanelView*)videoPanelView;
- (void)clickFullScreenForVideoPanelView:(VideoPanelView*)videoPanelView;
- (void)moveSliderForVideoPanelView:(VideoPanelView*)videoPanelView;

@end
