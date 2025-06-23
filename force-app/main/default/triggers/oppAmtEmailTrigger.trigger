trigger oppAmtEmailTrigger on Opportunity (after insert, after update) {
    // Collect Opportunity Owners' Ids to fetch Owner details
    Set<Id> ownerIds = new Set<Id>();
    for (Opportunity opp : Trigger.new) {
        if (opp.Amount != null && opp.Amount > 10000) {
            ownerIds.add(opp.OwnerId);
        }
    }

    // Query Owner details
    Map<Id, User> ownerMap = new Map<Id, User>(
        [SELECT Id, Name, Email FROM User WHERE Id IN :ownerIds]
    );

    List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();

    for (Opportunity opp : Trigger.new) {
        if (opp.Amount != null && opp.Amount > 10000) {
            User owner = ownerMap.get(opp.OwnerId);
            if (owner != null && String.isNotBlank(owner.Email)) {
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                mail.setTargetObjectId(owner.Id);  // Required to set recipient
                mail.setSaveAsActivity(false);
                mail.setSubject('Opportunity Amount Limit Crossed');
                mail.setSenderDisplayName('System Admin');

                String body = 'Dear ' + owner.Name + ',<br/><br/>';
                body += 'Your opportunity amount has exceeded the limit.<br/>';
                body += 'Opportunity Name: ' + opp.Name + '<br/>';
                body += 'Amount: ' + opp.Amount;

                mail.setHtmlBody(body);
                mail.setToAddresses(new String[] { owner.Email });

                emailList.add(mail);
            }
        }
    }

    if (!emailList.isEmpty()) {
        Messaging.sendEmail(emailList);
    }
}
