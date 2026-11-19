#import <Preferences/PSListController.h>
#import <UIKit/UIKit.h>

@interface ISPRootListController : PSListController
@end

@implementation ISPRootListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
}

- (void)showHelp {
    UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"iosspoof — help & support"
        message:@"1. enable iosspoof and pick hardware model & ios version.\n2. toggle gps spoof and select a region (or double-tap status bar anywhere).\n3. reopen target apps to apply changes.\n\ndev: hacker // binarycrypted"
        preferredStyle:UIAlertControllerStyleAlert];
    [ac addAction:[UIAlertAction actionWithTitle:@"github support" style:UIAlertActionStyleDefault handler:^(UIAlertAction *a) {
        [self openGitHub];
    }]];
    [ac addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:ac animated:YES completion:nil];
}

- (void)openGitHub {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com"]];
}

@end

