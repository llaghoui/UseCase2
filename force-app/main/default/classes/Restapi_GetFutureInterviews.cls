@RestResource(urlMapping='/FutureInterviews/*')
global with sharing class Restapi_GetFutureInterviews {

    @HttpGet
    global static List<Interview__c> doGet() {
        List<Interview__c> interviews;
        try {
            interviews = SRV_InterviewService.getFutureInterviews();

            if(interviews==null || interviews.isEmpty())
                throw new InterviewNotFoundException('No comming interviews');

        } catch (Exception ex) {
            Log.error(ex.getMessage());
            throw ex;
        }
        return interviews;
    }
}