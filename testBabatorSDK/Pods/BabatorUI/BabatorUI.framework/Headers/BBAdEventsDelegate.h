//
//  BBAdEventsDelegate.h
//  BabatorUI
//
//  Created by Nissim Pardo on 07/11/2016.
//  Copyright © 2016 babatordemo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BBAdEvent) {
    BBAdEventLoaded,
    BBAdEventStart,
    BBAdEventAdEnded,
    BBAdEventAllAdsCompleted
};

@protocol BBAdEventsDelegate <NSObject>
- (void)triggerBBAdEvent:(BBAdEvent)adEvent ad:(id)ad;
@end
