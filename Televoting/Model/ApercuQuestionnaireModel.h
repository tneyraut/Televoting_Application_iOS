//
//  ApercuQuestionnaireModel.h
//  Televoting
//
//  Created by Thomas Mac on 05/07/2015.
//  Copyright (c) 2015 Thomas Neyraut. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ApercuQuestionnaireModelProtocol <NSObject>

- (void) getApercuQuestionnaireDownloaded:(NSArray*)items;

@end

@interface ApercuQuestionnaireModel : NSObject <NSURLConnectionDataDelegate>

@property(nonatomic, weak) id<ApercuQuestionnaireModelProtocol> delegate;

- (void) getListeQuestionsReponses:(int)questionnaire_id;

@end
