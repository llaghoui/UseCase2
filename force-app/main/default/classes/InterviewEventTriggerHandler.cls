public with sharing class InterviewEventTriggerHandler extends TriggerHandler {
    private List<Interview__c> newIntreviews;
    private Map<Id, Interview__c> newIntreviewsWithId;

    public InterviewEventTriggerHandler() {
        this.newIntreviews = (List<Interview__c>)Trigger.new;
        this.newIntreviewsWithId = (Map<Id, Interview__c>)Trigger.newMap;
    }

    public override void beforeInsert() {
        for( Interview__c interview: this.newIntreviews) {
            interview.InterviewEndDate__c = interview.InterviewStartDate__c.addHours(Integer.valueOf(interview.Duration__c));
        }
    }

    public override void afterInsert() {
        List<Event> events = new List<Event>();
        for( Interview__c interview: this.newIntreviews) {
            Event event = new Event(
                OwnerId = interview.CreatedById,
                StartDateTime = interview.InterviewStartDate__c,
                EndDateTime = interview.InterviewEndDate__c,
                ActivityDateTime = interview.InterviewStartDate__c,
                Subject = interview.Name,
                WhatId = interview.Id
            );
            events.add(event);
        }
        insert events;
    }

    public override void afterUpdate() {
        Map<Id, Event> events = new Map<Id, Event>([Select Id, WhoId FROM Event WHERE WhatId IN :this.newIntreviewsWithId.keySet()]);
        for(Id key: events.keySet()) {
            Event event = events.get(key);
            Interview__c interview = this.newIntreviewsWithId.get(event.WhatId);
            event.StartDateTime = interview.InterviewStartDate__c;
            event.EndDateTime = interview.InterviewEndDate__c;
            event.Subject = 'updated';
            events.put(event.Id, event);
        }
        update events.values();
    }
}