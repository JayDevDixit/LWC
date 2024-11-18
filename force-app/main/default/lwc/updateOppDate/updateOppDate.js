import { LightningElement, track, wire } from 'lwc';
import updateCloseDate from '@salesforce/apex/opportunityController.updateCloseDate';
import getOpportunities from '@salesforce/apex/opportunityController.getOpportunities';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class UpdateOppDate extends LightningElement {
    @track closeDate;
    @track opportunityId;
    @track value;
    @track options = [];


    handleDateChange(event) {
        this.closeDate = event.target.value;
    }
    handleChangePicklist(event){
        this.value = event.detail.value;
    }

    // Display all opportunity in a picklist

    @wire(getOpportunities)
    wiredOpportunities({error, data}){
        if(data){
            this.options = data.map(opp => ({label:opp.Name, value:opp.Id}));
        } else if(error){
            console.error('Error in fetching opportunity:', error);
        }  else {
            console.log('No opportunity found');
        }
    }




    handleSave(){
        updateCloseDate({opportunityId:this.value,closeDate: this.closeDate}).then((result) => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Close Date Updated Successfully',
                    variant: 'success',
                }),
            );
        }).catch((error) => {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error Enter a valid date',
                    message: error.message,
                    variant: 'error',
                }),
            );
        });
    }
}