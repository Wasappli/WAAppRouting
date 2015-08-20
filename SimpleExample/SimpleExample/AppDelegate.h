//
//  AppDelegate.h
//  SimpleExample
//
//  Created by Marian Paul on 20/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)goTo:(NSString *)route, ...;

@end

