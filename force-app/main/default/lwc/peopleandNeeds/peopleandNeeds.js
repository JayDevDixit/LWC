import { LightningElement, track,api,wire } from 'lwc';
import { publish,MessageContext } from 'lightning/messageService';
import COMPONENT_COMMUNICATION_CHANNEL from '@salesforce/messageChannel/ComponentCommunicationChannel__c';


export default class PeopleInfoForm extends LightningElement {
    @wire(MessageContext)
    messageContext;

    @api subSectionIndex;
    @api menuIndex;
    percentageFormFilled = 0;
    countKeyshavingValue(keys){
        let count = 0;
        for(let i of keys)
            if(this[i]!='') count+=1
        return count;
    }
    handleInputChange(event) {
        console.log('menuindex',this.menuIndex)
        console.log('subsectionindex',this.subSectionIndex)
        console.log('this =',JSON.stringify(this))
        const field = event.target.dataset.id;
        this[field] = event.target.value;
        console.log('obj',Object.keys(this).length)
        let change = (this.countKeyshavingValue(Object.keys(this))/6) * 100;
        if(this.percentageFormFilled != change){
            this.percentageFormFilled = change;
            const payload = {
                progress:this.percentageFormFilled,
                menuIndex: this.menuIndex,
                subSectionIndex: this.subSectionIndex,
            }
            console.log('payload',JSON.stringify(payload));
            publish(this.messageContext, COMPONENT_COMMUNICATION_CHANNEL, payload);
            console.log('this.percentageFormFilled',this.percentageFormFilled);
        }
    }

    handleSubmit() {
        this.formSubmitted = true;
    }
}
