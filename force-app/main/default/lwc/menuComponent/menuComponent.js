import { LightningElement, track } from 'lwc';
import fetchMenuWithSubSections from '@salesforce/apex/fetchMetadata.fetchMenuWithSubSections';
// import { NavigationMixin } from 'lightning/navigation';

export default class ModalComponent extends LightningElement {
    @track isModalOpen = false;
    @track componentConstructor;
    @track MenuComponents = [
        // { id: 1, label: 'About Response', progress: 75, isExpanded: false, icon: 'utility:chevronright' },
        // { id: 2, label: 'On Behalf Of', progress: 75, isExpanded: false, icon: 'utility:chevronright' },
        // { id: 3, label: 'Red Cross Responders', progress: 75, isExpanded: false, icon: 'utility:chevronright' },
    ];
    @track showPrimaryClient = false;
    @track childProps = {
      focus:''
    }
    @track showComponent = {
      'showPrimaryClient':false,
    }
    navigateToOtherComponent(event){
      console.log(event.target);
      let buttonLabel = event.target.innerText;
      buttonLabel = 'show'+buttonLabel.replace(/\s+/g, '');
      console.log('buttonLabel',buttonLabel)
      this.showComponent[buttonLabel] = true;
      this.isModalOpen = false;
    }
    handleLanguageChange(event){
        this.selectedLanguage = event.detail.value;
        console.log('selected lang= ',this.selectedLanguage);
    }

    handleOpenModal() {
        this.isModalOpen = true;
        fetchMenuWithSubSections().then(result=>{
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
      console.log('toggle expand called')
        const sectionId = event.target.dataset.id;
        // console.log('sectionId',sectionId);
        this.MenuComponents = this.MenuComponents.map((MenuComponent) => {
            if (MenuComponent.id == sectionId && MenuComponent.subSections.length>0) {
                MenuComponent.isExpanded = !MenuComponent.isExpanded;
                MenuComponent.icon = MenuComponent.isExpanded ? 'utility:chevronup' : 'utility:chevronright';
            }
            return MenuComponent;
        });
    }
    navigateToComponent(event) {
      console.log(event.target);
      let buttonLabel = event.target.innerText;
      buttonLabel = buttonLabel.replace(/\s+/g, '');
      console.log('buttonLabel',buttonLabel)
      // this.showComponent[buttonLabel] = true;
      this.isModalOpen = false;
      console.log('before load comp')
      let targetComponent;
      for(let component of this.MenuComponents){
        if(component.label === buttonLabel){
          targetComponent = buttonLabel;
          break;
        }
        else{
          for(let section of component.subSections)
            if(section.label.replace(/\s+/g, '') == buttonLabel){
              if(section.isSubSection == 'Yes'){
                targetComponent = component.label.replace(/\s+/g, '');
                console.log('--------')
                this.childProps['focus'] = buttonLabel;
                break;
              }else{
                targetComponent = section.label.replace(/\s+/g, '');
                console.log('+++++++++++++')
                break;
              }
            }
        }
      }
      console.log('targetComponent',targetComponent);
      this.targetComponent = targetComponent.charAt(0).toLowerCase() + targetComponent.slice(1)
      console.log('targetComponent',targetComponent);
      console.log('focus',this.childProps['focus']);
      this.loadComponent(this.targetComponent);

    //   let cmpDef = {
    //     componentDef: `c:${buttonLabel}`
    //   };
  
    //   let encodedDef = btoa(JSON.stringify(cmpDef));
    //   console.log('encodedDef',encodedDef);
    //   this[NavigationMixin.Navigate]({
    //     type: "standard__webPage",
    //     attributes: {
    //       url: "/one/one.app#" + encodedDef
    //     }
    //   });
    // }
    
}
// connectedCallback() {
//   import("c/primaryClient")
//     .then(({ default: ctor }) => (this.componentConstructor = ctor))
//     .catch((err) => console.log("Error importing component"));
// }

// renderedCallback() {
//   // this.refs.myCmp will be available on the next rendering cycle after the constructor is set
//   if (this.refs.myCmp) {
//     // this.refs.myCmp will contain a reference to the DOM node
//     console.log(this.refs.myCmp);
//   }
// }




async loadComponent(componentName) {
  console.log('loadcomp called')
  import(`c/${componentName}`)
  .then(({ default: ctor }) => (this.componentConstructor = ctor))
  .catch((err) => console.error("Error importing component"));
 }



  // Code for navigation
    // navigateToPrimaryClient() {
    //     console.log('Aura')
    //     this[NavigationMixin.Navigate]({
    //       type: "standard__component",
    //       attributes: {
    //         componentName: "c__MyAuraComponent"
    //       }
    //     });
    //   }
    // // New method to handle navigation to primaryClient
    // navigateToPrimaryClient1() {
    //     console.log('navi')
    //     let cmpDef = {
    //         componentDef: "c:primaryClient"
    //       };
      
    //       let encodedDef = btoa(JSON.stringify(cmpDef));
    //       this[NavigationMixin.Navigate]({
    //         type: "standard__webPage",
    //         attributes: {
    //           url: "/one/one.app#" + encodedDef
    //         }
    //       });
        }
