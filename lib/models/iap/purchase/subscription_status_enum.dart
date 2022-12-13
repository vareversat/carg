enum SubscriptionStatusEnum { pending, active, expired }

SubscriptionStatusEnum subscriptionStatusFrom(int? state) {
  switch (state) {
    case 0: // Payment pending
      return SubscriptionStatusEnum.pending;
    case 1: // Payment received
    case 2: // Free trial
      return SubscriptionStatusEnum.active;
    case 3: // Pending deferred upgrade/downgrade
      return SubscriptionStatusEnum.pending;
    case null: // Expired or cancelled
    default:
      return SubscriptionStatusEnum.expired;
  }
}
