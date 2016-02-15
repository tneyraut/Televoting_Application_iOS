//
//  PropositionReponseModel.h
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PropositionReponseModelProtocol <NSObject>

- (void) propositionReponseActionDone;

@end

@interface PropositionReponseModel : NSObject

@property (nonatomic,weak) id<PropositionReponseModelProtocol> delegate;

- (void) creationPropositionReponse: (int) user_id questionnaireID:(int)questionnaire_id questionID:(int)question_id;
- (void) updatePropositionReponse: (int) user_id questionnaireID:(int)questionnaire_id questionID:(int)question_id reponseID:(int)reponse_id;
-(void) creationPropositionReponseComplete:(int)user_id questionnaireID:(int)questionnaire_id questionID:(int)question_id reponseID:(int)reponse_id;

@end
