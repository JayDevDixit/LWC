import { LightningElement,api } from 'lwc';
import modalComponent from 'c/modalComponent';
export default class MenuPopup extends LightningElement {
    @api progress = 50;
    async handleClick(){
        const result = await modalComponent.open({
            size:'large',
            description:'Accessible description of modal',
            options: [
                { id: 1, label: 'First Name' },
                { id: 2, label: 'Last Name' },
                { id: 2, label: 'Gender' },
                { id: 2, label: 'Date of Birth' },
              ],
              style: {
                '--slds-c-modal-color-border': 'red'
              }
        }).then((result) => {
            console.log(result);
        });
    }
}