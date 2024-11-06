import { LightningElement, track } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';

export default class AnimalsandNeeds extends LightningElement {

    genderOptions = [
        { label: 'Male', value: 'Male' },
        { label: 'Female', value: 'Female' },
    ];

    handleInputChange(event) {
        const field = event.target.dataset.id;
        this[field] = event.target.value;
  
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
