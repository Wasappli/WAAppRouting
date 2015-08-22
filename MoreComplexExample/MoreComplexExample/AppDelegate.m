//
//  AppDelegate.m
//  MoreComplexExample
//
//  Created by Marian Paul on 19/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "AppDelegate.h"

#import <WAAppRouting/WAAppRouting.h>

#import "WAList1ViewController.h"
#import "WAList2ViewController.h"

#import <RZNotificationView/RZNotificationView.h>

@interface AppDelegate ()
@property (nonatomic, strong) WAAppRouter *router;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    UITabBarItem *list1Item = [[UITabBarItem alloc] initWithTitle:@"List 1" image:nil tag:0];
    UITabBarItem *list2Item = [[UITabBarItem alloc] initWithTitle:@"List 2" image:nil tag:1];

    UINavigationController *navigationControllerList1 = [[UINavigationController alloc] init];
    navigationControllerList1.tabBarItem = list1Item;
    
    UINavigationController *navigationControllerList2 = [[UINavigationController alloc] init];
    navigationControllerList2.tabBarItem = list2Item;

    // Create the default router
    self.router = [WAAppRouter defaultRouter];

    // Register the first subpath
    [self.router.registrar registerAppRoutePath:@"list1{WAList1ViewController}/:itemID{WAList1DetailViewController}/extra{WAList1DetailExtraViewController}/subpath1{WAList1Subpath1DetailController}"
                           presentingController:navigationControllerList1];
    
    // Register the second subpath
    [self.router.registrar registerAppRoutePath:@"list1{WAList1ViewController}/:itemID{WAList1DetailViewController}/extra{WAList1DetailExtraViewController}/subpath2{WAList1Subpath2DetailController}"
                           presentingController:navigationControllerList1];
    
    // Or you could use this notation
//    WAAppRouteEntity *routeEntity = [WAAppRouteEntity routeEntityWithName:@"subpath2"
//                                                                     path:@"list1/:itemID/extra/subpath2"
//                                                    sourceControllerClass:NSClassFromString(@"WAList1DetailExtraViewController")
//                                                    targetControllerClass:NSClassFromString(@"WAList1Subpath2DetailController")
//                                                     presentingController:navigationControllerList1
//                                                 prefersModalPresentation:NO
//                                                 defaultParametersBuilder:nil
//                                                        allowedParameters:nil];
//    [self.router.registrar registerAppRouteEntity:routeEntity];
    
    // Register tab bar item 2
    [self.router.registrar registerAppRoutePath:@"list2{WAList2ViewController}/:itemID{WAList2DetailViewController}/modal{WAModalViewController}!"
                           presentingController:navigationControllerList2];
    
    // Register a modal you can trigger anytime
    [self.router.registrar registerAppRoutePath:@"modal{WAModalViewController}!"
                           presentingController:nil];
    
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
                                            forRoute:@"list1/*"];
    
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
    
    // Set default controllers
    [navigationControllerList1 setViewControllers:@[[WAList1ViewController new]]];
    [navigationControllerList2 setViewControllers:@[[WAList2ViewController new]]];

    [tabBarController setViewControllers:@[navigationControllerList1, navigationControllerList2]];
    
    self.window.rootViewController = tabBarController;
    
    [self.window makeKeyAndVisible];
    
    [self goTo:@"morecomplexexample://list1"];

//    [self goTo:@"morecomplexexample://list2"];
//    [self goTo:@"morecomplexexample://list1/3/extra"];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)URL sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"openURL: %@", URL);
    BOOL handleUrl = NO;
    
    if ([URL.scheme isEqualToString:@"morecomplexexample"]) {
        handleUrl = [self.router handleURL:URL];
    }
    
    if (!handleUrl && ([URL.scheme isEqualToString:@"morecomplexexample"])) {
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

