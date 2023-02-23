import { LightningElement, api, wire } from 'lwc';
import getEventsByDate from '@salesforce/apex/SRV_EventService.getEventsByDate';

export default class Lwc_SideCalendar extends LightningElement {

    @api objectApiName;

    events = [];
    activityDate = new Date();

    @wire(getEventsByDate, {
        activityDate: '$activityDate'
    })
    events;

    showNextDayEvents() {
        this.activityDate = this.activityDate.setDate(this.activityDate.getDate() + 1);
    }

    showPreviousDayEvents() {
        this.activityDate = this.activityDate.setDate(this.activityDate.getDate() - 1);
    }

}