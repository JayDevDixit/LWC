import { LightningElement,wire } from 'lwc';
import getAccounts from '@salesforce/apex/accountPicklistJS.getAccounts'
export default class AccountPicklist extends LightningElement {
    value = '';
    options = [];
    handleChange(event){
        this.value = event.detail.value;
        console.log(`selected account id ${this.value} ${event.detail}`);
        
    }

    @wire(getAccounts)
    wiredAccounts({error,data}){
        if(data){
            this.options = data.map(acc => ({label:acc.Name, value: acc.Id}));
        } else if(error){
            console.error('Error in fetching accounts:', error);
        }  else {
            console.log('No accounts found');
        }
    }
    
}