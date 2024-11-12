import { LightningElement, wire } from 'lwc';
import fetchAccount from '@salesforce/apex/giveAllAccounts.fetchAccount';
import { loadStyle } from 'lightning/platformResourceLoader';
import COLORS from '@salesforce/resourceUrl/colors';

export default class ShowAllAccounts extends LightningElement {
    accounts;
    error;
    isCssLoaded = false;
    columns=[
        {label:'Account Name',fieldName:'Name',cellAttributes: { class: { fieldName: 'firstColumn'},iconName:{fieldName:'iconName'},iconPosition:'right'}},
        {label:'Industry',fieldName:'Industry',cellAttributes: { class: { fieldName: 'secondColumn' }}},
        {label:'Phone',fieldName:'Phone',cellAttributes: { class: { fieldName: 'thirdColumn' },iconName:{fieldName:'iconName'},iconPosition:'right'}},
    ];
    @wire(fetchAccount)
    wiredAccounts({ error, data }) {
        if(data){
            this.accounts = data.map((item)=>{
                return {...item, firstColumn: "first-column", secondColumn: "second-column", thirdColumn: "third-column",iconName:'utility:down' };
            });
        }
        else if(error)
            this.error = error;
    }

   renderedCallback(){
    if(this.isCssLoaded) return;
    loadStyle(this,COLORS).then(()=>{
        console.log('CSS from static resource loaded successfully')
        this.isCssLoaded = true;
    }).catch((error)=>{
        console.error('Error loading CSS from static resource', error)
    });
   }
   
}
