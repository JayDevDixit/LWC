import { api, LightningElement, track, wire } from 'lwc';
import { updateRecord } from 'lightning/uiRecordApi';
import { publish,MessageContext } from 'lightning/messageService';
import COMPONENT_COMMUNICATION_CHANNEL from '@salesforce/messageChannel/ComponentCommunicationChannel__c';
import getAnimalsandNeeds from '@salesforce/apex/Menu.getAnimalsandNeeds';
import {updateRecordData} from 'c/genericResources';

export default class AnimalsandNeeds extends LightningElement {
    @wire(MessageContext)
    messageContext
    @api subSectionIndex;
    @api recordId;
    @api menuIndex;
    Name;
    @track animalData = {};
    genderOptions = [
        { label: 'Male', value: 'Male' },
        { label: 'Female', value: 'Female' },
    ];
    percentageFormFilled = 0;

    countKeyshavingValue(keys){
        let count = 0;
        for(let i of keys)
            if(this.animalData[i]!='') count+=1;
        return count;
    }
    connectedCallback(){
        // console.log('connectedCallback recordid');
        getAnimalsandNeeds({recordId: this.recordId}).then(data=>{
            console.log('data',data)
            this.animalData.Name = data['Name'];
            this.animalData.lastName = data['Last_Name__c'];
            this.animalData.age = data['Age__c'];
            this.animalData.gender = data['Gender__c'];
            this.handleProgressBar();    
            
        }).catch(error=>{
            console.error('Error fetching data:', error);
        })
    }
    handleProgressBar(){
        let change = (this.countKeyshavingValue(Object.keys(this.animalData))/4) * 100;
        if(this.percentageFormFilled != change){
            this.percentageFormFilled = change;
            const payload = {
                progress:this.percentageFormFilled,
                menuIndex: this.menuIndex,
                subSectionIndex: this.subSectionIndex,
            }
            publish(this.messageContext, COMPONENT_COMMUNICATION_CHANNEL, payload);
            // console.log('this.percentageFormFilled',this.percentageFormFilled);
        }
    }
    handleInputChange(event) {
        // console.log('Record id->',this.recordId)
        // console.log('menuindex',this.menuIndex)
        // console.log('subsectionindex',this.subSectionIndex)
        const field = event.target.dataset.id;
        this.animalData[field] = event.target.value;
        this.handleProgressBar();
        console.log('field = ',JSON.stringify(this.animalData));

        
        // this.createAnimalsRecord();
    }

    // Generic save function
    saveRecord(fieldMapping) {
        const fields = {
            Id : this.recordId,
        };
        Object.keys(fieldMapping).forEach(key => {
            fields[fieldMapping[key]] = this.animalData[key];
        });

        // const recordInput = { apiName: objectApiName, fields };
        const recordInput = { fields };
        updateRecordData(recordInput)

    }

    createAnimalsRecord() {
        this.saveRecord( {
            lastName: 'Last_Name__c',
            age: 'Age__c',
            gender: 'Gender__c',
            Name: 'Name'
        });
    }

    // resetForm() {
    //     this.firstName = '';
    //     this.lastName = '';
    //     this.age = null;
    //     this.gender = null;
    // }
}
