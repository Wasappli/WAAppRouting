# [![WAAppRouting](https://github.com/Wasappli/WAAppRouting/blob/master/images/WAAppRouting.png?raw=true)](#)

[![Version](https://img.shields.io/cocoapods/v/WAAppRouting.svg?style=flat)](http://cocoapods.org/pods/WAAppRouting)
[![License](https://img.shields.io/cocoapods/l/WAAppRouting.svg?style=flat)](http://cocoapods.org/pods/WAAppRouting)
[![Platform](https://img.shields.io/cocoapods/p/WAAppRouting.svg?style=flat)](http://cocoapods.org/pods/WAAppRouting)

**Developed and Maintained by [Ipodishima](https://github.com/ipodishima) Founder & CTO at [Wasappli Inc](http://wasapp.li).** (If you need to develop an app, [get in touch](mailto:contact@wasapp.li) with our team!)

So what is this library useful for? Good question. Let's answer by asking an other question. Have you been struggled at some point with the following issues?

- Well, I need to add some shortcuts to some parts of my apps and it seems crappy to manually allocate the path and select the controllers I need.
- I'm tired of using the push view controller method.
- I wish I had some kind of url handling to get to specific parts of my app just as easily as snapping a finger.
- If it could even handle a controller stack this would just be awesome.
- I found a library but it's not working with my custom container...
- I found a great library but the route matching is not working with my requirements...

All this points are answered by `WAAppRouting` (and more)

## Which Uses?
- For all iOS: enable linking in your app. It is always useful to tell your app to go to `home/events/3/register` with some magic involved.
- For iOS 9: supports deeplinks (like [Twitter app](https://itunes.apple.com/us/app/twitter/id333903271?mt=8)). Opening this URL [Me on twitter](http://twitter.com/ipodishima) would be opened directly in the app instead of the website.
- For iOS 9: respond to a [search event](#search). By using [CoreSpotlight](https://developer.apple.com/library/prerelease/ios/documentation/General/Conceptual/AppSearch/index.html#//apple_ref/doc/uid/TP40016308-CH4-SW1), users can go to your app by opening it from a search result like a booking. At this point, you need to consider to `goto://bookings/bookingFromSearchID`. Please take a look at an implementation of routing using a library which automatically index your `CoreData` stack [WACoreDataSpotlight](https://github.com/Wasappli/WACoreDataSpotlight).
- For iOS 9 and more specifically new iPhones 6S and 6+S: respond to [3D Touch](#3d-touch)


## Table of Contents
1. [The story](#the-story)
2. [Install and use](#install-and-use)
3. [Go deeper](#go-deeper)

#The story
## What motivated me
Let's be honest, there are several routing libraries on Github to handle some of the behaviors described. But none of them fit all my requirements. So I wrote this library with some things in mind:

- Handle a **stack** of controllers.

This is not ok to open the app on a hotel detail if there is not even a back button, or if the back button sends me back to where I was before opening the app. I just want the app to be opened so that when I hit back, I'm on the hotels list for the hotel's city...

- Do not force you to get this working **with my** route matcher, or **my** route handler.

If you want to provide your own, you should be able to do it.
This last point is very important to me. I used (and use) too many libraries which are tightly tied to their technologies. Plus, the more they are dependent on their implementation, the less testable.
This is why you'll see many protocols with a default implementation provided.

- iOS 9 is here. And with it comes this great feature called [universal links](https://developer.apple.com/library/prerelease/ios/documentation/General/Conceptual/AppSearch/UniversalLinks.html#//apple_ref/doc/uid/TP40016308-CH12). Well, I wanted something clean to address this new feature.

## Inspiration
Historically, I first used [HHRouter](https://github.com/Huohua/HHRouter) and implemented my own stack controller management. Then, by rewriting code to support iOS 9, I saw that it was a bunch of lines with no error management, tightly coupled to the controller hierarchy, not very readable, etc.

I decided to drop it and get something more fun. I found [DeepLinkKit](https://github.com/usebutton/DeepLinkKit) and used it until I realized it wasn't fitting my stack requirement.
So I rewrote a custom route handler to deal with it and finally arrived to the conclusion that 80% of DeepLinkKit was not used anymore. This is when I decided to drop it and write my own.

So you might recognize some concepts from the two libraries, especially in the router handler, even if the implementation has nothing to do with DeepLinkKit.

# Installation and use
## Requirements alongs with the default implementation
- The implementation I provide uses `UINavigationController` to handle the stack and can be used on `UITabBarController` as well.
- The route matching works on `:itemID` and uses `*` as the wildcard character.

## Installation
### CocoaPods
Use CocoaPods, this is the easiest way to install the router.

`pod 'WAAppRouting'`

If you want to link `WAAppRouting` into an iOS app extension (or a shared framework that is linked to an app extension), you'll need to ensure that the `WA_APP_EXTENSION` flag is set when you compile the framework.  To do so using CocoaPods, add this to your `Podfile`:

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name =~ /WAAppRouting/
      target.build_configurations.each do |config|
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= []
        config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << 'WA_APP_EXTENSION=1'
      end
    end
  end
end
```

Older versions of cocoapods may require you to use `installer.project` instead of `installer.pods_project`, so if you get an error complaining that `pods_project` does not exist, update your cocoapods gem.

### Setup the router: easiest method
Import `#import <WAAppRouting/WAAppRouting.h>` and you are good to start.

You also need to configure a URL scheme (I won't go into detail about this - there is plenty of documentation out there)

A navigation controller is a good start:

```
UINavigationController *navigationController = [[UINavigationController alloc] init];
```

You'll need first to allocate a route matcher. You can use the default I wrote or create your own:

```objc
// Create the default router
self.router = [WAAppRouter defaultRouter];
```

Register you path using the syntax:
- `url_path_component{ClassName}`
- `url_path_component1{ClassName1}/url_path_component2{ClassName2}`

Optionally, you can trigger the modal presentation using `!` character.
For example: `url_path_component{ClassName}/modal{ModalClass}!` would result when calling `appscheme://url_path_component/modal` to the `ModalClass` instance presented modally after placing `ClassName` in the navigation controller stack.

```objc
// Register the path
[self.router.registrar
 registerAppRoutePath:
 @"list{WAListViewController}/:itemID{WAListDetailViewController}/extra{WAListDetailExtraViewController}"
 presentingController:navigationController];
```

Add a block handler if needed

```objc
// Register some blocks
[self.router.registrar registerBlockRouteHandler:^(WAAppLink *appLink) {
    // Do something every time we are in list/something
}
                            			forRoute:@"list/*"];
```

Finally set the navigation controller as the root controller:

```objc
self.window.rootViewController = navigationController;
```

You can now use it and open the app with:

```objc
[self application:(UIApplication *)self openURL:[NSURL URLWithString:@"appscheme://list"] sourceApplication:nil annotation:nil];
```

Don't forget to use the router!

```objc
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [self.router handleURL:url];
}
```

In each controller you use should implement `WAAppRouterTargetControllerProtocol` (it is a good idea to have a base view controller)
So implement this method and voilà:

```
- (void)reloadFromAppLinkRefresh {
    // You can do something with self.appLink
    // But more important: with self.appLinkRoutingParameters which has merged route|query|default parameters
    NSString *articleTitle = self.appLinkRoutingParameters[@"article_title"];
}
```
### Setup the router: more control methods
Start with the easiest method but replace the "create paths" by creating entities entities

```objc
// Create the entities
WAAppRouteEntity *list1Entity =
[WAAppRouteEntity routeEntityWithName:@"list"
                                 path:@"list"
                sourceControllerClass:nil
                targetControllerClass:[WAListViewController class]
                 presentingController:navigationController
             prefersModalPresentation:NO
             defaultParametersBuilder:nil
                    allowedParameters:nil];

WAAppRouteEntity *list1DetailEntity =
[WAAppRouteEntity routeEntityWithName:@"listDetail"
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

## Samples
Four samples are available:

- `SimpleExample`: This is a sample which handle a list, it's detail and an extra. This could be seen as an article lists, its detail and comments.
- `SimpleExampleParameters`: This sample is the same as `SimpleExample` but is using the `WAAppLinkParameters` (the one more thing of this library).
- `MoreComplexExample`: This sample demonstrates how to deal with a tab bar controller + how to handle modals.
- `PPRevealSample`: This sample acts as a demonstration that with a little bit of effort, custom container can fit into the routing library?

## Documentation
The code is heavily documented, you should find all your answers. Otherwise, open an issue and I'll respond as quickly as possible.

# Go deeper
## Pre-configure all controllers with objects.
You might want to pass values to the controllers when they are allocated.
For example in a project I'm involved in, we have an image cache that the controllers needs to display images. This image cache is allocated by the App delegate (to avoid singletons and get more testable code).
For doing this, you need to add a block implementation to the route handler:

```objc
    [routeHandler setControllerPreConfigurationBlock:^(UIViewController *controller, WAAppRouteEntity *routeEntity, WAAppLink *appLink) {
        if ([controller isKindOfClass:[WABaseViewController class]]) {
            ((WABaseViewController *)controller).imageCache = imageCache;
        }
    }];
```

## Forbid specific entities to be shown
You can ask not to handle some routes at runtime by setting this block (for example you might not want to display some controllers if not logged in):

```objc
    [routeHandler setShouldHandleAppLinkBlock:^BOOL(WAAppRouteEntity *entity) {
        // Could return NO if not logged in for example
        return YES;
    }];
```

## Wildcard URL
You can have wildcard urls like `list/*/extra` meaning that for any value instead of the `*`, the entity or the block would be executed. Avoid using it with entities but rather with a block.
A url in form of `list/*` will match both `list/path` and `list/path/extra`

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
My implementation deals with basics. Meaning that it won't support `key=value1, value2` for the query for example. It is also case sensitive.
If you have your own URL configuration like `list/$itemID` implementing a new route matcher is a good idea!

To start, read the `WAAppRouteMatcherProtocol` class. You have two methods you need to implement: `matchesURL: fromPathPattern:` and `parametersFromURL: withPathPattern:`.
As you can see in my implementation, I'm using `WARoutePattern` to match the URL. It's kind of inspired by SocKit (for the naming convention).

Then, you can easily create the router with:

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
If for example, you don't want to handle a stack, or use something other than a `UINavigationController`, then consider creating your own route handler.
Start by adopting `WAAppRouteHandlerProtocol` protocol. And then read `WAAppRouteHandler` to get inspiration.

## iOS 9 support
I still need to run some tests, but the idea is to have a router for the classic url scheme, and another one for universal links.

### 3D Touch
By implementing [3D Touch](https://developer.apple.com/library/ios/documentation/UserExperience/Conceptual/Adopting3DTouchOniPhone/), you can have users opening your app directly on some actions like `new tweet`, `search for tweets`, `get direction`, ...
All you have to do is follow the documentation for `UIApplicationShortcutItem` [here](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIApplicationShortcutItem_class/index.html#//apple_ref/occ/cl/UIApplicationShortcutItem) and then:

```objc
- (void)application:(UIApplication * _Nonnull)application
performActionForShortcutItem:(UIApplicationShortcutItem * _Nonnull)shortcutItem
  completionHandler:(void (^ _Nonnull)(BOOL succeeded))completionHandler {
    if ([shortcutItem.type isEqualToString:@"newTweet"]) {
        // goto://home/newTweet
    }
}
```

### Search
Using [WACoreDataSpotlight](https://github.com/Wasappli/WACoreDataSpotlight) for example (the samples uses `WAppRouting`), you can respond to `open app from search item` events.

```objc
- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler {
    NSManagedObject *object = [self.mainIndexer objectFromUserActivity:userActivity];
    
    if ([object isKindOfClass:[Company class]]) {
        [AppLink goTo:@"companies/%@", ((Company *)object).name];
    }

    return YES;
} 
```

## Special configuration consideration
### Custom container controller
You should definitively take a look at the `PPRevealSample` project to get an idea of how to get this working. I'm also here to help if needed.
Basic idea is try to allocate all the navigation controllers you need and pass them as the presenting controller. Then, this would behave like a tab bar (see it's category).
If not, then you are in the `PPRevealSideViewController` context where the navigation controller gets allocated on the fly. The idea is to pass the container as the `presentingController` property and implement the `WAAppRoutingContainerPresentationProtocol` protocol (you need the optional method as well).

### Modal with navigation controller
You cannot (yet) present a modal controller and then push a detail one. Like presenting a login view but pushed onto the signup controller.

### Reuse controllers at different locations
Because the stack retrieval is implemented as dealing with controller class uniquely, you cannot have two or more `WAAppRouteEntity` with the same target class when the source controller class is not nil.
If you need to reuse the controller at different places, consider creating simple subclasses of a main controller which handles all the behavior.

## The one more thing: avoid having parameter keys hardcoded
###Purpose
There is a one more thing to this library which is `WAAppLinkParameters` class.
The idea behind is to avoid hardcoding the values.
The behavior is based on an implementation of `WAAppRouterParametersProtocol` protocol, which means that you can provide your own or subclass `WAAppLinkParameters` which provides default behavior and all protocol methods implementation.
You can find an example in the `SimpleExampleParameters` project.

### Example
First, create a subclass:

```objc
@interface ArticleAppLinkParameters : WAAppLinkParameters

@property (nonatomic, strong) NSNumber *articleID;
@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, strong) NSNumber *displayType;

@end
```

You can see here three objects which should be mapped to the url keys
You need to override the `mappingKeyProperty` getter to provide a mapping `url_key: object_property`:

```objc
- (NSDictionary *)mappingKeyProperty {
    return @{
             @"articleID": @"articleID",
             @"article_title": @"articleTitle",
             @"display_type": @"displayType"
             };
}
```

There is a category I wrote on `UIViewController` which configures the object with merging for you.
So, you can now get the value directly with:

```objc
self.label.text = [NSString stringWithFormat:@"ArticleID: %@", ((ArticleAppLinkParameters *)self.appLinkRoutingParameters).articleID];`
```

You can copy the parameters, and set values for a future use:

```objc
ArticleAppLinkParameters *params = [(ArticleAppLinkParameters *)self.appLinkRoutingParameters copy];
params.articleTitle = [NSString stringWithFormat:@"My super article %ld", (long)indexPath.row];
```

Grab the query with a white list:

```objc
NSString *query = [params queryStringWithWhiteList:@[@"articleID", @"articleTitle", @"displayType"];
```

### Advantages
- Update the key on URLs at any time without touching your code.
- Avoid regressions when you add new parameters to the URL.
- Easily build queries for moving from one controller to another.
- Provide default values to a controller initialization. All your configuration is done in one place.

### Notes
- Only `NSString` and `NSNumber` parameters are supported at this time (no `NSDate` for example)
- This may seem to be a pain in the ass to implement rather than using the parameters directly. True, but keep in mind I thought about this one in a large project with big maintenance and evolutions plan involved. 

#Contributing : Problems, Suggestions, Pull Requests?

Please open a new Issue [here](https://github.com/Wasappli/WAAppRouting/issues) if you run into a problem specific to WAAppRouting.

For new features pull requests are encouraged and greatly appreciated! Please try to maintain consistency with the existing code style. If you're considering taking on significant changes or additions to the project, please ask me before by opening a new Issue to have a chance for a merge.

#That's all folks!

- If you are happy don't hesitate to send me a tweet [@ipodishima](http://twitter.com/ipodishima)!
- Distributed under MIT licence.
- Follow Wasappli on [facebook](https://www.facebook.com/wasappli)
