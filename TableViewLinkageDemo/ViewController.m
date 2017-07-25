//
//  ViewController.m
//  TableViewLinkageDemo
//
//  Created by 思 彭 on 2017/7/25.
//  Copyright © 2017年 思 彭. All rights reserved.
//

#import "ViewController.h"
#import <SRWebSocket.h>
#import "TableLinkageViewController.h"

@interface ViewController ()<SRWebSocketDelegate>

@property (nonatomic, strong) SRWebSocket *webSocket;

@end

@implementation ViewController

- (void)Reconnect{
    self.webSocket.delegate = nil;
    [self.webSocket close];
    
    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"ws://echo.websocket.org"]]];
    self.webSocket.delegate = self;
    
    self.title = @"Opening Connection...";
    
    [self.webSocket open];
}

- (void)viewWillAppear:(BOOL)animated{
    [self Reconnect];
}

- (void)viewDidDisappear:(BOOL)animated{
    // Close WebSocket
    self.webSocket.delegate = nil;
    [self.webSocket close];
    self.webSocket = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"联动" style:UIBarButtonItemStylePlain target:self action:@selector(jump:)];
}

#pragma mark - 设置界面

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket{
    NSLog(@"Websocket Connected");
    self.title = @"Connected!";
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error{
    NSLog(@":( Websocket Failed With Error %@", error);
    
    self.title = @"Connection Failed! (see logs)";
    self.webSocket = nil;
    // 断开连接后每过1s重新建立一次连接
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self Reconnect];
    });
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message{
    NSLog(@"收到消息");
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean{
    NSLog(@"Closed Reason:%@",reason);
    self.title = @"Connection Closed! (see logs)";
    self.webSocket = nil;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload{
    NSString *reply = [[NSString alloc] initWithData:pongPayload encoding:NSUTF8StringEncoding];
    NSLog(@"%@",reply);
}

#pragma mark - Private Action

- (IBAction)sendAction:(id)sender {
    [self.view endEditing:YES];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    [webSocket send:jsonString];
    // WebSocket
    if (self.webSocket) {
        [self.webSocket send:@"test success"];
    }
}

- (void)jump: (UIBarButtonItem *)item {
    NSLog(@"跳过");
    [self.navigationController pushViewController:[TableLinkageViewController new] animated:YES];
}

@end
