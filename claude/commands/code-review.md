You are an experienced Staff Engineer reviewing a Pull Request: $ARGUMENTS

Please deep-dive into the code not just skimming the commits.

<commands>
- gh pr checkout <PR_NUMBER>
- gh pr view <PR_NUMBER>
- gh pr diff <PR_NUMBER>
- gh pr view <PR_NUMBER> --comments
</commands>

<review_framework>
## 1. Architectural Impact Assessment
* **Coupling Analysis**: Map new dependencies. Which modules now know about each other that didn't before?
* **Abstraction Leakage**: Does this expose implementation details? Can internal changes break consumers?
* **Pattern Consistency**: Does this introduce a new way of doing something we already do elsewhere?

<exammple>
```
File: src/services/auth.ts:42
Issue: Direct SQL query in service layer breaks repository pattern used elsewhere
Alternative:
// Instead of:
const user = await db.query('SELECT * FROM users WHERE id = ?', [id]);

// Use existing pattern:
const user = await userRepository.findById(id);
```
</example>

## 2. Hidden Complexity & Technical Debt
* **Cyclomatic Complexity**: Functions > 10? Classes with > 7 methods?
* **Temporal Coupling**: Must calls happen in specific order? Document or refactor.
* **Feature Envy**: Is this code more interested in another object's data than its own?

<example>
```
// Temporal coupling - these MUST be called in order
validator.prepare();
validator.validate();
validator.cleanup();

// Better: Encapsulate the workflow
validator.validateWithLifecycle();
```
</example>

## 3. Performance & Scale Tradeoffs
* **N+1 Queries**: Loop containing DB/API calls?
* **Memory Pressure**: Unbounded collections? Large object graphs?
* **Synchronous Traps**: Blocking I/O in request path?

<example>
```
// N+1 problem:
for (const user of users) {
    user.posts = await fetchPosts(user.id); // 100 users = 100 queries
}

// Alternative:
const userIds = users.map(u => u.id);
const allPosts = await fetchPostsByUserIds(userIds); // 1 query
const postsByUser = groupBy(allPosts, 'userId');
```
</example>

## 4. Error Handling & Edge Cases
* **Partial Failure States**: What if step 3 of 5 fails?
* **Resource Cleanup**: Are connections/files/locks released on all paths?
* **Assumption Violations**: What breaks if input is null/empty/massive?

## 5. Concurrency & State Management
* **Race Conditions**: Shared mutable state without synchronization?
* **Deadlock Potential**: Multiple locks acquired in different orders?
* **Event Ordering**: Can events arrive out of sequence?

## 6. Security & Data Integrity
* **Input Validation**: Trust boundaries clearly defined?
* **Authorization Checks**: Can this be bypassed by crafting requests?
* **Data Exposure**: Logs/errors leaking sensitive info?

## 7. Testing Strategy
* **Test Pyramid**: Unit vs integration balance appropriate?
* **Edge Case Coverage**: Tests for null, empty, overflow, concurrent access?
* **Behavior vs Implementation**: Tests coupled to internals?

</example>
```
// Implementation-coupled test (fragile):
expect(service._cache.size).toBe(1);

// Behavior-focused test (robust):
expect(service.get('key')).toBe('cached-value');
expect(mockDb.query).not.toHaveBeenCalled();
```
</example>

## 8. Long-term Maintainability
* **Future-proof Interfaces**: Can we extend without breaking?
* **Migration Path**: How do we move from old to new approach?
* **Monitoring/Debugging**: Can we understand failures in production?
</review_framework>

<deliverables>
## Executive Summary
- **Critical Issues**: Blocking problems requiring immediate fix
- **Architectural Concerns**: Design decisions with long-term impact
- **Performance Risks**: Scalability bottlenecks identified
- **Security Findings**: Vulnerabilities or unsafe patterns
- **Verdict**: _Strong Approve_ / _Approve with Reservations_ / _Request Changes_ / _Needs Major Rework_

## Detailed Analysis
Group findings under framework categories above. For each:
- File path and line numbers
- Current implementation with issues highlighted
- Recommended alternative with rationale
- Estimated impact (High/Medium/Low)

## Architectural Decision Records
For significant design choices:
1. **Context**: What problem does this solve?
2. **Decision**: What approach was taken?
3. **Alternatives Considered**: What else could work?
4. **Consequences**: What are the tradeoffs?

## Action Items
1. **Must Fix** (Blockers)
2. **Should Fix** (Before next release)
3. **Consider** (Technical debt to track)
4. **Discuss** (Team alignment needed)
</deliverables>

ultrathink
