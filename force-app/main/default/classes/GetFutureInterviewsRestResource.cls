@RestResource(urlMapping='/Interview/Future/*')
global with sharing class GetFutureInterviewsRestResource {

    @HttpGet
    global static List<Interview__c> doGet() {
        List<Interview__c> interviews;
        try {
            interviews = SRV_InterviewService.getFutureInterviews();

            if(interviews==null || interviews.isEmpty())
                throw new InterviewNotFoundException('No comming interviews');

        } catch (Exception ex) {
            System.debug(ex.getMessage());
        }
        return interviews;
    }
}