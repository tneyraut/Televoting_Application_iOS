//
//  ReponseModel.h
//  Mines Douai Televoting
//
//  Created by Thomas Mac on 11/04/2015.
//  Copyright (c) 2015 Thomas Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ReponseModelProtocol <NSObject>

- (void) reponseDownloaded : (NSArray*) items;

@end

@interface ReponseModel : NSObject

@property (nonatomic,weak) id<ReponseModelProtocol> delegate;

- (void) getReponsesByQuestion: (int) question_id;

- (void) updateReponse:(int)reponse_id reponse:(NSString*)reponse reponse_correcte:(int)reponse_correcte question_suivante_id:(int)question_suivante_id;

- (void) creerReponse:(int)question_id reponse:(NSString*)reponse reponse_correcte:(int)reponse_correcte question_suivante_id:(int)question_suivante_id;

- (void) supprimerReponse:(int)reponse_id;

@end
