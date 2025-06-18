/**
* @File Name : ACRUploadControllerLWC.cls
* @Description :
* @Author :
* @Last Modified By :
* @Last Modified On : June 18, 2025
* @Modification Log :
*==============================================================================
* Ver | Date | Author | Modification
*==============================================================================
* 1.0 | June 18, 2025 |   | Initial Version
**/

public with sharing class ACRUploadControllerLWC {
    @AuraEnabled
    public static Map<String, Object> processCSV(String base64Data) {
        Map<String, Object> response = new Map<String, Object>();
        List<String> errors = new List<String>();
        Integer successCount = 0;

        // ⚠️ Hardcoded Contact ID
        String contactId = '003gK0000019BtKQAU';

        try {
            Blob fileBlob = EncodingUtil.base64Decode(base64Data);
            String content = fileBlob.toString();

            List<String> lines = content.split('\n');
            if (lines.size() <= 1) {
                errors.add('The CSV is empty or missing data.');
            } else {
                List<String> header = lines[0].trim().split(',');
                Integer shipToIndex = header.indexOf('ShipToAbbreviation__c');
                Integer portalIndex = header.indexOf('Included_in_Portal__c');

                if (shipToIndex == -1 || portalIndex == -1) {
                    errors.add('Headers must be exactly: ShipToAbbreviation__c,Included_in_Portal__c');
                } else {
                    Set<String> abbrevs = new Set<String>();
                    for (Integer i = 1; i < lines.size(); i++) {
                        String[] row = lines[i].trim().split(',');
                        if (row.size() > shipToIndex) {
                            abbrevs.add(row[shipToIndex].trim());
                        }
                    }

                    Map<String, Account> accMap = new Map<String, Account>();
                    for (Account acc : [
                        SELECT Id, ShipToAbbreviation__c 
                        FROM Account 
                        WHERE ShipToAbbreviation__c IN :abbrevs
                    ]) {
                        accMap.put(acc.ShipToAbbreviation__c, acc);
                    }

                    List<AccountContactRelation> acrList = new List<AccountContactRelation>();

                    for (Integer i = 1; i < lines.size(); i++) {
                        String[] row = lines[i].trim().split(',');

                        if (row.size() <= shipToIndex || row.size() <= portalIndex) {
                            errors.add('Invalid data on line ' + (i + 1));
                            continue;
                        }

                        String abbrev = row[shipToIndex].trim();
                        String portalValue = row[portalIndex].trim().toLowerCase();

                        if (!accMap.containsKey(abbrev)) {
                            errors.add('No Account found for abbreviation: ' + abbrev);
                            continue;
                        }

                        Boolean included = portalValue == 'true';

                        acrList.add(new AccountContactRelation(
                            AccountId = accMap.get(abbrev).Id,
                            ContactId = contactId
                           // Included_in_Portal__c = included
                        ));
                    }

                    if (!acrList.isEmpty()) {
                        insert acrList;
                        successCount = acrList.size();
                    }
                }
            }

        } catch (Exception e) {
            errors.add('Unexpected error: ' + e.getMessage());
        }

        response.put('errors', errors);
        response.put('success', successCount > 0 ? successCount + ' records inserted successfully.' : null);
        return response;
    }
}