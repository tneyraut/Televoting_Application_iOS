//
//  ParticipantModel.h
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ParticipantModelProtocol <NSObject>

- (void) participantActionDone;

@end

@interface ParticipantModel : NSObject

@property (nonatomic,weak) id<ParticipantModelProtocol> delegate;

- (void) creationParticipant : (int) user_id uneAnnee:(int) annee;
- (void) updateParticipant : (int)user_id fautes:(int)nombre_de_fautes bonnesReponses:(int)nombre_de_bonnes_reponses ident:(int)questionnaire_id;

@end
