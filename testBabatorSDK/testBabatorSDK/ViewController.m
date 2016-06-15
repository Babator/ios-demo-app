//
//  ViewController.m
//  testBabatorSDK
//
//  Created by Eliza Sapir on 16/05/2016.
//  Copyright © 2016 Babator. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MPMoviePlayerViewController.h>
#import <MediaPlayer/MPMoviePlayerController.h>

#import <BabatorUI/BabatorUI.h>

@interface ViewController () <BabatorViewControllerDelegate>

@property (nonatomic,strong) MPMoviePlayerViewController *mpPlayer;
@property (nonatomic, strong) BabatorViewController *babtorViewController;
@property (nonatomic) CGRect playerRect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _mpPlayer = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:@"http://distribution.bbb3d.renderfarming.net/video/mp4/bbb_sunflower_1080p_30fps_normal.mp4"]];
    _mpPlayer.moviePlayer.shouldAutoplay = YES;
    _mpPlayer.moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
    [self addChildViewController:self.mpPlayer];
    CGSize screen = self.view.frame.size;
    _playerRect = self.mpPlayer.view.frame = (CGRect){0, 64, screen.width, (screen.width / 16) * 9};
    [self.view addSubview:_mpPlayer.view];
    _babtorViewController = [[BabatorViewController alloc] initWithAPIKey:@"d035223d-8bba-40d2-bb13-5a22298250c6"];
    _babtorViewController.suggestionsSize = 10;
    [_babtorViewController addPlayer:self.mpPlayer.moviePlayer];
    _babtorViewController.delegate = self;
    [_babtorViewController loadBabatorRecommendationsInto:self];
    //CGFloat listY = self.mpPlayer.view.frame.size.height + self.mpPlayer.view.frame.origin.y;
    //CGFloat listHeight = screen.height - listY;
    //[self.view addSubview:_babtorViewController.view];
   // _babtorViewController.view.frame = (CGRect){0, listY, screen.width, listHeight};
}

- (void)viewWillDisappear:(BOOL)animated {
//    [_babtorViewController removeFromParentViewController];
    _babtorViewController = nil;
    [_mpPlayer.moviePlayer stop];
    [_mpPlayer removeFromParentViewController];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    _mpPlayer = nil;
    NSLog(@"dealloc");
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        if (size.width < size.height) {
            _mpPlayer.view.frame = _playerRect;
   //         _babtorViewController.view.hidden = NO;
        } else {
    //        _babtorViewController.view.hidden = YES;
            _mpPlayer.view.frame = (CGRect){CGPointZero, size};
        }
    } completion:nil];
}

#pragma mark BabatorViewControllerDelegate
- (void)controller:(BabatorViewController *)controller didSelectVideo:(id<BBVideoParams>)videoParams {
    [self.mpPlayer.moviePlayer stop];
    [self.mpPlayer.moviePlayer setContentURL:videoParams.url];
    [self.mpPlayer.moviePlayer play];
}

@end
