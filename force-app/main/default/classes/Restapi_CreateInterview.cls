@RestResource(urlMapping='/CreateInterview/*')
global with sharing class Restapi_CreateInterview {

    @HttpPost
    global static Interview__c doPost(String positionId, String candidateId, Datetime startDateTime, Integer duration) {
        Interview__c interviewToUpdate;
        try {
            interviewToUpdate = new Interview__c(
                Position__c = positionId,
                Candidate__c = candidateId,
                InterviewStartDateTime__c =  startDateTime,
                Duration__c = duration
            );
            
            Insert interviewToUpdate;

        } catch (Exception ex) {
            Log.error(ex.getMessage());
            throw ex;
        }

        return interviewToUpdate;
    }
}