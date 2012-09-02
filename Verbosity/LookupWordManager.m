//
//  LookupWord.m
//  Verbosity
//
//  Created by Mustafa Shabib on 9/2/12.
//  Copyright (c) 2012 Betel Nut Games. All rights reserved.
//

#import "LookupWordManager.h"
#import "JSONKit/JSONKit.h"

static LookupWordManager *sharedInstance = nil;
@implementation LookupWordManager
+ (LookupWordManager*)sharedLookupWordManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LookupWordManager alloc] init];
    });
    return sharedInstance;
}
-(void) lookupDefinitionOfWord:(NSString*)word andFoundDefinitionBlock:(DoneLoadingWordBlock_t)block{

    NSString* url = [NSString stringWithFormat:@"http://www.google.com/dictionary/json?callback=v&q=%@&sl=en&tl=en&client=te", word];
       
        /* success! */
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
            /* process downloaded data in Concurrent Queue */
            NSString *initialResult = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSString* result = [initialResult stringByReplacingOccurrencesOfString:@"\\x" withString:@"X"];
            @try{
                
                if(result != nil && [result length] > 0){
                    NSString* json_start = [result substringFromIndex:2];
                    NSString* jsonString = [json_start substringToIndex:[json_start length]-10];//trim the last bit off of the response from google
                    NSDictionary *deserializedData = [jsonString objectFromJSONString];
                    NSArray* primaries = [deserializedData objectForKey:@"primaries"];
                    NSArray* entries = [(NSDictionary*)[primaries objectAtIndex:0] objectForKey:@"entries"];
                    NSDictionary* first_entry = [entries objectAtIndex:1];
                    NSArray* terms = [first_entry objectForKey:@"terms"];
                    NSDictionary* first_term = [terms objectAtIndex:0];
                    
                    NSString* definition = [first_term objectForKey:@"text"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        /* update UI on Main Thread */
                        block(definition);
                        
                    });
                }
            }
            @catch(NSException *e) {
                CCLOG(@"Exception: %@",e);
            }
        }];
        
}


@end
