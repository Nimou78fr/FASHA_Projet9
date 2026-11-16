public with sharing class OrderTriggerHandler {

    private static final String ACTIVATED_STATUS = 'Activated';

    public static void handleAfterUpdate(
        List<Order> newOrders,
        Map<Id, Order> oldOrdersById
    ) {

        Set<Id> accountIds = new Set<Id>();

        for (Order newOrder : newOrders) {

            Order oldOrder = oldOrdersById.get(newOrder.Id);

            Boolean hasBeenActivated =
                newOrder.Status == ACTIVATED_STATUS
                && oldOrder.Status != ACTIVATED_STATUS;

            Boolean hasBeenDeactivated =
                newOrder.Status != ACTIVATED_STATUS
                && oldOrder.Status == ACTIVATED_STATUS;

            Boolean activatedOrderChangedAccount =
                newOrder.Status == ACTIVATED_STATUS
                && oldOrder.AccountId != newOrder.AccountId;

            if (
                newOrder.AccountId != null
                && (
                    hasBeenActivated
                    || hasBeenDeactivated
                    || activatedOrderChangedAccount
                )
            ) {
                accountIds.add(newOrder.AccountId);
            }

            if (
                oldOrder.AccountId != null
                && oldOrder.AccountId != newOrder.AccountId
                && oldOrder.Status == ACTIVATED_STATUS
            ) {
                accountIds.add(oldOrder.AccountId);
            }
        }

        if (!accountIds.isEmpty()) {
            AccountOrderRevenueService.updateAccountRevenue(accountIds);
        }
    }
}