//
//  AppDelegate.m
//  SimpleDemo
//
//  Created by Marian Paul on 18/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "AppDelegate.h"

#import <WAAppRouting/WAAppRouting.h>

#import "WAListViewController.h"
#import "WAListDetailViewController.h"
#import "WAListDetailExtraViewController.h"

#import <RZNotificationView/RZNotificationView.h>

@interface AppDelegate ()
@property (nonatomic, strong) WAAppRouter *router;
@end

@implementation AppDelegate

// You can open the app using simpleexample://list

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UINavigationController *navigationController = [[UINavigationController alloc] init];
    
    // Create the default router
    self.router = [WAAppRouter defaultRouterWithRootViewController:navigationController];
    
// Create the entities
WAAppRouteEntity *list1Entity = [WAAppRouteEntity routeEntityWithName:@"list"
                                                                 path:@"list"
                                                sourceControllerClass:nil
                                                targetControllerClass:[WAListViewController class]
                                                 presentingController:navigationController
                                             prefersModalPresentation:NO
                                             defaultParametersBuilder:nil
                                                    allowedParameters:nil];

WAAppRouteEntity *list1DetailEntity = [WAAppRouteEntity routeEntityWithName:@"listDetail"
                                                                       path:@"list/:itemID"
                                                      sourceControllerClass:[WAListViewController class]
                                                      targetControllerClass:[WAListDetailViewController class]
                                                       presentingController:navigationController
                                                   prefersModalPresentation:NO
                                                   defaultParametersBuilder:^id<WAAppRouterParametersProtocol> {
                                                       
                                                       NSMutableDictionary *defaultParameters = [NSMutableDictionary new];
                                                       defaultParameters[@"defaultParam"]  = @1;
                                                       defaultParameters[@"defaultParam2"] = @"Default parameter 2";
                                                       return defaultParameters;
                                                   }
                                                          allowedParameters:nil];
    
    WAAppRouteEntity *list1DetailExtraEntity = [WAAppRouteEntity routeEntityWithName:@"listDetailExtra"
                                                                                path:@"list/:itemID/extra"
                                                               sourceControllerClass:[WAListDetailViewController class]
                                                               targetControllerClass:[WAListDetailExtraViewController class]
                                                                presentingController:navigationController
                                                            prefersModalPresentation:NO
                                                            defaultParametersBuilder:nil
                                                                   allowedParameters:nil];
    
    // Register the entities
    [self.router.registrar registerAppRouteEntity:list1Entity];
    [self.router.registrar registerAppRouteEntity:list1DetailEntity];
    [self.router.registrar registerAppRouteEntity:list1DetailExtraEntity];
    
    // Register some blocks
    [self.router.registrar registerBlockRouteHandler:^(WAAppLink *appLink) {
        [RZNotificationView showNotificationOn:RZNotificationContextAboveStatusBar
                                       message:[NSString stringWithFormat:@"You are dealing with item ID %@", appLink[@"itemID"]]
                                          icon:RZNotificationIconInfo
                                        anchor:RZNotificationAnchorNone
                                      position:RZNotificationPositionTop
                                         color:RZNotificationColorYellow
                                    assetColor:RZNotificationContentColorDark
                                     textColor:RZNotificationContentColorDark
                                withCompletion:^(BOOL touched) {
                                    
                                }];
    }
                                            forRoute:@"list/*"];
    
    [self.router.routeHandler setShouldHandleAppLinkBlock:^BOOL(WAAppRouteEntity *entity) {
        // Could return NO if not logged in for example
        return YES;
    }];
    
    [self.router.routeHandler setControllerPreConfigurationBlock:^(UIViewController *controller, WAAppRouteEntity *routeEntity, WAAppLink *appLink) {
        if ([controller isKindOfClass:[WABaseViewController class]]) {
            // You could set here some entities like an image cache
            ((WABaseViewController *)controller).commonObject = @"Common object from global routing";
        }
    }];
    
    self.window.rootViewController = navigationController;
    
    [self.window makeKeyAndVisible];
    
    [self goTo:@"simpleexample://list"];
    //    [self goTo:@"simpleexample://list/3/extra"];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)URL sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"openURL: %@", URL);
    BOOL handleUrl = NO;
    
    if ([URL.scheme isEqualToString:@"simpleexample"]) {
        handleUrl = [self.router handleURL:URL];
    }
    
    if (!handleUrl && ([URL.scheme isEqualToString:@"simpleexample"])) {
        NSLog(@"Well, this one is not handled, consider displaying a 404");
    }
    
    return handleUrl;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

# pragma Mark - URL Handling

- (void)goTo:(NSString *)route, ... {
    va_list args;
    va_start(args, route);
    NSString *finalRoute = [[NSString alloc] initWithFormat:route arguments:args];
    va_end(args);
    
    [self application:(UIApplication *)self openURL:[NSURL URLWithString:finalRoute] sourceApplication:nil annotation:nil];
}

@end

