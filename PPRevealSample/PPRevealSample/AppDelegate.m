//
//  AppDelegate.m
//  PPRevealSample
//
//  Created by Marian Paul on 20/08/2015.
//  Copyright (c) 2015 Wasappli. All rights reserved.
//

#import "AppDelegate.h"
#import <PPRevealSideViewController/PPRevealSideViewController.h>
#import <WAAppRouting/WAAppRouting.h>

#import "WALeftMenuViewController.h"
#import "WAList1ViewController.h"
#import "WAList1DetailViewController.h"
#import "WAList1DetailExtraViewController.h"
#import "WAList2ViewController.h"
#import "WAList2DetailViewController.h"
#import "WAModalViewController.h"

@interface AppDelegate ()
@property (nonatomic, strong) WAAppRouter *router;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Init the stack
    WAList1ViewController *list1                         = [[WAList1ViewController alloc] init];
    UINavigationController *list1NavigationController    = [[UINavigationController alloc] initWithRootViewController:list1];
    PPRevealSideViewController *revealSideViewController = [[PPRevealSideViewController alloc] initWithRootViewController:list1NavigationController];
    
    WALeftMenuViewController *leftMenu = [[WALeftMenuViewController alloc] init];
    [revealSideViewController preloadViewController:leftMenu forSide:PPRevealSideDirectionLeft];
    
    // Important things to notice
    // When you are dealing with containers which are supposed to allocate the navigation controller on the fly, you should pass the presenting controller as the container and implement the protocol `WAAppRoutingContainerPresentationProtocol` to return a correct navigation controller
    
    // Init the router
    // Allocate the default route matcher
    WAAppRouteMatcher *routeMatcher = [[WAAppRouteMatcher alloc] init];
    
    // Create the Registrar
    WAAppRouteRegistrar *registrar = [[WAAppRouteRegistrar alloc] initWithRouteMatcher:routeMatcher];
    
    // Create the entities
    WAAppRouteEntity *list1Entity = [[WAAppRouteEntity alloc] initWithName:@"list1"
                                                                      path:@"list1"
                                                     sourceControllerClass:nil
                                                     targetControllerClass:[WAList1ViewController class]
                                                      presentingController:revealSideViewController
                                                  prefersModalPresentation:NO
                                                  defaultParametersBuilder:nil
                                                         allowedParameters:nil];
    
    WAAppRouteEntity *list1DetailEntity = [[WAAppRouteEntity alloc] initWithName:@"listDetail1"
                                                                            path:@"list1/:itemID"
                                                           sourceControllerClass:[WAList1ViewController class]
                                                           targetControllerClass:[WAList1DetailViewController class]
                                                            presentingController:revealSideViewController
                                                        prefersModalPresentation:NO
                                                        defaultParametersBuilder:nil
                                                               allowedParameters:nil];
    
    WAAppRouteEntity *list1DetailExtraEntity = [[WAAppRouteEntity alloc] initWithName:@"listDetailExtra1"
                                                                                 path:@"list1/:itemID/extra"
                                                                sourceControllerClass:[WAList1DetailViewController class]
                                                                targetControllerClass:[WAList1DetailExtraViewController class]
                                                                 presentingController:revealSideViewController
                                                             prefersModalPresentation:NO
                                                             defaultParametersBuilder:nil
                                                                    allowedParameters:nil];
    
    WAAppRouteEntity *list2Entity = [[WAAppRouteEntity alloc] initWithName:@"list2"
                                                                      path:@"list2"
                                                     sourceControllerClass:nil
                                                     targetControllerClass:[WAList2ViewController class]
                                                      presentingController:revealSideViewController
                                                  prefersModalPresentation:NO
                                                  defaultParametersBuilder:nil
                                                         allowedParameters:nil];
    
    WAAppRouteEntity *list2DetailEntity = [[WAAppRouteEntity alloc] initWithName:@"listDetail2"
                                                                            path:@"list2/:itemID"
                                                           sourceControllerClass:[WAList2ViewController class]
                                                           targetControllerClass:[WAList2DetailViewController class]
                                                            presentingController:revealSideViewController
                                                        prefersModalPresentation:NO
                                                        defaultParametersBuilder:nil
                                                               allowedParameters:nil];
    
    WAAppRouteEntity *modalEntity = [[WAAppRouteEntity alloc] initWithName:@"modal"
                                                                      path:@"modal"
                                                     sourceControllerClass:nil
                                                     targetControllerClass:[WAModalViewController class]
                                                      presentingController:nil
                                                  prefersModalPresentation:YES
                                                  defaultParametersBuilder:nil
                                                         allowedParameters:nil];
    
    WAAppRouteEntity *leftMenuEntity = [[WAAppRouteEntity alloc] initWithName:@"leftMenu"
                                                                         path:@"left"
                                                        sourceControllerClass:nil
                                                        targetControllerClass:[WALeftMenuViewController class]
                                                         presentingController:revealSideViewController
                                                     prefersModalPresentation:NO
                                                     defaultParametersBuilder:nil
                                                            allowedParameters:nil];
    
    // Register the entities
    [registrar registerAppRouteEntity:list1Entity];
    [registrar registerAppRouteEntity:list1DetailEntity];
    [registrar registerAppRouteEntity:list1DetailExtraEntity];
    
    [registrar registerAppRouteEntity:list2Entity];
    [registrar registerAppRouteEntity:list2DetailEntity];
    
    [registrar registerAppRouteEntity:modalEntity];
    
    [registrar registerAppRouteEntity:leftMenuEntity];

    // Create the route handler
    WAAppRouteHandler *routeHandler = [[WAAppRouteHandler alloc] initWithRouteRegistrar:registrar];
    
    // Create the router
    self.router = [[WAAppRouter alloc] initWithRegistrar:registrar
                                            routeHandler:routeHandler];

    
    self.window.rootViewController = revealSideViewController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)URL sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    NSLog(@"openURL: %@", URL);
    BOOL handleUrl = NO;

    if ([URL.scheme isEqualToString:@"pprevealexample"]) {
        handleUrl = [self.router handleURL:URL];
    }
    
    if (!handleUrl && ([URL.scheme isEqualToString:@"pprevealexample"])) {
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
