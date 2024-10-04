import { LightningElement, api, wire } from 'lwc';
import getOpportunities from '@salesforce/apex/getOppbyAccountID.getOpportunities';

export default class CountOpportunity extends LightningElement {
    @api recordId;
    opportunities = [];   
    totalAmount = 0;      // Initialize totalAmount to 0
    count = 0;            // Initialize count to 0

    @wire(getOpportunities, { accountId: '$recordId' })
    wiredOpportunities({ error, data }) {
        if (data) {
            this.opportunities = data;
            this.count = this.opportunities.length;
            this.totalAmount = this.opportunities.reduce((sum, opportunity) => sum + (opportunity.Amount), 0);
        } else if (error) {
            console.error('Error in fetching opportunities:', error);
        }
    }
}
