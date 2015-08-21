# [![WAAppRouting](https://github.com/Wasappli/WAAppRouting/blob/master/images/WAAppRouting.png?raw=true)](#)

[![Version](https://img.shields.io/cocoapods/v/WAAppRouting.svg?style=flat)](http://cocoapods.org/pods/WAAppRouting)
[![License](https://img.shields.io/cocoapods/l/WAAppRouting.svg?style=flat)](http://cocoapods.org/pods/WAAppRouting)
[![Platform](https://img.shields.io/cocoapods/p/WAAppRouting.svg?style=flat)](http://cocoapods.org/pods/WAAppRouting)

**Developed and Maintained by [Ipodishima](https://github.com/ipodishima) Founder & CTO at [Wasappli Inc](http://wasapp.li).**

So what is this library useful for? Good question. Let's answer by asking an other question. Have you been struggled at some point by the following issues?

- Well, I need to add some shortcuts to some parts of my apps and it seems crappy to manually allocate the path and select the controllers I need.
- I'm tired of using the push view controller method.
- I wish I had some kind of url handling to get to specific parts of my app juste as easily as snapping a finger.
- If it could even handle a controller stack this would juste be awesome.
- I found a library but it's not working with my custom container...
- I found a great library but the route matching is not working with my requirements...

All this points are answered by `WAAppRouting` (and more)

### Table of Contents
1. [The story](#the-story)
2. [Install and use](#install-and-use)
3. [Go deeper](#go-deeper)

#The story
## What motivated me
Let's be honest, there are several routing libraries on Github to handle some of the behaviors described. But none of them fitted all my requirements. So I wrote this library with some things in mind:

- Handle a **stack** of a controller. 

This is not ok to open the app on a hotel detail if there is not even a back button, or if the back button sends me back to where I was before opening the app. I just want the app to be opened so that when I hit back, I'm on the hotels list for the hotel city...

- Do not force you to get this working **with my** route matcher, or **my** route handler. 

If you want to provide your own, you should be able to do it.
This last point is very important to me. I used (and use) too many libraries which are tighten to their technologies. Plus, the more they are dependant of their implementation, the less it is testable.
This is why you'll see many protocols with a default implementation provided.

- iOS 9 is coming (or came when you are reading this). And with iOS 9 comes this great feature called universal links. Well, I wanted something clean to address this new feature.

## Inspiration
Historically, I first used [HHRouter](https://github.com/Huohua/HHRouter) and implemented my own stack controller management. Then, by rewriting code to support iOS 9, I saw that it was just a bunch of lines with no error management, tighten to the controller hierarchy, not much readable, etc.

I decided to drop it and get something more fun. I found [DeepLinkKit](https://github.com/usebutton/DeepLinkKit) and used it until I realized it wasn't fitting my stack requirement.
So I rewrote a custom route handler to deal with it and finally arrived to the conclusion that 80% of deeplink was not used anymore. This is when I decided to drop it and write my own.

So you might recognize some concept of the two libraries especially in the router handler even if the implementation has nothing to do with DeepLinkKit.

# Install and use
## Requirements alongs with the default implementation
- The implementation I provide uses `UINavigationController` to handle the stack and can be used on `UITabBarController` as well.
- The route matching works on `:itemID` and uses `*` as the wildcard character.

## Installation
Use Cocoapods, this is the easiest way to install the router.

Then, well import `#import <WAAppRouting/WAAppRouting.h>` and you are good to go.

You also need to configure a URL scheme (I won't get back to this, there is plenty of documentation out there)

A navigation controller is a good start

```
UINavigationController *navigationController = [[UINavigationController alloc] init];
```
    
You'll need first to allocate a route matcher. You can use the default I wrote or create your own.

```objc
// Create the default router
self.router = [WAAppRouter defaultRouter];
```

This is now the time to create some entities

```objc
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
```

Add the entities to the registrar

```objc
// Register the entities
[self.router.registrar registerAppRouteEntity:list1Entity];
[self.router.registrar registerAppRouteEntity:list1DetailEntity];
```

Add some block handler if needed

```objc
// Register some blocks
[self.router.registrar registerBlockRouteHandler:^(WAAppLink *appLink) {
    // Do something every time we are in list/something
}
                            			forRoute:@"list/*"];
```

Finally set the navigation controller as the root controller

```objc
self.window.rootViewController = navigationController;
```

You can now use it and open the app with 

```objc
[self application:(UIApplication *)self openURL:[NSURL URLWithString:@"appscheme://list"] sourceApplication:nil annotation:nil];
```

Do not forget to use the router!

```objc
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self.router handleURL:url];
}
```

Each controllers you use should implement `WAAppRouterTargetControllerProtocol` (it is a good idea to now to have a base view controller)
So implement this method and voilà

```
- (void)reloadFromAppLinkRefresh {
    // You can do something with self.appLink
    // But more important: with self.appLinkRoutingParameters which has merged route|query|default parameters
    NSString *articleTitle = self.appLinkRoutingParameters[@"article_title"];
}
```

## Samples
Four samples are available

- `SimpleExample`: This is a sample which handle a list, it's detail and an extra. This could be seen as an article lists, its detail and comments.
- `SimpleExampleParameters`: This sample is the same as `SimpleExample` but is using the `WAAppLinkParameters` (the one more thing of this library).
- `MoreComplexExample`: This sample demonstrates how to deal with a tab bar controller.
- `PPRevealSample`: This sample acts as a demonstration that with a little bit of effort, custom container can fit into the routing library?
 
## Documentation
The code is heavily documented, you should find all your answers. Otherwise, open an issue and I'll respond as quickly as possible.

# Go deeper
## Pre configure all controllers with objects.
You might want to pass some values to the controllers when there are allocated.
For example in a project I'm involved to, we have an image cache the controllers needs to display the image. This image cache is allocated by the App delegate (to avoid singletons and get more testable code).
For doing this, you need to add a block implementation to the route handler

```objc
    [routeHandler setControllerPreConfigurationBlock:^(UIViewController *controller, WAAppRouteEntity *routeEntity, WAAppLink *appLink) {
        if ([controller isKindOfClass:[WABaseViewController class]]) {
            ((WABaseViewController *)controller).imageCache = imageCache;
        }
    }];
```

## Forbid specific entities to be shown
You can ask not to handle some routes on runtime by setting this block (for example you might not want to display some controllers if not logged in)

```objc
    [routeHandler setShouldHandleAppLinkBlock:^BOOL(WAAppRouteEntity *entity) {
        // Could return NO if not logged in for example
        return YES;
    }];
```

## Wildcard URL
You can have some wildcard urls like `list/*/extra` meaning that for any value instead of the `*`, the entity or the block would be executed. Avoid using it with entities but rather with block.
An url in form of `list/*` will match both `list/path` and `list/path/extra`

Here is an example of an alert triggered each time we are after `list/`

```objc
[registrar registerBlockRouteHandler:^(WAAppLink *appLink) {
        [RZNotificationView showNotificationOn:RZNotificationContextAboveStatusBar
                                       message:[NSString stringWithFormat:@"You are dealing with item ID %@", appLink[@"articleID"]]
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
```

## Customize router behavior
As said, I hate libraries you cannot customize without forking and diverging from the original source.
That said, you can customize the router in two ways: custom route matcher and custom route handler.

### Custom route matcher
My implementation deals with basic. Meaning that it won't support `key=value1, value2` for the query for example. It is also case sentitive.
If you have your own URL configuration like `list/$itemID` implementing a new route matcher is a good idea!

To start, read `WAAppRouteMatcherProtocol` class. You have two methods you need to implement: `matchesURL: fromPathPattern:` and `parametersFromURL: withPathPattern:`.
As you can see in my implementation, I'm using `WARoutePattern` to match the URL. It's kind of inspired by SocKit (for the naming convention).

Then, you can easily create the router with 

```objc
// Allocate your route matcher
MyRouteMatcher *routeMatcher = [MyRouteMatcher new];

// Create the Registrar
WAAppRouteRegistrar *registrar  = [WAAppRouteRegistrar registrarWithRouteMatcher:routeMatcher];

// Create the route handler
WAAppRouteHandler *routeHandler = [WAAppRouteHandler routeHandlerWithRouteRegistrar:registrar];

// Create the router
WAAppRouter *router = [WAAppRouter routerWithRegistrar:registrar
                                          routeHandler:routeHandler];
```

### Custom route handler
If for example, you don't want to handle a stack, or use something else than a `UINavigationController`, then consider creating your own route handler.
Start by adopting `WAAppRouteHandlerProtocol` protocol. And then read `WAAppRouteHandler` to get inspiration.

## Special configuration consideration
### Custom container controller
You should definitively take a look at the `PPRevealSample` project to get an idea of how to get this working. I'm also here to help if needed.
Basic idea is try to allocate all the navigation controller you need and pass them as the presenting controller. Then, this would behave like the tab bar (see it's category).
If not, then you are in the `PPRevealSideViewController` context where the navigation controller gets allocated in the fly. The idea is to pass the container as the `presentingController` property and implement the `WAAppRoutingContainerPresentationProtocol` protocol (you need the optional method as well).

### Modal with navigation controller
You cannot (yet) present a modal and then push a detail. Like presenting a login view but pushed to the signup controller.

### Reuse controllers at different locations
Because the stack retrieval is implemented as dealing with controller class unicity, you cannot have two or more `WAAppRouteEntity` with the same target class when the source controller class is not nil.
If you need to reuse the controller at differents places, consider creating simple subclasses of a main controller which handles all the behavior.

## The one more thing: avoid having parameters keys hardcoded
###Purpose
There is a one more thing to this library which is `WAAppLinkParameters` class.
The idea behind is to avoid hardcoding the values 
It's behavior is based on an implementation of `WAAppRouterParametersProtocol` protocol. Which means that you can provide your own or subclass `WAAppLinkParameters` which provides default behavior and all protocol methods implementation.
Let's have a look to an example you can find on `SimpleExampleParameters` sample project.

### Example
First, create a subclass

```objc
@interface ArticleAppLinkParameters : WAAppLinkParameters

@property (nonatomic, strong) NSNumber *articleID;
@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, strong) NSNumber *displayType;

@end
```

You can see here three objects which should be mapped to the url keys
You need to override the `mappingKeyProperty` getter

```objc
- (NSDictionary *)mappingKeyProperty {
    return @{
             @"articleID": @"articleID",
             @"article_title": @"articleTitle",
             @"display_type": @"displayType"
             };
}
```

Next step is to go to your base view controller (if you not yet one it is a good idea to start now) and write some code you can customize. For example, you would deal with values exception here like cannot have a reservation date before today.

Here is the default implementation idea you can reproduce in your app

```objc
- (void)configureWithAppLink:(WAAppLink *)appLink defaultParameters:(id<WAAppRouterParametersProtocol>)defaultParameters allowedParameters:(NSArray *)allowedParameters {

    // Grab the parameters from the link
    NSMutableDictionary *rawParameters = [NSMutableDictionary dictionaryWithDictionary:appLink.queryParameters];
    if (appLink.routeParameters) {
        [rawParameters setValuesForKeysWithDictionary:appLink.routeParameters];
    }

    // Erase all previous params and allocate with allowed parameters provided by the entity
    self.routingParameters = [[ArticleAppLinkParameters alloc] initWithAllowedParameters:allowedParameters];
    
    // Merge with the default parameters provided by the entity
    [self.routingParameters mergeWithAppRouterParameters:defaultParameters];
    
    // No set the values from the query itself
    [self.routingParameters mergeWithRawParameters:rawParameters];
    
    // Call reload which is a random method defined for our purpose. This method should be implemented by your subclasses to reload data accordingly
    [self reloadFromAppLink];
}
```

You can now get the value directly

```objc
self.label.text = [NSString stringWithFormat:@"ArticleID: %@", self.routingParameters.articleID];`
```

You can copy the parameters, set values for a future use

```objc
ArticleAppLinkParameters *params = [self.routingParameters copy];
params.articleTitle = [NSString stringWithFormat:@"My super article %ld", (long)indexPath.row];
```

Grab the query with a white list

```objc
NSString *query = [params queryStringWithWhiteList:@[@"articleID", @"articleTitle", @"displayType"];
```

### Advantages
- Update any time the key on URLs without touching your code.
- Avoid regressions when you add new parameters in the URL.
- Easily build queries for moving from a controller to an other.
- Provide defaults values to a controller initialization. All your configuration is done in one place.

### Notes
- Only `NSString` and `NSNumber` parameters are supported at this time (no `NSDate` for example)
- This could seems to be a pain in the ass to implement rather than using directly the parameters. True. Keep in mind I thought about this one in a large progress with a big maintenance and evolutions plan involved. 

#Contributing : Problems, Suggestions, Pull Requests?

Please open a new Issue [here](https://github.com/Wasappli/WAAppRouting/issues) if you run into a problem specific to WAAppRouting.

For new features pull requests are encouraged and greatly appreciated! Please try to maintain consistency with the existing code style. If you're considering taking on significant changes or additions to the project, please ask me before by opening a new Issue to have a chance for a merge.

#That's all folks !

- If your are happy don't hesitate to send me a tweet [@ipodishima](http://twitter.com/ipodishima) !
- Distributed under MIT licence.
