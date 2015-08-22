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

