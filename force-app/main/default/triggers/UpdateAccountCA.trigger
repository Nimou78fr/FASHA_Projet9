trigger UpdateAccountCA on Order (after update) {

    Map<Id, Decimal> caByAccount = new Map<Id, Decimal>();

    for (Order ord : Trigger.new) {
        if (ord.AccountId != null && ord.TotalAmount != null) {
            Decimal currentCA = caByAccount.containsKey(ord.AccountId)
                ? caByAccount.get(ord.AccountId)
                : 0;

            caByAccount.put(
                ord.AccountId,
                currentCA + ord.TotalAmount
            );
        }
    }

    if (caByAccount.isEmpty()) {
        return;
    }

    List<Account> accountsToUpdate = [
        SELECT Id, Chiffre_d_affaire__c
        FROM Account
        WHERE Id IN :caByAccount.keySet()
    ];

    for (Account acc : accountsToUpdate) {
        Decimal currentCA = acc.Chiffre_d_affaire__c != null
            ? acc.Chiffre_d_affaire__c
            : 0;

        acc.Chiffre_d_affaire__c =
            currentCA + caByAccount.get(acc.Id);
    }

    update accountsToUpdate;
}