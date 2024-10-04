import { LightningElement,wire,track } from 'lwc';
import getAccounts from '@salesforce/apex/accountPicklistJS.getAccounts';
import getContactByAccountID from '@salesforce/apex/accountPicklistJS.getContactByAccountID';
import getOpportunityByAccountID from '@salesforce/apex/accountPicklistJS.getOpportunityByAccountID';
const columnsContact = [
    {label:'First Name',fieldName:'FirstName'},
    {label:'Last Name',fieldName:'LastName'},
    {label:'Email',fieldName:'Email'},
]
const columnsOpportunity = [
    {label:'Name',fieldName:'Name'},
    {label:'Stage Name',fieldName:'StageName'},
    {label:'Amount',fieldName:'Amount'},
]
export default class DisplayAssociatedContacts extends LightningElement {
    @track accountOptions=[];
    @track selectedAccountId;
    @track columnsContact = columnsContact;
    @track columnsOpportunity = columnsOpportunity;
    @track contacts = [];
    @track opportunity = [];
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
    loadData(){
        getContactByAccountID({accountID:this.selectedAccountId}).then(result=>{
            this.contacts = result;
        })
        getOpportunityByAccountID({accountID:this.selectedAccountId}).then(result=>{
            this.opportunity = result;
        })
    }
    handleAccountChange(event){
        this.selectedAccountId = event.detail.value;
        this.loadData();
    }
}