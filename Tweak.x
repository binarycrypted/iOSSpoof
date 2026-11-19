#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <sys/utsname.h>
#import <substrate.h>

static NSString *const kPrefs = @"/var/mobile/Library/Preferences/com.binarycrypted.iosspoof.plist";

static NSDictionary *prefs(void) {
    return [NSDictionary dictionaryWithContentsOfFile:kPrefs] ?: @{};
}

static BOOL isEnabled(void) {
    id v = prefs()[@"enabled"];
    return v ? [v boolValue] : YES;
}

static BOOL isThirdPartyApp(void) {
    NSString *bid = [[NSBundle mainBundle] bundleIdentifier] ?: @"";
    return bid.length > 0 && ![bid hasPrefix:@"com.apple."];
}

// 1. kernel uname() spoof
static int (*orig_uname)(struct utsname *);
static int hooked_uname(struct utsname *name) {
    int r = orig_uname(name);
    if (r == 0 && name && isEnabled() && isThirdPartyApp()) {
        NSString *hw = prefs()[@"hwModel"] ?: @"iPhone14,2";
        if (![hw isEqualToString:@"REAL"]) {
            strncpy(name->machine, [hw UTF8String], sizeof(name->machine) - 1);
        }
    }
    return r;
}

// 2. uidevice spoof
%hook UIDevice
- (NSString *)systemVersion {
    if (isEnabled() && isThirdPartyApp()) {
        NSString *ver = prefs()[@"iosVer"] ?: @"15.8";
        if (![ver isEqualToString:@"REAL"]) return ver;
    }
    return %orig;
}

- (NSString *)name {
    if (isEnabled()) {
        NSString *nm = prefs()[@"customName"];
        if (nm.length > 0) return nm;
    }
    return %orig;
}
%end

// 3. corelocation gps spoof (15 cities)
%hook CLLocation
- (CLLocationCoordinate2D)coordinate {
    NSDictionary *p = prefs();
    if (isEnabled() && [p[@"gpsEnabled"] boolValue]) {
        NSInteger c = [p[@"gpsCity"] integerValue];
        double lats[] = {53.9006, 53.8945, 55.7558, 59.9343, 40.7128, 34.0522, 35.6762, 51.5074, 52.5200, 48.8566, 25.2048, 37.5665, 1.3521, -33.8688, -23.5505};
        double lons[] = {27.5590, 30.3307, 37.6173, 30.3351, -74.0060, -118.2437, 139.6503, -0.1278, 13.4050, 2.3522, 55.2708, 126.9780, 103.8198, 151.2093, -46.6333};
        if (c >= 0 && c < 15) return CLLocationCoordinate2DMake(lats[c], lons[c]);
    }
    return %orig;
}
%end

// 4. quick gps toggle on double-tap status bar
%hook UIStatusBar
- (void)didMoveToWindow {
    %orig;
    for (UIGestureRecognizer *g in self.gestureRecognizers) {
        if ([g isKindOfClass:[UITapGestureRecognizer class]] && ((UITapGestureRecognizer *)g).numberOfTapsRequired == 2) return;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(isp_quickToggle)];
    tap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:tap];
}

%new
- (void)isp_quickToggle {
    NSMutableDictionary *d = [prefs() mutableCopy];
    BOOL next = ![d[@"gpsEnabled"] boolValue];
    d[@"gpsEnabled"] = @(next);
    [d writeToFile:kPrefs atomically:YES];

    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"iOSSpoof"
        message:next ? @"gps spoof: enabled" : @"gps spoof: disabled"
        delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [av show];
}
%end

%ctor {
    MSHookFunction((void *)uname, (void *)hooked_uname, (void **)&orig_uname);
}

