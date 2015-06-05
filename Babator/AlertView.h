//
//  AlertView.h
//  mECG
//
//  Created by Andrey Kulinskiy on 7/31/13.
//  Copyright (c) 2013 McKesson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertView : UIAlertView

@property (nonatomic, strong)VoidHandler doneBlock;
@property (nonatomic, strong)VoidHandler cancelBlock;

@end
