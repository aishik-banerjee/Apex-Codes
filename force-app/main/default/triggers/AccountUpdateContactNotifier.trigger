trigger AccountUpdateContactNotifier on Account (after update) {
    Set<Id> accountIds = new Set<Id>();
    Map<Id, Account> oldMap = Trigger.oldMap;

    // Map to store old LastModifiedDate for each Account
Map<Id, Datetime> oldAccModifiedDates = new Map<Id, Datetime>();
for (Account acc : Trigger.new) {
    Account oldAcc = oldMap.get(acc.Id);
        if (acc.LastModifiedDate != oldAcc.LastModifiedDate) {
            accountIds.add(acc.Id);
            oldAccModifiedDates.put(acc.Id, Trigger.oldMap.get(acc.Id).LastModifiedDate);
        }
    
}

// Fetch all related Contacts for updated Accounts
List<Contact> relatedContacts = [
    SELECT Id, FirstName, LastName, Email, LastModifiedDate, AccountId
    FROM Contact
    WHERE AccountId IN :accountIds
];

// Filter Contacts that were modified after last Account update
List<Contact> modifiedContacts = new List<Contact>();
for (Contact con : relatedContacts) {
    Datetime lastAccUpdate = oldAccModifiedDates.get(con.AccountId);
    if (lastAccUpdate != null && con.LastModifiedDate > lastAccUpdate) {
        modifiedContacts.add(con);
    }
}


    // Group contacts by AccountId
    Map<Id, List<Contact>> accToContacts = new Map<Id, List<Contact>>();
    for (Contact con : modifiedContacts) {
        if (!accToContacts.containsKey(con.AccountId)) {
            accToContacts.put(con.AccountId, new List<Contact>());
        }
        accToContacts.get(con.AccountId).add(con);
    }

    // Fetch Account Owner emails
    Map<Id, User> accountOwners = new Map<Id, User>();
    for (Account acc : [
        SELECT Id, Owner.Email 
        FROM Account 
        WHERE Id IN :accountIds
    ]) {
        accountOwners.put(acc.Id, acc.Owner);
    }

    List<Messaging.SingleEmailMessage> emails = new List<Messaging.SingleEmailMessage>();

    for (Id accId : accToContacts.keySet()) {
        List<Contact> contacts = accToContacts.get(accId);
        if (contacts.isEmpty()) continue;

        String body = 'Contacts modified since last Account update:\n\n';
        for (Contact con : contacts) {
            body += 'Name: ' + con.FirstName + ' ' + con.LastName + 
                    ', Email: ' + con.Email + 
                    ', LastModified: ' + con.LastModifiedDate + '\n';
        }

        User owner = accountOwners.get(accId);
        if (owner != null && owner.Email != null) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setToAddresses(new String[] { owner.Email });
            mail.setSubject('Contacts Updated for Account');
            mail.setPlainTextBody(body);
            emails.add(mail);
        }
    }

    if (!emails.isEmpty()) {
        Messaging.sendEmail(emails);
    }
}
