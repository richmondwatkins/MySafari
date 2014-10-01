//
//  ViewController.m
//  MySafari
//
//  Created by Richmond on 10/1/14.
//  Copyright (c) 2014 Richmond. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIWebViewDelegate, UITextFieldDelegate, UIAlertViewDelegate, UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *urlTextField;

@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UILabel *webPageTitle;
@property int prevValue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backButton.enabled = NO;
    self.prevValue = 0;
    self.urlTextField.text = @"Type URL here";
    self.urlTextField.textColor = [UIColor grayColor];
    self.webView.scrollView.delegate = self;

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSString *urlString = self.urlTextField.text;

    if (![urlString hasPrefix:@"http://"]) {
        urlString = [@"http://" stringByAppendingString:urlString];
    }

    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];

    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *actualURL = self.webView.request.URL.absoluteString;
    self.urlTextField.text = actualURL;

    NSString *pageTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.webPageTitle.text = pageTitle;

    self.backButton.enabled = YES;

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
- (IBAction)onClearButtonPushed:(id)sender {
    self.urlTextField.text = @"";
//    self.urlTextField.textColor = [UIColor grayColor];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.urlTextField.text = @"";
    self.urlTextField.textColor = [UIColor blackColor];

    [textField becomeFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([self.urlTextField.text isEqual: @""]){
        self.urlTextField.text = @"Type URL here";
        self.urlTextField.textColor = [UIColor grayColor];
        [textField resignFirstResponder];
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    int scrollPosition = self.webView.scrollView.contentOffset.y;

    if(scrollPosition > self.prevValue) {
        self.urlTextField.alpha = 0.5;
        self.urlTextField.hidden = YES;
    } else{
        self.urlTextField.alpha = 1;
        [self.urlTextField setHidden:NO];
    }

    self.prevValue = scrollPosition;
}










@end
