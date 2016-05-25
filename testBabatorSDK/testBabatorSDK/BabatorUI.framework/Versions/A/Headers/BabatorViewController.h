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
@optional
- (void)playNextSuggetion:(id<BBVideoParams>)videoParams;
@end

@interface BabatorViewController : UIViewController
- (instancetype)initWithAPIKey:(NSString *)apiKey;
- (void)addPlayer:(id)player;
- (void)playerParentView:(UIView *)view;
- (void)loadBabatorRecommendationsInto:(UIViewController *)parentViewController;

@property (nonatomic, weak) id<BabatorViewControllerDelegate> delegate;
@property (nonatomic) BabatorRecommendationType type;
@property (nonatomic) NSInteger suggestionsSize;
/// Disables Suggestions Bottom View if Set to YES
@property (nonatomic) BOOL disableSuggestionsBottomView;
@end
