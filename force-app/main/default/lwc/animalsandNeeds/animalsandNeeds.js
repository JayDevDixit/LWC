import { api, LightningElement, track, wire } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { publish,MessageContext } from 'lightning/messageService';
import COMPONENT_COMMUNICATION_CHANNEL from '@salesforce/messageChannel/ComponentCommunicationChannel__c';

export default class AnimalsandNeeds extends LightningElement {
    @api recordId;
    @wire(MessageContext)
    messageContext

    @api subSectionIndex;
    @api menuIndex;
    genderOptions = [
        { label: 'Male', value: 'Male' },
        { label: 'Female', value: 'Female' },
    ];
    percentageFormFilled = 0;

    countKeyshavingValue(keys){
        let count = 0;
        for(let i of keys)
            if(this[i]!='') count+=1
        return count;
    }

    handleInputChange(event) {
        console.log('Record id->',this.recordId)
        console.log('menuindex',this.menuIndex)
        console.log('subsectionindex',this.subSectionIndex)
        const field = event.target.dataset.id;
        this[field] = event.target.value;
        let change = (this.countKeyshavingValue(Object.keys(this))/4) * 100;
        if(this.percentageFormFilled != change){
            this.percentageFormFilled = change;
            const payload = {
                progress:this.percentageFormFilled,
                menuIndex: this.menuIndex,
                subSectionIndex: this.subSectionIndex,
            }
            publish(this.messageContext, COMPONENT_COMMUNICATION_CHANNEL, payload);
            console.log('this.percentageFormFilled',this.percentageFormFilled);
        }
    }

    // Generic save function
    saveRecord(objectApiName, fieldMapping) {
        const fields = {};
        Object.keys(fieldMapping).forEach(key => {
            fields[fieldMapping[key]] = this[key];
        });

        const recordInput = { apiName: objectApiName, fields };
        createRecord(recordInput)
            .then(() => {
                console.log('Record inserted successfully');
                this.resetForm();
            })
            .catch(error => {
                console.error('Error creating record:', error);
            });
    }

    createAnimalsRecord() {
        
        this.saveRecord('journey__c', {
            name: 'First_Name__c',
            lastName: 'Last_Name__c',
            age: 'Age__c',
            gender: 'Gender__c',
            name: 'Name'
        });
    }

    resetForm() {
        this.firstName = '';
        this.lastName = '';
        this.age = null;
        this.gender = null;
    }
}
