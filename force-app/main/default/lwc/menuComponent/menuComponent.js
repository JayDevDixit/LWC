import { LightningElement, track,api } from 'lwc';
import modalComponent from 'c/modalComponent';

export default class MenuComponent extends LightningElement {
    @track showMenu = false;
    @track buttonLabel = 'Show Menu';
    @api progress = 50;
    
    
    async handleClick(){
        this.showMenu =!this.showMenu;
        this.buttonLabel = this.showMenu? 'Hide Menu' : 'Show Menu';
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