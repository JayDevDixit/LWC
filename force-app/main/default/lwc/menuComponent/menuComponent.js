import { LightningElement, track } from 'lwc';
import fetchMenu from '@salesforce/apex/fetchMetadata.fetchMenu';
import fetchSubSection from '@salesforce/apex/fetchMetadata.fetchSubSection';
export default class ModalComponent extends LightningElement {
    @track isModalOpen = false;
    @track sections = [
        // { id: 1, label: 'About Response', progress: 75, isExpanded: false, icon: 'utility:chevronright' },
        // { id: 2, label: 'On Behalf Of', progress: 75, isExpanded: false, icon: 'utility:chevronright' },
        // { id: 3, label: 'Red Cross Responders', progress: 75, isExpanded: false, icon: 'utility:chevronright' },
        // { id: 4, label: 'Virtual Response', progress: 75, isExpanded: false, icon: 'utility:chevronright' },
        // { id: 5, label: 'Language', progress: 75, isExpanded: false, icon: 'utility:chevronright' },
        // { id: 6, label: 'Basic Client Information', progress: 0, isExpanded: false, icon: 'utility:chevronright' },
        // { id: 7, label: 'Event', progress: 100, isExpanded: false, icon: 'utility:chevronright' },
        // { id: 8, label: 'Primary Client', progress: 75, isExpanded: false, icon: 'utility:chevronright' },
        // { id: 9, label: 'Client’s Household', progress: 75, isExpanded: false, icon: 'utility:chevronright' },
        // { id: 10, label: 'Shelter', progress: 75, isExpanded: false, icon: 'utility:chevronright' },
        // { id: 11, label: 'Finish Draft', progress: 75, isExpanded: false, icon: 'utility:chevronright' },
        // { id: 12, label: 'Red Cross Assistance', progress: 75, isExpanded: false, icon: 'utility:chevronright' }
    ];

    @track subSections = [
        // { id: 1, label: 'Subsection 1',progress:30},
        // { id: 2, label: 'Subsection 2',progress:55},
        // { id: 3, label: 'Subsection 3',progress:90}
    ];

    handleOpenModal() {
        this.isModalOpen = true;
        fetchMenu().then(result=>{
            this.sections = result.map(record=>{
                return {...record,progress: 75, isExpanded: false, icon: 'utility:chevronright',subSections:[]}
            })
            console.log('menu = ',result); 
        });

        fetchSubSection().then(result=>{
            console.log('subSections = ',result);
            for(let menu of this.sections)
                for(let obj of result){
                    if(menu.id == obj['Menu id']){
                        menu.subSections.push({...obj, progress: 70});
                        // menu.isExpanded  = true;
                    }
                   if(obj.Sections){
                    console.log(obj.Sections)
                    let labels = obj.Sections.split(',');
                    for(let label of labels){
                        menu.subSections.push({...obj, progress: 70, label:label.trim()});
                        // menu.isExpanded  = true;
                        // console.log('menu = ',menu);
                        // console.log('label = ',label.trim());
                    }
                   }
                   
                }
            
            });
            
        
    }

    handleCloseModal() {
        this.isModalOpen = false;
    }

    toggleExpand(event) {
        const sectionId = event.target.dataset.id;
        console.log('sectionId',sectionId);
        this.sections = this.sections.map((section) => {
            if (section.id == sectionId && section.subSections.length>0) {
                section.isExpanded = !section.isExpanded;
                section.icon = section.isExpanded ? 'utility:chevrondown' : 'utility:chevronright';
            }
            return section;
        });
    }
}
