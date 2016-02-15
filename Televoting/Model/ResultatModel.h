//
//  ResultatModel.h
//  Televoting
//
//  Created by Thomas Mac on 30/06/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ResultatModelProtocol <NSObject>

- (void) getResultatsDownloaded:(NSArray*) items;

@end

@interface ResultatModel : NSObject <NSURLConnectionDataDelegate>

@property(nonatomic, weak) id<ResultatModelProtocol> delegate;

- (void) getResultatsByUser:(int)user_id questionnaire_id:(int)questionnaire_id;

@end