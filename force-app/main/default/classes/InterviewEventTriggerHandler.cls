public with sharing class InterviewEventTriggerHandler extends TriggerHandler {
    private List<Interview__c> newIntreviews;
    private Map<Id, Interview__c> newIntreviewsWithId;

    public InterviewEventTriggerHandler() {
        this.newIntreviews = (List<Interview__c>)Trigger.new;
        this.newIntreviewsWithId = (Map<Id, Interview__c>)Trigger.newMap;
    }

    public override void beforeInsert() {
        SRV_InterviewService.calculateInterviewEndDate(this.newIntreviews);
    }

    public override void afterInsert() {
        SRV_EventService.createEventFromInterview(this.newIntreviews);
    }

    public override void beforeUpdate() {
        SRV_InterviewService.calculateInterviewEndDate(this.newIntreviews);
    }

    public override void afterUpdate() {
        SRV_EventService.updateEventDates(this.newIntreviewsWithId);
    }
}