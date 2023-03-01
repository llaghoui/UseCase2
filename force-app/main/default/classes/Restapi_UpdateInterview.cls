@RestResource(urlMapping='/UpdateInterview/*')
global with sharing class Restapi_UpdateInterview {

    @HttpPut
    global static Interview__c doPut(String interviewId, String positionId, String candidateId, Datetime startDateTime, Integer duration) {
        Interview__c interview;
        try {
            Interview__c interviewToUpdate = new Interview__c(
                Id = interviewId,
                Position__c = positionId,
                Candidate__c = candidateId,
                InterviewStartDateTime__c =  startDateTime,
                Duration__c = duration
            );
            
            interview = SRV_InterviewService.updateInterview(interviewToUpdate);

        } catch (Exception ex) {
            Log.error(ex.getMessage());
            throw ex;
        }

        return interview;
    }
}