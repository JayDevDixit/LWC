 AggregateResult agg = [select count(id) cnt,avg(annualRevenue) avgRevenue from account];
 system.debug(agg.get('cnt')+' '+agg.get('avgRevenue'));

