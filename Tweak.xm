/* How to Hook with Logos
Hooks are written with syntax similar to that of an Objective-C @implementation.
You don't need to #include <substrate.h>, it will be done automatically, as will
the generation of a class list and an automatic constructor.

%hook ClassName

// Hooking a class method
+ (id)sharedInstance {
	return %orig;
}

// Hooking an instance method with an argument.
- (void)messageName:(int)argument {
	%log; // Write a message about this call, including its class, name and arguments, to the system log.

	%orig; // Call through to the original function with its original arguments.
	%orig(nil); // Call through to the original function with a custom argument.

	// If you use %orig(), you MUST supply all arguments (except for self and _cmd, the automatically generated ones.)
}

// Hooking an instance method with no arguments.
- (id)noArguments {
	%log;
	id awesome = %orig;
	[awesome doSomethingElse];

	return awesome;
}

// Always make sure you clean up after yourself; Not doing so could have grave consequences!
%end
*/

#import "DBDebug/DBDebug.h"
#import "DBDebug/Headers/UIView+DBUserInterfaceToolkit.h"
#import "DBDebug/Headers/UIWindow+DBShakeTrigger.h"
#import "DBDebug/Headers/UIWindow+DBUserInterfaceToolkit.h"

%hook AppDelegate
- (_Bool)application:(id)arg1 didFinishLaunchingWithOptions:(id)arg2 {
	[DBDebug setup];
	return %orig;
}
%end

%hook UIResponder
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    if (motion == UIEventSubtypeMotionShake) {
        [[window shakeDelegates] makeObjectsPerformSelector:@selector(windowDidEndShakeMotion:) withObject:self];
    }
}
%end


%hook UIWindow
- (void)sendEvent:(UIEvent *)event {
	%orig;
	[self db_handleTouches:event.allTouches];
}
%end

%hook UIView
- (id)initWithCoder:(NSCoder *)aDecod {
	[self hookInitMethod];
	return %orig;
}
- (id)initWithFrame:(CGRect)aDecod {
	[self hookInitMethod];
	return %orig;
}

- (void)dealloc {
	[self hookDellocMethod];
	%orig;
}
%end
