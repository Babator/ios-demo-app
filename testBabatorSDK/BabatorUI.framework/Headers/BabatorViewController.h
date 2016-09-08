//
//  BabatorViewController.h
//  BabatorUI
//
//  Created by Nissim Pardo on 06/11/2015.
//  Copyright © 2015 babator. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BabatorProtocols.h"


@class BabatorViewController;
@protocol BabatorViewControllerDelegate <NSObject>

- (void)controller:(BabatorViewController *)controller didSelectVideo:(id<BBVideoParams>)videoParams;
- (void)didSelectDone:(BabatorViewController *)contoller;
@end

@interface BabatorViewController : NSObject
- (instancetype)initWithAPIKey:(NSString *)apiKey;
- (void)setPlayer:(id)player pageId:(NSString *)pageId;
- (void)removeBabatorRecommendations;

@property (nonatomic, weak) id<BabatorViewControllerDelegate> delegate;
@property (nonatomic) BabatorRecommendationType type;
@property (nonatomic) NSInteger suggestionsSize;
/// Disables Suggestions Bottom View if Set to YES
@property (nonatomic) BOOL disableSuggestionsBottomView;
@property (nonatomic) BOOL shouldSendImpression;

@end
