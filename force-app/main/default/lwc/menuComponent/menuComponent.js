import { LightningElement, track } from 'lwc';
import fetchMenuWithSubSections from '@salesforce/apex/fetchMetadata.fetchMenuWithSubSections';
export default class ModalComponent extends LightningElement {
    @track isModalOpen = false;
    @track languages =  [
        { label: 'English', value: 'en' },
        { label: 'German', value: 'de' },
        { label: 'French', value: 'fr' },
        { label: 'Spanish', value: 'es' },
        { label: 'Italian', value: 'it' },
        { label: 'Portuguese', value: 'pt' },
        { label: 'Chinese (Simplified)', value: 'zh-CN' },
        { label: 'Chinese (Traditional)', value: 'zh-TW' },
        { label: 'Japanese', value: 'ja' },
        { label: 'Korean', value: 'ko' },
        { label: 'Russian', value: 'ru' },
        { label: 'Dutch', value: 'nl' },
        { label: 'Arabic', value: 'ar' },
        { label: 'Hindi', value: 'hi' },
        { label: 'Bengali', value: 'bn' },
        { label: 'Polish', value: 'pl' }
    ]
    
    @track selectedLanguage = 'en';
    @track MenuComponents = [
        // { id: 1, label: 'About Response', progress: 75, isExpanded: false, icon: 'utility:chevronright' },
        // { id: 2, label: 'On Behalf Of', progress: 75, isExpanded: false, icon: 'utility:chevronright' },
        // { id: 3, label: 'Red Cross Responders', progress: 75, isExpanded: false, icon: 'utility:chevronright' },
    ];

    handleLanguageChange(event){
        this.selectedLanguage = event.detail.value;
        console.log('selected lang= ',this.selectedLanguage);
    }

    handleOpenModal() {
        this.isModalOpen = true;
        fetchMenuWithSubSections({'selectedLanguage':this.selectedLanguage}).then(result=>{
            console.log('before - ',result)
            this.MenuComponents = result.map(record=>{
                return {...record,progress: 75, isExpanded: false, icon: 'utility:chevronright'}
            })
            console.log('menu = ',result); 
        });
            
    }


    handleCloseModal() {
        this.isModalOpen = false;
    }

    toggleExpand(event) {
        const sectionId = event.target.dataset.id;
        console.log('sectionId',sectionId);
        this.MenuComponents = this.MenuComponents.map((MenuComponent) => {
            if (MenuComponent.id == sectionId && MenuComponent.subSections.length>0) {
                MenuComponent.isExpanded = !MenuComponent.isExpanded;
                MenuComponent.icon = MenuComponent.isExpanded ? 'utility:chevronup' : 'utility:chevronright';
            }
            return MenuComponent;
        });
    }
}
