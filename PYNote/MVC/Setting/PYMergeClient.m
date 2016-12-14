//
//  PYMergeClient.m
//  PYNote
//
//  Created by kingnet on 16/12/14.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYMergeClient.h"
#import "GCDAsyncSocket.h"
#import "PYMergeSever.h"

static PYMergeClient *sharedClient = nil;

@interface PYMergeClient () <NSNetServiceBrowserDelegate, NSNetServiceDelegate, GCDAsyncSocketDelegate>

@property (nonatomic, retain) NSNetServiceBrowser *serviceBrowser;
@property (nonatomic, retain) NSNetService *connectedService;
@property (nonatomic, retain) NSMutableArray *foundAddresses;
@property (nonatomic, retain) GCDAsyncSocket *asyncSocket;

@end

@implementation PYMergeClient

+ (PYMergeClient *)sharedInstance {
    @synchronized(self) {
        if (sharedClient == nil) {
            sharedClient = [[self alloc] init];
        }
    }
    return sharedClient;
}


+ (id)allocWithZone:(struct _NSZone *)zone {
    @synchronized(self) {
        if (sharedClient == nil) {
            sharedClient = [super allocWithZone:zone];
            return sharedClient;
        }
    }
    return sharedClient;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.connected = NO;
    }
    return self;
}

#pragma mark - Public

- (void)searchServerAndConnect {
    if (self.serviceBrowser == nil) {
        self.serviceBrowser = [[NSNetServiceBrowser alloc] init];
        [self.serviceBrowser setDelegate:self];
    }
    [self.serviceBrowser searchForServicesOfType:@"_myNoteServer._tcp." inDomain:@"local."];
}

- (void)connectToFoundServer {
    if (self.asyncSocket == nil) {
        self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
    }
    BOOL done = NO;
    
    while (!done && ([self.foundAddresses count] > 0))
    {
        NSData *addr = [self.foundAddresses objectAtIndex:0];
        [self.foundAddresses removeObjectAtIndex:0];
        
        TTDEBUGLOG(@"Attempting connection to %@", addr);
        NSError *err = nil;
        if ([self.asyncSocket connectToAddress:addr error:&err]) {
            done = YES;
        } else {
            TTDEBUGLOG(@"Unable to connect: %@", err);
        }
    }
    
    if (!done) {
        TTDEBUGLOG(@"Unable to connect to any resolved address");
    }
}

- (void)sendText:(NSString *)text {
    if ([self.asyncSocket isConnected]) {
        NSString *requestStr = [NSString stringWithFormat:@"%@", text];
        NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
        
        [self.asyncSocket writeData:requestData withTimeout:-1 tag:0];
    }
}

- (void)stop {
    [self.serviceBrowser stop];
    self.foundAddresses = nil;
    if (self.connected) {
        [self.asyncSocket disconnect];
    }
    self.connectedService = nil;
}

#pragma mark - NSNetServiceBrowserDelegate

- (void)netServiceBrowser:(NSNetServiceBrowser *)sender didNotSearch:(NSDictionary *)errorInfo {
    TTDEBUGLOG(@"DidNotSearch: %@", errorInfo);
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)sender
           didFindService:(NSNetService *)netService
               moreComing:(BOOL)moreServicesComing {
    TTDEBUGLOG(@"DidFindService: %@", [netService name]);
    NSString *mineName = [[PYMergeSever sharedInstance] serverName];
    if (mineName && [netService.name isEqualToString:mineName]) {
        return;
    }
    
    // Connect to the first service we find
    
    if (self.connectedService == nil) {
        self.connectedService = netService;
        [self.connectedService setDelegate:self];
        TTDEBUGLOG(@"Resolving...");
        [self.connectedService resolveWithTimeout:5.0];
    }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)sender
         didRemoveService:(NSNetService *)netService
               moreComing:(BOOL)moreServicesComing {
    TTDEBUGLOG(@"DidRemoveService: %@", [netService name]);
}

- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)sender {
    TTDEBUGLOG(@"DidStopSearch");
}

#pragma mark - NSNetServiceDelegate

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict {
    TTDEBUGLOG(@"DidNotResolve");
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender {
    TTDEBUGLOG(@"DidResolve: %@", [sender addresses]);
    
    if (self.foundAddresses == nil) {
        self.foundAddresses = [[sender addresses] mutableCopy];
    }
    [self connectToFoundServer];
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    TTDEBUGLOG(@"Socket:DidConnectToHost: %@ Port: %hu", host, port);
    
    self.connected = YES;
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    TTDEBUGLOG(@"SocketDidDisconnect:WithError: %@", err);
    self.connected = NO;
//    if (!self.connected) {
//        [self connectToNextAddress];
//    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSData *readData = [data copy];
    NSString *text = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    TTDEBUGLOG(@"client read data:%@, tag %ld", text, tag);
//    [sock writeData:data withTimeout:-1 tag:0];
//    [sock readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    TTDEBUGLOG(@"client didWriteDataWithTag:%ld", tag);
}

@end
