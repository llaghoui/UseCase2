@RestResource(urlMapping='/Interview/*')
global with sharing class GetInterviewByIdRestResource {

    @HttpPost
    global static Interview__c doPost(Id interviewId) {
        Interview__c interview;
        try {
            interview = SRV_InterviewService.getInterviewById(interviewId);
        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }
        return interview;
    }
}