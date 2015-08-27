#ifndef WAAppRouter_WAAppMacros_h
#define WAAppRouter_WAAppMacros_h

#define WAAppRouterParameterAssert(obj) NSParameterAssert(obj)
#define WAAppRouterClassAssertion(obj, className) WAAppRouterParameterAssert(obj && [obj isKindOfClass:[className class]])
#define WAAppRouterClassAssertionIfExisting(obj, className) if (obj) { WAAppRouterParameterAssert([obj isKindOfClass:[className class]]); }

#define WAAppRouterProtocolAssertion(obj, protocolName) WAAppRouterParameterAssert(obj && [obj conformsToProtocol:@protocol(protocolName)])
#define WAAssert(condition, description) NSAssert(condition, description)

#ifdef WAAPP_DEBUG
 #define WAAppLog(fmt, ...) NSLog((@"WAAppRouting %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ## __VA_ARGS__);
#else
 #define WAAppLog(fmt, ...)
#endif

#endif
