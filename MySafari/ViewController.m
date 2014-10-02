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
@property int scrollValue;
@property (strong, nonatomic) IBOutlet UIButton *forwardButton;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.backButton.enabled = NO;
    self.forwardButton.enabled = NO;
    [self prepopulateTextField];
    self.scrollValue = 0;
    self.webView.scrollView.delegate = self;
    self.webPageTitle.hidden = YES;

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSURL *url;

    if ([textField.text hasPrefix:@"http://"]) {
         url = [NSURL URLWithString:self.urlTextField.text];
    } else {
        url = [NSURL URLWithString: [NSString stringWithFormat:@"http://%@", self.urlTextField.text]];
    }

    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@".(com|org|co|net)$" options:0 error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:self.urlTextField.text options:0 range:NSMakeRange(0, [self.urlTextField.text length])];

    if (!numberOfMatches){
        url = [NSURL URLWithString: [NSString stringWithFormat:@"http://www.google.com/search?q=%@", self.urlTextField.text]];
    }

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:urlRequest];

    [self.view endEditing:YES];

    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    self.webPageTitle.hidden = NO;

    NSString *actualURL = self.webView.request.URL.absoluteString;
    self.urlTextField.text = actualURL;

    NSString *pageTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.webPageTitle.text = pageTitle;

    self.backButton.enabled = YES;

    if ([self.webView canGoForward]) {
        self.forwardButton.enabled = YES;
    }

    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (IBAction)onBackButtonPressed:(UIButton *)sender {
    sender.enabled = NO;

    if ([self.webView canGoBack]) {
        sender.enabled = YES;
        [self.webView goBack];
    }

}

- (IBAction)onForwardButtonPressed:(UIButton *)sender {
    sender.enabled = NO;

    if ([self.webView canGoForward]) {
        sender.enabled = YES;
        [self.webView goForward];
    }
}

- (IBAction)onReloadButtonPressed:(id)sender {
    [self.webView reload];
}


- (IBAction)onStopLoadingButtonPressed:(id)sender {
    [self.webView stopLoading];
}

- (IBAction)onPlusButtonPressed:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc]init];
    alertView.title = @"Coming Soon!";
    [alertView addButtonWithTitle:@"Dismiss"];
    [alertView show];
}
- (IBAction)onClearButtonPushed:(id)sender {
    self.urlTextField.text = @"";
    [self prepopulateTextField];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    self.urlTextField.text = @"";
    self.urlTextField.textColor = [UIColor blackColor];

    [textField becomeFirstResponder];
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if([self.urlTextField.text isEqual: @""]){
        [self prepopulateTextField];
        [textField resignFirstResponder];
    }
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    int scrollPosition = self.webView.scrollView.contentOffset.y;

    if(scrollPosition > self.scrollValue) {
        self.urlTextField.alpha = 0.5;
        self.urlTextField.hidden = YES;
    } else{
        self.urlTextField.alpha = 1;
        [self.urlTextField setHidden:NO];
    }

    self.scrollValue = scrollPosition;
}


-(void)prepopulateTextField {
    self.urlTextField.text = @"Type URL here";
    self.urlTextField.textColor = [UIColor grayColor];

}







@end
