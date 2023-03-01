@RestResource(urlMapping='/InterviewsByRange/*')
global with sharing class Restapi_GetInterviewsByDateRange {

    @HttpGet
    global static List<Interview__c> doGet() {
        List<Interview__c> interviews;
        try {
            Map<String, String> params;
            params = RestContext.request.params;
            System.debug('params: ' + params);

            Datetime startDate = Date.valueOf(params.get('start_date'));
            Datetime endDate = Date.valueOf(params.get('end_date'));

            System.debug(startDate);
            System.debug(endDate);

            interviews = SRV_InterviewService.getInterviewsByDateRange(startDate, endDate);

            if(interviews==null || interviews.isEmpty())
                throw new InterviewNotFoundException('No interviews in this range');

        } catch (Exception ex) {
            System.debug(ex.getMessage());
            Log.error(ex.getMessage());
        }
        return interviews;
    }
}