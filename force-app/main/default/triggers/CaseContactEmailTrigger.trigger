trigger CaseContactEmailTrigger on Case (before insert) {

    Set<String> emails = new Set<String>();
    Map<String,Contact> mapOfContacts = new Map<String, Contact>();
    Map<String,Contact> mapOfNewContacts = new Map<String, Contact>();

    if(Trigger.isBefore && Trigger.isInsert){
        for(Case cs : Trigger.new){
            if(cs.SuppliedEmail != null){
                emails.add(cs.SuppliedEmail);
            }
        }

        for(Contact con : [SELECT Id, Email FROM Contact WHERE Email IN :emails]){
            mapOfContacts.put(con.Email, con);
        }

        for(Case cs : Trigger.new){
            if(mapOfContacts.containsKey(cs.SuppliedEmail)){
                cs.ContactId=mapOfContacts.get(cs.SuppliedEmail).Id;
            }else{
                Contact con = new Contact();
                con.LastName = 'Test Contact';
                con.Email = cs.SuppliedEmail;
                con.AccountId = cs.AccountId;
                mapOfNewContacts.put(con.Email, con);
            }
        }

        if(!mapOfNewContacts.values().isEmpty()){
            insert mapOfNewContacts.values();

            for(Case cs : Trigger.new){
                if(mapOfNewContacts.containsKey(cs.SuppliedEmail)){
                    cs.ContactId=mapOfNewContacts.get(cs.SuppliedEmail).Id;
                }

            }
            
        }
    }

}