# Feature Flags Reference

## A/B Testing

Add `variations` to the create call. The second element, `variations[1]`, is the default.

```ruby
LaunchDarklyScripts::CreateFeatureFlagService.new(
  flag_key: "feature_launch_dorkly",
  variations: ["noexp", "control", "test_a", "test_b"],
  description: "Product Owner: Name. Maintainer: Name. Description.",
  tags: [LaunchDarklyScripts::CreateFeatureFlagService::CLIENTEXPERIENCE]
).call
```

### Frontend (Ember)

Define a string attribute. Use `@equal` for conditions.

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

## Fetch Flags

### Single Flag

```ruby
LaunchDarklyScripts::FetchFeatureFlagService.new(
  flag_key: "feature_your_flag_name"
).call
```

### All Flags

```ruby
api_instance = LaunchDarklyApi::FeatureFlagsApi.new
api_instance.get_feature_flags('default').items.map(&:key)
```

## Flag States

Flags have three states: `on`, `off`, and `archived`.

- Archived: always returns the fallback value.
- On or off: variation depends on the targeting context.

Flags must be turned on before targeting takes effect.

## Segment Integration

Segment Audiences can sync with LaunchDarkly for specific targeting. Example: users who visited a page in the past number of weeks.

## Kill Switches And Configuration Flags

### Kill Switches

- Use kill switches to disable features during incidents.
- Default to `fallback_value: true`. The feature is on.
- Prefix or tag with "KILLSWITCH" in LaunchDarkly.
- Document kill switches in incident runbooks.

### Configuration Flags

- Use configuration flags for runtime values, such as rate limits and variants.
- Configuration flags can use non-boolean types.
- Review configuration flags quarterly.
- Consider whether these values belong in a dedicated config system instead.

## Lifecycle Management

### Flag Categories

| Category | Lifespan | Cleanup |
|----------|----------|---------|
| Experiment | Temporary | After experiment concludes |
| Feature Rollout | Temporary | 30-60 days after 100% rollout |
| Kill Switch | Permanent | Review quarterly |
| Configuration | Permanent | Review quarterly |

### Exception Process: More Than 90 Days At 100%

1. Document the reason in the Linear story.
2. Get EM approval for the extension.
3. Set a new target cleanup date.
4. Review monthly.

### Cleanup Cadence

- Monthly: Update fallback values for 100% flags. Identify flags ready for removal.
- Quarterly: Audit stale flags. Review permanent flags.
- Annually: Review all permanent flags.

## Design Review Questions

When you review designs that add feature flags, ask:

1. "If LaunchDarkly is unavailable, what happens to this feature?"
2. "Who will own removing this flag?"
3. "When will it be safe to remove?"
4. "Is this an experiment, rollout, kill switch, or config?"
5. "Does this need a flag, or must it live in our config system?"

## October 2025 Outage Context

During an AWS outage, LaunchDarkly became unavailable. All approximately 256 flags used `fallback_value`. Most flags had `fallback_value: false` even at 100% rollout. This caused more than 3 years of features to disappear.

This is why updating `fallback_value: true` at 100% rollout is critical.
