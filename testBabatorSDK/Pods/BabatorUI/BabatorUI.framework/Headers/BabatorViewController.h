//
//  BabatorViewController.h
//  BabatorUI
//
//  Created by Nissim Pardo on 06/11/2015.
//  Copyright © 2015 babator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BabatorProtocols.h"
#import "BBSource.h"
#import "AdsManager.h"
#import "Babator.h"

@class BabatorViewController;
@protocol BabatorViewControllerDelegate <NSObject>
@optional
- (void)controller:(BabatorViewController *)controller didSelectVideo:(id<BBVideoParams>)videoParams;
- (void)didSelectDone:(BabatorViewController *)contoller;
- (void)controller:(BabatorViewController *)controller willChangeSource:(id<BBVideoParams>)videoSource;
- (void)controller:(BabatorViewController *)controller didChangeSource:(id<BBVideoParams>)videoSource;
- (void)noRecommendationsForBabatorController:(BabatorViewController *)controller;
@end

@protocol BabatorContentHandler <NSObject>

- (void)controller:(BabatorViewController *)controller didSelectRecommendation:(id<BBVideoParams>)videoParams;
- (void)controller:(BabatorViewController *)controller shouldLoadRecommendation:(id<BBVideoParams>)videoParams;

@end

@interface BabatorViewController : NSObject <AdsManager>
- (instancetype)initWithAPIKey:(NSString *)apiKey;
- (void)setPlayer:(id)player pageId:(NSString *)pageId;
- (void)removeBabatorRecommendations;

@property (nonatomic, weak) id<BabatorViewControllerDelegate> delegate;
@property (nonatomic, weak) id<BabatorContentHandler> contentHandler;
@property (nonatomic) BabatorRecommendationType type;
@property (nonatomic) NSInteger suggestionsSize;
/// Disables Suggestions Bottom View if Set to YES
@property (nonatomic) BOOL disableSuggestionsBottomView;
@property (nonatomic) BOOL shouldSendImpression;

@property (nonatomic, strong) UIView *videoHolder;
@property (nonatomic, strong) Babator *babator;

@end
