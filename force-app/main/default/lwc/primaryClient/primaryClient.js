import { LightningElement, wire,api,track } from 'lwc';
import { CurrentPageReference } from 'lightning/navigation';

export default class PrimaryClient extends LightningElement {
    @api focus;
    // @wire(CurrentPageReference)
    // currentPageRef;
    // get stateValue() {
    //     console.log('primary');
    //     return this.currentPageRef.state.c__someState;
    // }
    @track formData = {
        fullName: '',
        dateOfBirth: '',
        preDisasterAddress: '',
        residency: ''
    };

    // Options for Residency combobox
    residencyOptions = [
        { label: 'Resident', value: 'Resident' },
        { label: 'Non-Resident', value: 'Non-Resident' },
        { label: 'Temporary Resident', value: 'Temporary Resident' }
    ];

    handleInputChange(event) {
        const field = event.target.dataset.id;
        this.formData[field] = event.target.value;
    }

    connectedCallback() {
        console.log('connected callback',this.focus);
        if (this.focus !== '') {
            console.log('focus = ', this.focus);
            // Use a timeout to ensure the DOM is ready before querying for elements
            setTimeout(() => {
                const focusElement = this.template.querySelector('.' + this.focus);
                if (focusElement) {
                    focusElement.focus();
                }
            }, 0);
        }
    }
}
