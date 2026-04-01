---
name: feature-flags
description: Creates and manages LaunchDarkly feature flags at SimplePractice. Use when the user needs to create, toggle, target, test, roll out, or clean up feature flags.
---

# Feature Flags

Reference skill for LaunchDarkly feature flag workflows at SimplePractice. Feature flags decouple deployments from releases — they are if-else statements that control which users see which features.

## Key Files

| File | Purpose |
|------|---------|
| `app/models/concerns/ld_feature_flags.rb` | Flag definitions (backend) |
| `app/resources/frontend/user_resource.rb` | Auto-exposed to frontend API |
| `frontend/app/models/user.js` | Frontend flag consumption |
| `app/controllers/application_controller.rb` | Mixpanel experiment tracking |
| `.ld_flag_overrides.yml` (project root) | Local dev overrides |

## Naming Convention

- Prefix: `feature_` — always
- Lowercase, underscore_case
- Verbose and specific to the feature, no abbreviations
- Examples: `feature_new_payment_allocation`, `feature_client_demographics_report`

## Creating a Flag

### 1. Create in LaunchDarkly (Rails console)

```ruby
LaunchDarklyScripts::CreateFeatureFlagService.new(
  flag_key: "feature_your_flag_name",
  description: "Product Owner: Name. Maintainer: Name. Description of the feature.",
  tags: [LaunchDarklyScripts::CreateFeatureFlagService::PRACTICE_MANAGEMENT_TAG]
).call
```

Available tags: `GROWTH_TAG`, `RCM_TAG`, `PRACTICE_MANAGEMENT_TAG`, `MOBILE_TAG`, `CLINICAL_TAG`

For Therapy Finder flags, add `project_key: "monarch"`.

### 2. Register the flag

Add to `app/models/concerns/ld_feature_flags.rb` with `fallback_value: false` for new flags.

### 3. Expose to frontend (if needed)

Add to `frontend/app/models/user.js`. Flags not exposed on the API are unreachable from the frontend. Set `frontend: false` in `ld_feature_flags.rb` to hide from frontend API.

### 4. Create a cleanup Linear story immediately

Link it to the implementation story. Set expected removal date (30-60 days after 100% rollout).

### 5. Turn the flag on

```ruby
LaunchDarklyScripts::ToggleFeatureFlagService.new(
  flag_key: "feature_your_flag_name",
  turn_flag_on: true,
  environment_key: "development" # "development", "staging", "production"
).call
```

Turning a flag on makes it usable — it does NOT set its value to `true`. Add targeting for that.

### 6. Add targeting

```ruby
LaunchDarklyScripts::EnableForPracticesService.new(
  flag_key: "feature_your_flag_name",
  flag_value: true,
  practice_uuids: ["uuid1", "uuid2"]
).call
```

## Rollout Process

1. Product finds early adopters, enables via admin console
2. Roll out to 1 test group, **wait 24-48 hours**
3. Expand test groups incrementally (new rule per expansion for scheduling)
4. Post to `#product-releases` at each milestone, thread replies
5. At 100%: update `fallback_value: true` in code within 1 week
6. After 30+ days at 100%: clean up the flag

**Critical:** Always update `fallback_value: true` when at 100% rollout. If LaunchDarkly goes down, flags revert to fallback — leaving it `false` hides shipped features. This caused the October 2025 outage.

## Testing

### RSpec
```ruby
stub_flag(:feature_your_flag_name, true)
```

### Local development
Option A: Toggle via [admin dashboard](http://localhost:4005/sa_adm/dashboard)

Option B: Create `.ld_flag_overrides.yml` in project root (auto-reloads):
```yaml
feature_your_flag_name: true
```

## A/B Testing

For detailed A/B testing setup, Mixpanel tracking, and Therapy Finder flags, see [reference.md](reference.md).

## Flag Cleanup Checklist

```
- [ ] Feature stable at 100% for 30+ days
- [ ] fallback_value already set to true
- [ ] Remove flag from ld_feature_flags.rb
- [ ] Remove flag from frontend/app/models/user.js
- [ ] Remove all conditional logic (keep only "true" path)
- [ ] Remove stub_flag calls from tests
- [ ] Run full test suite
- [ ] Deploy to production
- [ ] Archive flag in LaunchDarkly
- [ ] Close cleanup Linear story
```

## Tips

- Most customer-facing changes should be flagged — weigh risk vs cleanup effort
- Control one thing per flag
- Check the flag early in the flow, not deep in derived logic
- Ensure LaunchDarkly "Default rule" matches `fallback_value` in code
- Flags created in one environment exist in all environments automatically
