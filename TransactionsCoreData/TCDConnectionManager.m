//
//  TCDConnectionManager.m
//  TransactionsCoreData
//
//  Created by Jorge González on 11/04/15.
//  Copyright (c) 2015 Jorge González Recio. All rights reserved.
//

#import "TCDConnectionManager.h"
#import "AppDelegate.h"
#import "Transaction.h"
#import "Transaction+ToCoreData.h"

NSString * const kURLTraderJSON = @"https://dl.dropboxusercontent.com/u/11350806/remoteTransactions.json";

@implementation TCDConnectionManager


-(id)init {
  self = [super init];
  
  if (!self) {
    return nil;
  }
  
  return self;
}

// Connect to service to get json file and process the transactions
-(void) getTransactionsFromService {
  
  NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig delegate:self delegateQueue:nil];
  
  NSURL *url = [[NSURL alloc] initWithString:kURLTraderJSON];
  
  // Need context
  NSManagedObjectContext * context = [(AppDelegate *)([UIApplication sharedApplication].delegate) managedObjectContext];
  //Async call
  
  NSURLSessionDataTask *dataTask = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (data) {
      NSArray *resultsArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
      
      NSLog(@"There is data?: %@", resultsArray);
      
#warning     // Delete old itemees!!
      [Transaction removeOldTransactionsInManagedObjectContext:context];
      
      for (NSDictionary * item in resultsArray) {
        [Transaction adNewTransactionWith:item inManagedObjectContext:context];
      }
      
      dispatch_async(dispatch_get_main_queue(), ^{
        [context save:nil];
      });
      
    } else {
      if (error){
        NSLog(@"No data. Error: %@", error);
      }
    }
    
    
  }];
  
  [dataTask resume];
  
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location {
  NSLog(@"Download finished");
}



@end
