trigger PreventWrongFamilyTrigger on OpportunityLineItem (before insert) {

    Set<Id> oppIds = new Set<Id>();
    Set<Id> prodIds = new Set<Id>();

    if(Trigger.isBefore && Trigger.isInsert){
            
        for(OpportunityLineItem oli:Trigger.new){
            if(oli.OpportunityId != null){
                oppIds.add(oli.OpportunityId);
            }
            if(oli.Product2Id != null){
                prodIds.add(oli.Product2Id);
            }
        }

        Map<Id,Opportunity> mapOfOppts = new Map<Id, Opportunity>([SELECT Id,Product_Family__c FROM Opportunity WHERE Id IN :oppIds]);
        Map<Id,Product2> mapOfProds = new Map<Id, Product2>([SELECT Id, Family FROM Product2 WHERE Id IN :prodIds]);

        for(OpportunityLineItem oli : Trigger.new){
            if(mapOfOppts.get(oli.OpportunityId).Product_Family__c != mapOfProds.get(oli.Product2Id).Family){
                oli.addError('You cannot add an OpportunityLineItem with different family.');
            }
        }
    }
}