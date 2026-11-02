global class UpdateAllAccounts
    implements Database.Batchable<SObject> {

    global Database.QueryLocator start(
        Database.BatchableContext context
    ) {
        return Database.getQueryLocator([
            SELECT Id
            FROM Account
        ]);
    }

    global void execute(
        Database.BatchableContext context,
        List<SObject> scope
    ) {
        Set<Id> accountIds = new Set<Id>();

        for (SObject currentRecord : scope) {
            Account currentAccount = (Account) currentRecord;
            accountIds.add(currentAccount.Id);
        }

        if (!accountIds.isEmpty()) {
            AccountOrderRevenueService.updateAccountRevenue(
                accountIds
            );
        }
    }

    global void finish(
        Database.BatchableContext context
    ) {
        System.debug(
            'Mise à jour des comptes terminée.'
        );
    }
}