public with sharing class ACRUploadLWCController {
    @AuraEnabled
    public static String processCsvFile(String csvData) {
        String contactId = '003gK0000019BtKQAU'; // 🔒 Hardcoded Contact ID

        if (String.isBlank(csvData) || String.isBlank(contactId)) {
            return 'No data or contact ID provided.';
        }

        List<String> lines = csvData.split('\n');
        if (lines.size() <= 1) {
            return 'No data rows found in CSV.';
        }

        Set<String> abbrevs = new Set<String>();
        for (Integer i = 1; i < lines.size(); i++) {
            String line = lines[i].replaceAll('"', '').trim();
            if (!String.isBlank(line)) abbrevs.add(line);
        }

        Map<String, Account> accMap = new Map<String, Account>();
        for (Account acc : [SELECT Id, ShipToAbbreviation__c FROM Account WHERE ShipToAbbreviation__c IN :abbrevs]) {
            accMap.put(acc.ShipToAbbreviation__c, acc);
        }

        List<AccountContactRelation> acrList = new List<AccountContactRelation>();
        List<String> errors = new List<String>();

        for (String abbrev : abbrevs) {
            if (accMap.containsKey(abbrev)) {
                acrList.add(new AccountContactRelation(
                    AccountId = accMap.get(abbrev).Id,
                    ContactId = contactId
                    //RelationRole = 'Business'
                ));
            } else {
                errors.add(abbrev);
            }
        }

        if (!acrList.isEmpty()) {
            insert acrList;
        }

        return acrList.size() + ' records inserted.' + 
            (errors.isEmpty() ? '' : ' Some abbreviations not found: ' + String.join(errors, ', '));
    }
}
