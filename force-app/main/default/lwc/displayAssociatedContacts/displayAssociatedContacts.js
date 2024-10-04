import { LightningElement,wire,track } from 'lwc';
import getAccounts from '@salesforce/apex/accountPicklistJS.getAccounts';
import getContactByAccountID from '@salesforce/apex/accountPicklistJS.getContactByAccountID';
const columns = [
    {label:'First Name',fieldName:'FirstName'},
    {label:'Last Name',fieldName:'LastName'},
    {label:'Email',fieldName:'Email'},
]
export default class DisplayAssociatedContacts extends LightningElement {
    @track accountOptions=[];
    @track selectedAccountId;
    @track columns = columns;
    @track contacts = [];
    @wire(getAccounts)
    wiredAccounts({error,data}){
        if(data){
            this.accountOptions = data.map(acc => ({label:acc.Name, value: acc.Id}));
        } else if(error){
            console.error('Error in fetching accounts:', error);
        }  else {
            console.log('No accounts found');
        }
    }
    loadContacts(){
        getContactByAccountID({accountID:this.selectedAccountId}).then(result=>{
            this.contacts = result;
        })
    }
    handleAccountChange(event){
        this.selectedAccountId = event.detail.value;
        this.loadContacts();
    }
}