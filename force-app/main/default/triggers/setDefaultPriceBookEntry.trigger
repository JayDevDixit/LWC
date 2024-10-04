trigger setDefaultPriceBookEntry on Product2 (after insert) {
    Pricebook2 standardPriceBook = [select id from Pricebook2 where IsStandard=true limit 1];
    List<PricebookEntry>PricebookEntries = new list<PricebookEntry>();
    for(product2 product : Trigger.new)
        PricebookEntries.add(new PricebookEntry(
            Pricebook2Id = standardPriceBook.Id,
            Product2Id = product.id,
            UnitPrice = 1,
            IsActive = true

        ));
    if(!PricebookEntries.isEmpty())
        insert PricebookEntries;

}