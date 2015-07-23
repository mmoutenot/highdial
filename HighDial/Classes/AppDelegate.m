#import <Crashlytics/Crashlytics.h>
#import <Fabric/Fabric.h>
#import <Intercom/Intercom.h>
#import <SalesforceSDKCore/SFPushNotificationManager.h>
#import <SalesforceSDKCore/SFDefaultUserManagementViewController.h>
#import <SalesforceSDKCore/SalesforceSDKManager.h>
#import <SalesforceSDKCore/SFUserAccountManager.h>
#import <SalesforceSDKCore/SFAuthenticationManager.h>
#import <SalesforceCommonUtils/SFLogger.h>

#import "AppDelegate.h"
#import "HDRootViewController.h"
#import "HDContactListViewController.h"
  
static NSString* const RemoteAccessConsumerKey = @"3MVG9sG9Z3Q1RlbflJ2Y5ohJyWzuuz.M5GSsf9NdmN3I.zY1IEW2pSMdfFIxHlkAvzsb8QTZFO0d_xYj7N_nK";
static NSString* const OAuthRedirectURI = @"testsfdc:///mobilesdk/detect/oauth/done";

@interface AppDelegate ()

/**
 * Convenience method for setting up the main UIViewController and setting self.window's rootViewController
 * property accordingly.
 */
- (void)setupRootViewController;

/**
 * (Re-)sets the view state when the app first loads (or post-logout).
 */
- (void)initializeAppViewState;

@property (nonatomic) UINavigationController* navigationController;

@end

@implementation AppDelegate

@synthesize window = _window;

- (id)init
{
  self = [super init];
  if (self) {
    [SFLogger setLogLevel:SFLogLevelDebug];
    
    [SalesforceSDKManager sharedManager].connectedAppId = RemoteAccessConsumerKey;
    [SalesforceSDKManager sharedManager].connectedAppCallbackUri = OAuthRedirectURI;
    [SalesforceSDKManager sharedManager].authScopes = @[ @"web", @"api" ];
    __weak AppDelegate *weakSelf = self;
    [SalesforceSDKManager sharedManager].postLaunchAction = ^(SFSDKLaunchAction launchActionList) {
      [weakSelf log:SFLogLevelInfo format:@"Post-launch: launch actions taken: %@", [SalesforceSDKManager launchActionsStringRepresentation:launchActionList]];
      [weakSelf presentRootAuthenticatedViewController];
    };
    [SalesforceSDKManager sharedManager].launchErrorAction = ^(NSError *error, SFSDKLaunchAction launchActionList) {
      [weakSelf log:SFLogLevelError format:@"Error during SDK launch: %@", [error localizedDescription]];
      [weakSelf initializeAppViewState];
      [[SalesforceSDKManager sharedManager] launch];
    };
    [SalesforceSDKManager sharedManager].postLogoutAction = ^{
      [weakSelf handleSdkManagerLogout];
    };
    [SalesforceSDKManager sharedManager].switchUserAction = ^(SFUserAccount *fromUser, SFUserAccount *toUser) {
      [weakSelf handleUserSwitch:fromUser toUser:toUser];
    };
  }
  
  return self;
}

- (BOOL)application:(UIApplication*)application didFinishLaunchingWithOptions:(NSDictionary*)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
  [self initializeAppViewState];
  
  [Intercom setApiKey:@"ios_sdk-88a79a61d5d3ec6fe21c55ad084e0d5080fa8016" forAppId:@"t3a13atb"];
  [Fabric with:@[CrashlyticsKit]];
  HDRootViewController* rootVC = [[HDRootViewController alloc] init];
  self.navigationController = [[UINavigationController alloc] initWithRootViewController:rootVC];
  self.navigationController.navigationBarHidden = YES;
  self.window.rootViewController = self.navigationController;

  return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken {
  //
  // Uncomment the code below to register your device token with the push notification manager
  //
  //[[SFPushNotificationManager sharedInstance] didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
  //if ([SFAccountManager sharedInstance].credentials.accessToken != nil) {
  //    [[SFPushNotificationManager sharedInstance] registerForSalesforceNotifications];
  //}
  //
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error {
  // Respond to any push notification registration errors here.
}

#pragma mark - Private methods

- (void)initializeAppViewState {
  [self.window makeKeyAndVisible];
}

- (void)presentRootAuthenticatedViewController {
  SFUserAccount* user = [SFUserAccountManager sharedInstance].currentUser;
  [Intercom registerUserWithUserId:user.idData.userId];
  [Intercom updateUserWithAttributes:@{ @"email": user.email, @"name": user.fullName }];

  HDContactListViewController* rootVC = [[HDContactListViewController alloc] initWithNibName:nil bundle:nil];
  [self.navigationController presentViewController:rootVC animated:YES completion:nil];
}

- (void)resetViewState:(void (^)(void))postResetBlock {
  if ([self.window.rootViewController presentedViewController]) {
    [self.window.rootViewController dismissViewControllerAnimated:NO completion:^{
      postResetBlock();
    }];
  } else {
    postResetBlock();
  }
}

- (void)handleSdkManagerLogout {
  [self log:SFLogLevelDebug msg:@"SFAuthenticationManager logged out.  Resetting app."];
  [Intercom reset];
  [self resetViewState:^{
    [self initializeAppViewState];
    
    // Multi-user pattern:
    // - If there are two or more existing accounts after logout, let the user choose the account
    //   to switch to.
    // - If there is one existing account, automatically switch to that account.
    // - If there are no further authenticated accounts, present the login screen.
    //
    // Alternatively, you could just go straight to re-initializing your app state, if you know
    // your app does not support multiple accounts.  The logic below will work either way.
    NSArray* allAccounts = [SFUserAccountManager sharedInstance].allUserAccounts;
    if ([allAccounts count] > 1) {
      SFDefaultUserManagementViewController* userSwitchVc = [[SFDefaultUserManagementViewController alloc] initWithCompletionBlock:^(SFUserManagementAction action) {
        [self.window.rootViewController dismissViewControllerAnimated:YES completion:NULL];
      }];
      [self.window.rootViewController presentViewController:userSwitchVc animated:YES completion:NULL];
    } else {
      if ([allAccounts count] == 1) {
        [SFUserAccountManager sharedInstance].currentUser = ([SFUserAccountManager sharedInstance].allUserAccounts)[0];
      }
      
      [[SalesforceSDKManager sharedManager] launch];
    }
  }];
}

- (void)handleUserSwitch:(SFUserAccount*)fromUser
                  toUser:(SFUserAccount*)toUser {
  [self log:SFLogLevelDebug format:@"SFUserAccountManager changed from user %@ to %@.  Resetting app.",
   fromUser.userName, toUser.userName];
  [Intercom reset];
  [self resetViewState:^{
    [self initializeAppViewState];
    [[SalesforceSDKManager sharedManager] launch];
  }];
}

@end
