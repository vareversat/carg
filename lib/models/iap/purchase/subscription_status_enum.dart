// API definition is here https://developers.google.com/android-publisher/api-ref/rest/v3/purchases.subscriptionsv2?hl=fr#subscriptionstate
enum SubscriptionStatusEnum {
  pending,
  active,
  expired,
  paused,
  canceled,
  unspecified,
}

SubscriptionStatusEnum subscriptionStatusFrom(String? state) {
  switch (state) {
    case "SUBSCRIPTION_STATE_PENDING": // Payment pending
      return SubscriptionStatusEnum.pending;
    case "SUBSCRIPTION_STATE_PAUSED": // Paused
      return SubscriptionStatusEnum.paused;
    case "SUBSCRIPTION_STATE_CANCELED": // Canceled
      return SubscriptionStatusEnum.canceled;
    case "SUBSCRIPTION_STATE_ACTIVE": // Free trial
      return SubscriptionStatusEnum.active;
    case "SUBSCRIPTION_STATE_PENDING_PURCHASE_CANCELED": // Pending deferred upgrade/downgrade
      return SubscriptionStatusEnum.pending;
    case null:
      return SubscriptionStatusEnum.unspecified;
    default:
      return SubscriptionStatusEnum.unspecified;
  }
}
