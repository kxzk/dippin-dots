# Feature Flags Reference

## A/B Testing

Add `variations` to the create call. The second element (`variations[1]`) is the default.

```ruby
LaunchDarklyScripts::CreateFeatureFlagService.new(
  flag_key: "feature_launch_dorkly",
  variations: ["noexp", "control", "test_a", "test_b"],
  description: "Product Owner: Name. Maintainer: Name. Description.",
  tags: [LaunchDarklyScripts::CreateFeatureFlagService::CLIENTEXPERIENCE]
).call
```

### Frontend (Ember)

Define a string attribute and use `@equal` for conditions:

```javascript
@attr('string') featureLaunchDorkly;
@equal('featureLaunchDorkly', 'test_a') featureLaunchDorklyTestA;
@equal('featureLaunchDorkly', 'test_b') featureLaunchDorklyTestB;
```

### Mixpanel Tracking

In `app/controllers/application_controller.rb`:

```ruby
def track_launch_darkly
  track_experiment_started(
    experiment_name: "feature_launch_dorkly",
    flag_name: "feature_launch_dorkly",
    cookie_name: "launch_dorkly_tracked"
  )
end
```

## Therapy Finder Flags

Always include `project_key: "monarch"` for Therapy Finder:

```ruby
# Creating
LaunchDarklyScripts::CreateFeatureFlagService.new(
  flag_key: "feature_free_consultation_filter",
  variations: ["noexp", "control", "test"],
  project_key: "monarch",
  description: "Product Owner: Name. Maintainer: Name. Description.",
  tags: [LaunchDarklyScripts::CreateFeatureFlagService::GROWTH_TAG]
).call

# Toggling
LaunchDarklyScripts::ToggleFeatureFlagService.new(
  flag_key: "feature_free_consultation_filter",
  project_key: "monarch",
  turn_flag_on: true
).call
```

## Fetching Flags

### Single flag
```ruby
LaunchDarklyScripts::FetchFeatureFlagService.new(
  flag_key: "feature_your_flag_name"
).call
```

### All flags
```ruby
api_instance = LaunchDarklyApi::FeatureFlagsApi.new
api_instance.get_feature_flags('default').items.map(&:key)
```

## Flag States

Flags have 3 states: `on`, `off`, `archived`.

- **Archived**: always returns fallback value
- **On/Off**: variation depends on targeting context

Flags must be turned on before targeting takes effect.

## Segment Integration

Segment Audiences can sync with LaunchDarkly for hyper-specific targeting (e.g., "anyone who visited X page in the past Y weeks").

## Kill Switches & Configuration Flags

### Kill switches
- Used to disable features during incidents
- Default to `fallback_value: true` (feature on)
- Prefix or tag with "KILLSWITCH" in LaunchDarkly
- Document in incident runbooks

### Configuration flags
- Runtime values (rate limits, variants) — may use non-boolean types
- Reviewed quarterly
- Consider whether these belong in a dedicated config system instead

## Lifecycle Management

### Flag categories
| Category | Lifespan | Cleanup |
|----------|----------|---------|
| Experiment | Temporary | After experiment concludes |
| Feature Rollout | Temporary | 30-60 days after 100% rollout |
| Kill Switch | Permanent | Reviewed quarterly |
| Configuration | Permanent | Reviewed quarterly |

### Exception process (>90 days at 100%)
1. Document reason in Linear story
2. Get EM approval for extension
3. Set new target cleanup date
4. Review monthly

### Cleanup cadence
- **Monthly**: Update fallback values for 100% flags, identify flags ready for removal
- **Quarterly**: Audit stale flags, review permanent flags
- **Annually**: Review all permanent flags

## Design Review Questions

When reviewing designs that introduce feature flags:

1. "If LaunchDarkly is unavailable, what happens to this feature?"
2. "Who will own removing this flag?"
3. "When will it be safe to remove?"
4. "Is this an experiment, rollout, kill switch, or config?"
5. "Should this be a flag or live in our config system?"

## October 2025 Outage Context

During an AWS outage, LaunchDarkly became unavailable and all ~256 flags defaulted to `fallback_value`. Most had `fallback_value: false` even at 100% rollout, causing 3+ years of features to disappear. This is why updating `fallback_value: true` at 100% rollout is critical.
