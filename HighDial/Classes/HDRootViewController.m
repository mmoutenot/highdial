//
//  HDRootViewController.m
//  HighDial
//
//  Created by Marshall Moutenot on 7/21/15.
//  Copyright (c) 2015 HighDial. All rights reserved.
//
#import <Intercom/Intercom.h>
#import <SalesforceSDKCore/SFAuthenticationManager.h>
#import <SalesforceSDKCore/SalesforceSDKManager.h>

#import "HDContactListViewController.h"
#import "HDRootViewController.h"
#import "HDSplashNode.h"
#import "HDRegisterNode.h"

@interface HDRootViewController ()

@property (nonatomic) HDSplashNode* splashNode;
@property (nonatomic) HDRegisterNode* registerNode;

@end

@implementation HDRootViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  SFUserAccount* user = [SFUserAccountManager sharedInstance].currentUser;
  if (user) {
    [[SalesforceSDKManager sharedManager] launch];
  } else {
    CGRect viewRect = self.view.bounds;
    
    self.splashNode = [[HDSplashNode alloc] init];
    self.splashNode.bounds = viewRect;
    self.splashNode.position = CGPointMake(CGRectGetMidX(viewRect), CGRectGetMidY(viewRect));
    [self.splashNode measure:self.view.bounds.size];
    
    [self.splashNode.continueButton addTarget:self action:@selector(splashContinuePressed) forControlEvents:ASControlNodeEventTouchUpInside];
    
    [self.view addSubnode:self.splashNode];
  }
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

- (void)splashContinuePressed {
  [self.splashNode removeFromSupernode];
  
  CGRect viewRect = self.view.bounds;
  self.registerNode = [[HDRegisterNode alloc] init];
  self.registerNode.bounds = viewRect;
  self.registerNode.position = CGPointMake(CGRectGetMidX(viewRect), CGRectGetMidY(viewRect));
  [self.registerNode measure:self.view.bounds.size];
  
  [self.registerNode.continueButton addTarget:self action:@selector(registerContinuePressed) forControlEvents:ASControlNodeEventTouchUpInside];
  [self.view addSubnode:self.registerNode];
  
  [self.view setNeedsDisplay];
}

- (void)registerContinuePressed {
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Agree to Privacy Policy" message:@"By creating an account you agree to our privacy policy" preferredStyle:UIAlertControllerStyleAlert];

  UIAlertAction* disagreeAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
  }];

  UIAlertAction* agreeAction = [UIAlertAction actionWithTitle:@"I agree" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    [Intercom registerUserWithEmail:self.registerNode.emailField.text];
    [Intercom updateUserWithAttributes:@{ @"Name": self.registerNode.fullNameField.text, @"Password": self.registerNode.passwordField }];

    HDContactListViewController* contactListViewController = [[HDContactListViewController alloc] init];
    [self.navigationController pushViewController:contactListViewController animated:YES];
  }];

  [alert addAction:disagreeAction];
  [alert addAction:agreeAction];

  [self presentViewController:alert animated:YES completion:nil];
}

@end
