---
name: ruby-allocation-audit
description: Audit Ruby and Rails changes for avoidable object allocations, GC pressure, memory growth, and hot-path inefficiencies. Use when reviewing performance PRs, serializers, jobs, ActiveRecord loops, JSON shaping, logging, or string-heavy Ruby code.
---

# Ruby Allocation Audit

Audit Ruby/Rails changes for avoidable object allocations, GC pressure, memory growth, and hot-path inefficiencies. Prefer small, evidence-backed improvements over clever rewrites.

Ruby performance is often death by a thousand objects: one allocation is cheap, but repeated allocations in a request loop, serializer, job batch, or query path become latency, GC churn, and worker memory growth.

## Trigger

Use this skill when reviewing or modifying Ruby/Rails code that touches:

- request hot paths
- serializers, presenters, builders, or API response shaping
- background jobs over many records
- ActiveRecord loops, relations, or association access
- JSON generation or parsing
- string-heavy code
- arrays, hashes, maps, groups, transforms, and enumerable chains
- logging or instrumentation payloads
- N+1-adjacent data shaping
- code called inside loops

## Non-Negotiable Rule

Do not optimize by vibes. First identify where allocations happen, then reduce them only when the code is hot, repeated, or memory-sensitive.

Reject performance PRs that do not include at least one of:

- an allocation delta
- a query or object-loading delta
- a clear reason measurement was impossible

If the PR has no evidence, say that plainly. A performance claim without a measurement or defensible proxy is just a guess.

## Workflow

### 1. Find the hot path

Ask:

- Is this code called once, per request, per record, per association, or per nested item?
- Is it inside an ActiveRecord batch or job loop?
- Does it run for every API response?
- Could it process hundreds or thousands of objects?
- Does it allocate transient arrays, hashes, or strings that are immediately discarded?

Prioritize repeated paths over isolated setup code.

### 2. Look for allocation smells

Check for:

- `map.select`, `map.compact`, `group_by`, `index_by`, and `flat_map` chains on large collections
- repeated `to_s`, `to_sym`, `deep_symbolize_keys`, or `with_indifferent_access`
- repeated regex creation or matching in loops
- string interpolation inside loops, especially for logs
- constructing hashes repeatedly when a frozen constant would work
- loading full ActiveRecord objects when `pluck`, `pick`, `exists?`, or SQL aggregation would be enough
- missing `includes` or `preload` when association access creates query and object churn
- `each_with_object({})` where values could stream, aggregate in SQL, or be queried directly
- serializers that build large intermediate nested hashes
- unnecessary `dup`, `clone`, `merge`, `deep_dup`, or `compact`
- repeated time parsing, date formatting, JSON parsing, or URI parsing
- accidental array materialization from relations with `.to_a`, `.map`, or `.select`
- memoization that grows unbounded during a request or job
- log payloads that eagerly build hashes or strings even when the log level suppresses them

### 3. Prefer lower-allocation shapes

Avoid full object loading:

```ruby
User.where(active: true).pluck(:id, :email)
```

instead of:

```ruby
User.where(active: true).map { |user| [user.id, user.email] }
```

Push filtering to SQL:

```ruby
Appointment.where(status: "scheduled")
```

instead of:

```ruby
appointments.select { |appointment| appointment.status == "scheduled" }
```

Collapse chained enumerables on large collections:

```ruby
results = []

records.each do |record|
  next unless record.valid?

  results << build_result(record)
end
```

instead of:

```ruby
records
  .select(&:valid?)
  .map { |record| build_result(record) }
```

Use frozen constants for repeated reusable literals:

```ruby
ALLOWED_STATUSES = %w[pending active archived].freeze
EMPTY_HASH = {}.freeze
```

Do not freeze everything blindly. Constants help most when the value is reused.

Guard expensive logging:

```ruby
if Rails.logger.debug?
  Rails.logger.debug("expensive_payload=#{build_payload.inspect}")
end
```

Avoid symbol creation from untrusted or dynamic input:

```ruby
status = params[:status].to_s
```

Normalize key type once at the boundary instead of using `with_indifferent_access` in hot paths.

Batch carefully:

```ruby
User.where(active: true).find_each(batch_size: 1_000) do |user|
  ProcessUser.call(user)
end
```

instead of loading all users into memory.

### 4. Measure before and after

When possible, add a small allocation check. Prefer profiling the real endpoint, job, serializer, or query path over a tiny synthetic method.

Useful tools:

- `GC.stat[:total_allocated_objects]`
- `memory_profiler`
- `stackprof`
- `derailed_benchmarks`
- `benchmark-ips`
- Rails logs or APM allocation metrics, when available

Lightweight allocation measurement:

```ruby
GC.start
before = GC.stat[:total_allocated_objects]

result = described_operation.call

after = GC.stat[:total_allocated_objects]
puts "allocated_objects=#{after - before}"
```

For ActiveRecord-heavy changes, count both queries and object materialization. A lower query count can still allocate too many Ruby objects if the replacement loads broader rows or associations.

### 5. Preserve readability

Do not replace clear Ruby with obscure micro-optimizations unless the path is proven hot.

Avoid this unless profiling proves the gain matters:

```ruby
i = -1
while (i += 1) < records.length
  process(records[i])
end
```

Usually prefer:

```ruby
records.each do |record|
  process(record)
end
```

## Review Output

When auditing a PR or file, respond in this shape:

```md
### Allocation Risk

Low / Medium / High

### Evidence Check

Pass / Fail

State whether the PR includes an allocation delta, query/object-loading delta, or a defensible reason measurement was impossible.

### Hot Paths

List the methods, loops, serializers, jobs, or endpoints most likely to allocate heavily.

### Findings

#### Finding: <short name>

**Location:** `path/to/file.rb:line`

**Why it allocates:**
Explain the object churn plainly.

**Why it matters:**
Explain request/job scale.

**Suggested change:**
Show a small patch or replacement.

**Expected effect:**
Lower object count, less GC pressure, lower memory growth, fewer ActiveRecord objects, or fewer temporary strings/hashes.

**Confidence:** High / Medium / Low

### Measurement Plan

Include the fastest useful way to verify impact.

### Do Not Change

Call out code that looks allocation-heavy but is not worth changing because it is not hot, not repeated, or would hurt clarity.
```

## Staff Heuristics

A good allocation reduction is:

- tied to a real hot path
- measurable
- small
- readable
- behavior-preserving
- aware of ActiveRecord object materialization
- aware of GC pressure, not just CPU time
- careful with memory retention, not only allocation count

The best optimization often deletes a whole layer of unnecessary materialization rather than making the materialization faster.
