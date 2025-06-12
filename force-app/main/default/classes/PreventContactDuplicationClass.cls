public with sharing class PreventContactDuplicationClass {
    
    public static void preventDuplication(List<Contact> conList, Map<Id,Contact> oldMap){

        Set<String> emails = new Set<String>();
        Set<String> phones = new Set<String>();
        Map<String,Contact> mapOfContacts = new Map<String, Contact>();

        for(Contact con : conList){
            if(con.Email != null){
                emails.add(con.Email);
            }
            if(con.Phone != null){
                phones.add(con.Phone);
            }
        }

        List<Contact> existingContacts = [SELECT Id, Email,Phone FROM Contact WHERE Email IN :emails AND Phone IN :phones];

        for(Contact con : existingContacts){
            mapOfContacts.put(con.Email+ '-'+con.Phone, con);
        }

        for(Contact con : conList){
            if(mapOfContacts.containsKey(con.Email+'-'+con.Phone)){
                con.addError('Duplicate contacts are not allowed with same email and phone number');
            }
        
        }
    }
}