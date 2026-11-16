trigger OrderTrigger on Order (after update) {

    OrderTriggerHandler.handleAfterUpdate(
        Trigger.new,
        Trigger.oldMap
    );

}