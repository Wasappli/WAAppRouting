//
//  WABaseViewController.h
//  WAAppRouter
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

@import UIKit;
#import <WAAppRouting/WAAppRouting.h>
#import "AppDelegate.h"

@interface WABaseViewController : UIViewController <WAAppRouterTargetControllerProtocol>

@property (nonatomic, strong, readonly) WAAppLink *appLink;
@property (nonatomic, strong) id commonObject;

- (void)reloadFromAppLink;

@end
