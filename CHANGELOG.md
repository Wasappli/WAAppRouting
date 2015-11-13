## [V0.0.5](https://github.com/Wasappli/WAAppRouting/releases/tag/0.0.5)
### Fixes
- Fix route parameters extraction when URL scheme is http(s) by [enfoiro](https://github.com/enfoiro)
- Fixed an issue with query parameters as numbers others than long values


## [V0.0.4](https://github.com/Wasappli/WAAppRouting/releases/tag/0.0.4)

### Fixes
- If you provide an entity with a path you already registered using `registerAppRouteEntity:` on `WAAppRouteRegistrar`, then the registrar will ignore that entity.
- Fixed an issue when passing a class on registration which does not exists. The assertion description was wrong.
- Fixed an issue when reusing a navigation controller to place an entity with no previous one. It was simply pushing on stack, expected behavior is to reset the stack and place the controller.
- Fixed an issue with URL and path escaping when you got for example `"name": "Ben & Jerry"`. `&` is now correctly escaped using `CFURLCreateStringByAddingPercentEscapes`
- Fixed an issue when presenting a modal controller over a modal controller. For example for this path: `(...)/redeem{RedeemVC}!/signup{SignupVC}!`.
- Fixed a memory leak on `WAAppLinkParameters`
- Fixing README
- Added some documentation about iOS 9:
	- Search (CoreSpotlight) using [WACoreDataSpotlight](https://github.com/Wasappli/WACoreDataSpotlight) which automatically index CoreData
	- 3D Touch released with iPhone 6S and iPhone 6+S
	
### Evolutions
- `WAAppLinkParameters` now supports `NSCoding`. This is useful for state preservation and restoration!
- Added an optional method on `WAAppRouterTargetControllerProtocol` to tell the controllers that the next controller has been presented or reloaded. `- (void)waappRoutingDidDisplayController:(UIViewController *)controller withAppLink:(WAAppLink *)appLink;`

## [V0.0.3](https://github.com/Wasappli/WAAppRouting/releases/tag/0.0.3)

### Fixes 
- Fixed an issue with block execution when no entity registered with the same path.
- Check for equality on WAAppRouteEntity before triggering any assertion that the path is already used.
- Fixed the use of `WAAppRouting` in a project linked to an app extension thanks to [@yusefnapora](https://github.com/yusefnapora). @see `WA_APP_EXTENSION`

### Evolution
- Added a new way to register your route. Instead of using the `WAAppRouteEntity`, you can now define a path like `@"list{WAListViewController}/:itemID{WAListDetailViewController}/extra{WAListDetailExtraViewController}"`.

The syntax is the following:

- `url_path_component{ClassName}`
- `url_path_component1{ClassName1}/url_path_component2{ClassName2}`
- etc

If you want to present a modal, then simply add `!` after the class you want to present modally like `@"list{WAListViewController}/:itemID{WAListDetailViewController}/modal{WAListDetailExtraViewController}!"`


## [V0.0.2](https://github.com/Wasappli/WAAppRouting/releases/tag/0.0.2)

* Added support on `NSMutableDictionary` for `WAAppRouterParametersProtocol`. You can now use a mutable dictionary to provide default parameters.
* Simplified behavior on reloading. You now have a category on `UIViewController` which sets the `WAAppLink` and merge parameters. All you need to care about is reloading your interface with new data on `reloadFromAppLinkRefresh` and optionally, return a class for handling the parameters (see 'SimpleExampleParameters')
* Simplified the router allocation
* README update

