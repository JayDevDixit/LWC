// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents
// Example IDs (replace with actual IDs from your Salesforce org)
// Id opportunityId = '006dM0000049JtyQAE'; // Opportunity Id
// Id pricebookEntryId = '01sdM000004ChivQAC'; // PricebookEntry Id for the Product

// // Creating Opportunity Line Item
// OpportunityLineItem oli = new OpportunityLineItem();
// oli.OpportunityId = opportunityId;           // Link to the Opportunity
// oli.PricebookEntryId = pricebookEntryId;      // Link to the PricebookEntry (Product)
// oli.Quantity = 10;                            // Number of units
// oli.UnitPrice = 100;                          // Price per unit

// // Insert OpportunityLineItem
// insert oli;

// System.debug('Opportunity Line Item created with Id: ' + oli.Id);

// AccountWithOLI.fetchAccountwithmoreThan2OLI();

// AccountWithMore10Opp.fetchAccountS();

