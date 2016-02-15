//
//  DataQuestionnaireModel.h
//  Televoting
//
//  Created by Thomas Mac on 04/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataQuestionnaireModelProtocol <NSObject>

- (void) getDataQuestionnaireDownloaded:(NSArray*) items;

@end

@interface DataQuestionnaireModel : NSObject <NSURLConnectionDataDelegate>

@property(nonatomic, weak) id<DataQuestionnaireModelProtocol> delegate;

- (void) getDataQuestionnaire:(int)questionnaire_id;

@end
