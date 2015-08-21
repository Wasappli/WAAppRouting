V0.0.2

* Added support on `NSMutableDictionary` for `WAAppRouterParametersProtocol`. You can now use a mutable dictionary to provide default parameters.
* Simplified behavior on reloading. You now have a category on `UIViewController` which sets the `WAAppLink` and merge parameters. All you need to care about is reloading your interface with new data on `reloadFromAppLinkRefresh` and optionally, return a class for handling the parameters (see 'SimpleExampleParameters')
* Simplified the router allocation
* README update