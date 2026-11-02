public with sharing class AccountOrderRevenueService {

    public static void updateAccountRevenue(
        Set<Id> accountIds
    ) {
        if (accountIds == null || accountIds.isEmpty()) {
            return;
        }

        Map<Id, Decimal> totalsByAccount =
            new Map<Id, Decimal>();

        /*
         * Une seule requête pour toutes les commandes
         * de tous les comptes concernés.
         */
        for (AggregateResult result : [
            SELECT
                AccountId accountId,
                SUM(TotalAmount) totalAmount
            FROM Order
            WHERE AccountId IN :accountIds
            AND Status = 'Activated'
            GROUP BY AccountId
        ]) {
            Id accountId =
                (Id) result.get('accountId');

            Decimal totalAmount =
                (Decimal) result.get('totalAmount');

            totalsByAccount.put(
                accountId,
                totalAmount == null ? 0 : totalAmount
            );
        }

        List<Account> accountsToUpdate =
            new List<Account>();

        /*
         * Un compte absent du résultat d’agrégation
         * ne possède plus de commande activée.
         * Son chiffre d’affaires doit donc revenir à zéro.
         */
        for (Id accountId : accountIds) {
            Decimal accountTotal =
                totalsByAccount.containsKey(accountId)
                    ? totalsByAccount.get(accountId)
                    : 0;

            accountsToUpdate.add(
                new Account(
                    Id = accountId,
                    Chiffre_d_affaire__c = accountTotal
                )
            );
        }

        /*
         * Une seule opération DML pour tous les comptes.
         */
        if (!accountsToUpdate.isEmpty()) {
            update accountsToUpdate;
        }
    }
}