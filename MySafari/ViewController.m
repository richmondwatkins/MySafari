//
//  ViewController.m
//  MySafari
//
//  Created by Richmond on 10/1/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UITextFieldDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *urlTextField;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backButton.enabled = NO;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSURL *url;
    if ([textField.text hasPrefix:@"http://"]) {
         url = [NSURL URLWithString:self.urlTextField.text];
    } else {
        url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@", self.urlTextField.text]];
    }

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];

    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (IBAction)onBackButtonPressed:(UIButton *)sender {
    sender.enabled = NO;
    if ([self.webView canGoBack]) {
        sender.enabled = YES;
        [self.webView goBack];
    }

}

- (IBAction)onForwardButtonPressed:(id)sender {
    [self.webView goForward];
}

- (IBAction)onReloadButtonPressed:(id)sender {
    [self.webView reload];
}

- (IBAction)onStopLoadingButtonPressed:(id)sender {[self.webView stopLoading];
}

- (IBAction)onPlusButtonPressed:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]init];
    alertView.title = @"Coming Soon!";
    [alertView addButtonWithTitle:@"Dismiss"];
    [alertView show];
}

@end
