---
name: feature-flags
description: Create and manage LaunchDarkly feature flags at SimplePractice. Use when the user must create, toggle, target, test, roll out, or clean up feature flags.
---

# Feature Flags

Use this skill for LaunchDarkly feature flag work at SimplePractice. Feature flags separate deploys from releases. They are code branches that control which users can use a feature.

## Key Files

| File | Purpose |
|------|---------|
| `app/models/concerns/ld_feature_flags.rb` | Backend flag definitions |
| `app/resources/frontend/user_resource.rb` | Flags auto-exposed to the frontend API |
| `frontend/app/models/user.js` | Frontend flag use |
| `app/controllers/application_controller.rb` | Mixpanel experiment tracking |
| `.ld_flag_overrides.yml` (project root) | Local development overrides |

## Naming Convention

- Always use the `feature_` prefix.
- Use lowercase `underscore_case`.
- Use a verbose name that names the feature.
- Do not use abbreviations.
- Examples: `feature_new_payment_allocation`, `feature_client_demographics_report`

## Create A Flag

### 1. Create In LaunchDarkly From The Rails Console

```ruby
LaunchDarklyScripts::CreateFeatureFlagService.new(
  flag_key: "feature_your_flag_name",
  description: "Product Owner: Name. Maintainer: Name. Description of the feature.",
  tags: [LaunchDarklyScripts::CreateFeatureFlagService::PRACTICE_MANAGEMENT_TAG]
).call
```

Available tags: `GROWTH_TAG`, `RCM_TAG`, `PRACTICE_MANAGEMENT_TAG`, `MOBILE_TAG`, `CLINICAL_TAG`

For Therapy Finder flags, add `project_key: "monarch"`.

### 2. Register The Flag

Add the flag to `app/models/concerns/ld_feature_flags.rb`.

Use `fallback_value: false` for new flags.

### 3. Expose To The Frontend, If Needed

Add the flag to `frontend/app/models/user.js`.

The frontend cannot use flags that the API does not expose. Set `frontend: false` in `ld_feature_flags.rb` to hide a flag from the frontend API.

### 4. Create A Cleanup Linear Story Immediately

Link the cleanup story to the implementation story. Set the expected removal date to 30-60 days after 100% rollout.

### 5. Turn The Flag On

```ruby
LaunchDarklyScripts::ToggleFeatureFlagService.new(
  flag_key: "feature_your_flag_name",
  turn_flag_on: true,
  environment_key: "development" # "development", "staging", "production"
).call
```

Turning a flag on makes it available. It does not set the flag value to `true`. Add targeting for that.

### 6. Add Targeting

```ruby
LaunchDarklyScripts::EnableForPracticesService.new(
  flag_key: "feature_your_flag_name",
  flag_value: true,
  practice_uuids: ["uuid1", "uuid2"]
).call
```

## Rollout Process

1. Product finds early adopters and enables the flag through the admin console.
2. Roll out to one test group.
3. Wait 24-48 hours.
4. Expand test groups in small steps. Add a new rule for each expansion when scheduling matters.
5. Post to `#product-releases` at each milestone. Use thread replies.
6. At 100%, update `fallback_value: true` in code within one week.
7. After 30 or more days at 100%, clean up the flag.

Critical rule: Always update `fallback_value: true` when rollout reaches 100%.

If LaunchDarkly is unavailable, flags use the fallback value. If the fallback stays `false`, shipped features become hidden. This caused the October 2025 outage.

## Testing

### RSpec

```ruby
stub_flag(:feature_your_flag_name, true)
```

### Local Development

Option A: Toggle through the [admin dashboard](http://localhost:4005/sa_adm/dashboard).

Option B: Create `.ld_flag_overrides.yml` in the project root. It reloads automatically.

```yaml
feature_your_flag_name: true
```

## A/B Testing

For detailed A/B testing setup, Mixpanel tracking, and Therapy Finder flags, see [reference.md](reference.md).

## Flag Cleanup Checklist

```text
- [ ] Feature stable at 100% for 30+ days
- [ ] fallback_value already set to true
- [ ] Remove flag from ld_feature_flags.rb
- [ ] Remove flag from frontend/app/models/user.js
- [ ] Remove all conditional logic. Keep only the true path.
- [ ] Remove stub_flag calls from tests
- [ ] Run full test suite
- [ ] Deploy to production
- [ ] Archive flag in LaunchDarkly
- [ ] Close cleanup Linear story
```

## Tips

- Flag most customer-facing changes. Balance risk against cleanup cost.
- Control one thing per flag.
- Check the flag early in the flow.
- Do not put flag checks deep in derived logic.
- Make the LaunchDarkly default rule match `fallback_value` in code.
- Flags created in one environment exist in all environments automatically.
