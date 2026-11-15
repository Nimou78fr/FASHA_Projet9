trigger UpdateAccountCA on Order (after update) {

    Set<Id> accountIds = new Set<Id>();

    for (Order newOrder : Trigger.new) {

        Order oldOrder = Trigger.oldMap.get(newOrder.Id);

        Boolean hasBeenActivated =
            newOrder.Status == 'Activated'
            && oldOrder.Status != 'Activated';

        Boolean hasBeenDeactivated =
            newOrder.Status != 'Activated'
            && oldOrder.Status == 'Activated';

        if (
            newOrder.AccountId != null
            && (hasBeenActivated || hasBeenDeactivated)
        ) {
            accountIds.add(newOrder.AccountId);
        }

        if (
            oldOrder.AccountId != null
            && oldOrder.AccountId != newOrder.AccountId
            && oldOrder.Status == 'Activated'
        ) {
            accountIds.add(oldOrder.AccountId);
        }
    }

    if (!accountIds.isEmpty()) {
        AccountOrderRevenueService.updateAccountRevenue(accountIds);
    }
}