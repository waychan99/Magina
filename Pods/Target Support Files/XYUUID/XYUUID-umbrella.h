#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "XYDeviceInfoUUID.h"
#import "XYKeyChain.h"
#import "XYUUID.h"

FOUNDATION_EXPORT double XYUUIDVersionNumber;
FOUNDATION_EXPORT const unsigned char XYUUIDVersionString[];

