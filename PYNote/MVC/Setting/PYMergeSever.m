//
//  PYMergeSever.m
//  PYNote
//
//  Created by kingnet on 16/12/14.
//  Copyright © 2016年 perry. All rights reserved.
//

#import "PYMergeSever.h"
#import "GCDAsyncSocket.h"

static PYMergeSever *sharedServer = nil;

@interface PYMergeSever () <NSNetServiceDelegate, GCDAsyncSocketDelegate>

@property (nonatomic, retain) NSNetService *serverService;
@property (nonatomic, retain) GCDAsyncSocket *asyncSocket;
@property (nonatomic, retain) NSMutableArray *connectedSockets;

@end

@implementation PYMergeSever

+ (PYMergeSever *)sharedInstance {
    @synchronized(self) {
        if (sharedServer == nil) {
            sharedServer = [[self alloc] init];
        }
    }
    return sharedServer;
}


+ (id)allocWithZone:(struct _NSZone *)zone {
    @synchronized(self) {
        if (sharedServer == nil) {
            sharedServer = [super allocWithZone:zone];
            return sharedServer;
        }
    }
    return sharedServer;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - Public

- (void)start {
    if (self.asyncSocket == nil) {
        self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)];
    }
    self.connectedSockets = [[NSMutableArray alloc] init];
    
    NSError *err = nil;
    if ([self.asyncSocket acceptOnPort:0 error:&err]) {
        UInt16 port = [self.asyncSocket localPort];
        
        if (self.serverService == nil) {
            self.serverService = [[NSNetService alloc] initWithDomain:@"local."
                                                                 type:@"_myNoteServer._tcp."
                                                                 name:@""
                                                                 port:port];
            [self.serverService setDelegate:self];
        }
        [self.serverService publish];
        
        // You can optionally add TXT record stuff
        
        NSMutableDictionary *txtDict = [NSMutableDictionary dictionaryWithCapacity:2];
        
        [txtDict setObject:@"moo" forKey:@"cow"];
        [txtDict setObject:@"quack" forKey:@"duck"];
        
        NSData *txtData = [NSNetService dataFromTXTRecordDictionary:txtDict];
        [self.serverService setTXTRecordData:txtData];
    } else {
        TTDEBUGLOG(@"Error in acceptOnPort:error: -> %@", err);
    }
}

- (void)stop {
    self.connectedSockets = nil;
    [self.serverService stop];
}

- (NSString *)serverName {
    if (self.serverService) {
        return self.serverService.name;
    }
    return nil;
}

#pragma mark - NSNetServiceDelegate

- (void)netServiceDidPublish:(NSNetService *)ns {
    TTDEBUGLOG(@"Bonjour Service Published: domain(%@) type(%@) name(%@) port(%i)",
               [ns domain], [ns type], [ns name], (int)[ns port]);
}

- (void)netService:(NSNetService *)ns didNotPublish:(NSDictionary *)errorDict {
    TTDEBUGLOG(@"Failed to Publish Service: domain(%@) type(%@) name(%@) - %@",
               [ns domain], [ns type], [ns name], errorDict);
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket {
    TTDEBUGLOG(@"Accepted new socket from %@:%hu", [newSocket connectedHost], [newSocket connectedPort]);
    
    // The newSocket automatically inherits its delegate & delegateQueue from its parent.
    
    [self.connectedSockets addObject:newSocket];
    [newSocket readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    TTDEBUGLOG(@"SocketDidDisconnect:WithError: %@", err);
    [self.connectedSockets removeObject:sock];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSData *readData = [data copy];
    NSString *text = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
    TTDEBUGLOG(@"server read data:%@, tag %ld", text, tag);
    dispatch_sync(dispatch_get_main_queue(), ^{
        [SVProgressHUD showInfoWithStatus:text];
    });
    
//    [sock writeData:data withTimeout:-1 tag:0];
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    TTDEBUGLOG(@"server didWriteDataWithTag:%ld", tag);
}




@end
