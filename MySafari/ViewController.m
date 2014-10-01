//
//  ViewController.m
//  MySafari
//
//  Created by Richmond on 10/1/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UITextFieldDelegate>
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
    if ([textField.text containsString:@"http://"]) {
         url = [NSURL URLWithString:self.urlTextField.text];
    } else {
        NSString *urlString = [NSString ];
    }

    NSURL *url = [NSURL URLWithString:self.urlTextField.text];
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

@end
