# Small Releases
## Frequent, Reliable Deployments to Production

**Version:** 1.0  
**Created:** November 2025  
**Owner:** Kalpa (CEO)  
**Philosophy:** Ship often, ship safely

---

## Table of Contents

1. [Why Small Releases](#why-small-releases)
2. [Release Frequency Targets](#release-frequency-targets)
3. [CI/CD Pipeline Requirements](#cicd-pipeline-requirements)
4. [Release Process](#release-process)
5. [Feature Flags](#feature-flags)
6. [Rollback Procedures](#rollback-procedures)
7. [Quality Gates](#quality-gates)

---

## Why Small Releases

### Benefits of Frequent Releases

**Faster feedback:**
- Users see features sooner
- Learn what works quickly
- Iterate based on real usage
- Less time between code and validation

**Lower risk:**
- Small changes easier to test
- Problems easier to identify
- Rollback simpler
- Less code to debug

**Better quality:**
- Issues found quickly
- Technical debt doesn't accumulate
- Team stays focused
- Continuous improvement

**Client trust:**
- Regular progress visible
- Consistent delivery
- Responsive to feedback
- Professional execution

### Traditional vs OneSyntax Approach

**Traditional (Risky):**
```
Develop for 3 months →
"Big release" →
100 changes at once →
Something breaks →
Panic debugging →
"Never deploying on Friday again"
```

**OneSyntax (Safe):**
```
Develop feature →
Automated tests pass →
Deploy to staging →
Manual QA →
Deploy to production (every 2 weeks) →
Monitor →
Fix issues immediately (small scope) →
Repeat
```

---

## Release Frequency Targets

### Current Target: Every 2 Weeks (End of Sprint)

**Why every 2 weeks:**
- Aligns with sprint cadence
- Time for thorough testing
- Manageable change scope
- Client can plan around it
- Team can prepare

**Release schedule:**
- **Friday 3pm:** Deploy to staging
- **Friday 4pm:** Sprint demo to client
- **Monday morning:** Monitor staging
- **Monday afternoon:** Deploy to production (if stable)

### Future Target: Weekly or On-Demand

**Once mature:**
- Weekly releases for predictable features
- On-demand for urgent fixes
- Multiple releases per week possible

**Requirements to reach this:**
- Comprehensive automated test suite
- Mature CI/CD pipeline
- Feature flags for all new features
- Team confidence in rollback process
- Client comfortable with frequency

### Emergency Releases

**For production issues:**
- Deploy fix immediately
- Follow abbreviated process
- Full retrospective after

---

## CI/CD Pipeline Requirements

### Continuous Integration (CI)

**On every commit:**
1. Code pushed to Git
2. Automated checks run:
   - Lint code style
   - Run unit tests
   - Run integration tests
   - Check architectural rules (ArchUnit)
   - Verify test coverage
   - Security scans

**If any check fails:**
- Commit is blocked
- Developer notified immediately
- Must fix before continuing
- No broken code merges to main

**Tools:**
- GitHub Actions (preferred)
- GitLab CI/CD (alternative)
- Jenkins (legacy projects)

### Continuous Deployment (CD)

**Automated deployment pipeline:**

**1. Staging deployment (automatic)**
```
main branch updated →
Run all tests →
Build application →
Deploy to staging →
Run smoke tests →
Notify team
```

**2. Production deployment (manual trigger)**
```
Staging validated →
Manual approval in pipeline →
Run all tests again →
Build application →
Deploy to production →
Run smoke tests →
Monitor metrics →
Notify team
```

### Pipeline Configuration

**Required stages:**
1. **Build** - Compile code, install dependencies
2. **Test** - Run full test suite
3. **Quality** - Code coverage, static analysis, architectural checks
4. **Security** - Dependency scanning, vulnerability checks
5. **Deploy Staging** - Automatic on merge to main
6. **Deploy Production** - Manual approval required

**Typical pipeline duration:**
- Build: 2-3 minutes
- Tests: 5-10 minutes
- Quality checks: 2-3 minutes
- Total: 10-15 minutes

**If pipeline takes >20 minutes:** Optimize test suite or parallelize.

---

## Release Process

### Standard Release (Every 2 Weeks)

**Friday (End of Sprint):**

**3:00 PM - Deploy to Staging**
1. Final code review completed
2. All tests passing
3. Merge to main branch
4. CI/CD deploys to staging automatically
5. Smoke tests run automatically

**3:30 PM - Manual QA on Staging**
- Test key user flows
- Verify new features work
- Check nothing broke
- Test on different devices/browsers

**4:00 PM - Sprint Demo**
- Show client new features on staging
- Get feedback
- Note any issues

**4:30 PM - Go/No-Go Decision**
- Are we confident in this release?
- Any critical bugs found?
- Client feedback positive?
- **GO:** Schedule Monday production deployment
- **NO-GO:** Fix issues, deploy later

---

**Monday (Production Release):**

**9:00 AM - Final Staging Check**
- Verify staging still stable over weekend
- No new issues reported
- All smoke tests passing

**10:00 AM - Production Deployment**
1. Team ready to monitor
2. Trigger production pipeline
3. Watch deployment progress
4. Smoke tests run in production
5. Monitor metrics/logs

**10:15 AM - Post-Deployment Validation**
- Check critical user flows
- Monitor error rates
- Watch performance metrics
- Client notification sent

**Rest of day:**
- Monitor metrics closely
- Respond to issues immediately
- Team available for quick fixes

**End of day:**
- Create release notes
- Update changelog
- Document any issues
- Retrospective if problems

---

### Emergency Hotfix Process

**For critical production bugs:**

**Immediate Response:**
1. Create hotfix branch from production
2. Implement minimal fix
3. Write test reproducing bug
4. Verify fix resolves issue
5. Fast-track code review (30 min max)
6. Deploy to staging
7. Quick validation (15 min)
8. Deploy to production
9. Monitor closely

**Target time:** Fix in production within 2 hours of discovery

**After hotfix:**
- Full retrospective within 24 hours
- Root cause analysis
- Prevent recurrence
- Document lessons learned

---

## Feature Flags

### What Are Feature Flags?

**Definition:** Code switches that enable/disable features without deploying new code.

**Purpose:**
- Deploy code before it's ready for users
- Test in production safely
- Progressive rollout to users
- Quick rollback without deployment

### When to Use Feature Flags

**Required for:**
- Major new features (risky changes)
- Experimental features (may remove)
- B/A testing scenarios
- Features not ready for all users

**Not needed for:**
- Bug fixes
- Internal refactoring
- Small UI updates
- Low-risk changes

### Implementation Pattern

**Simple flag:**
```php
// In domain service or application layer
public function createOrder(OrderData $data): Order
{
    if (FeatureFlags::isEnabled('new_order_flow')) {
        // New implementation
        return $this->newOrderService->create($data);
    }
    
    // Old implementation (fallback)
    return $this->oldOrderService->create($data);
}
```

**User-specific flag:**
```php
if (FeatureFlags::isEnabledForUser('premium_features', $user)) {
    // Premium feature code
}
```

**Percentage rollout:**
```php
if (FeatureFlags::isEnabledForPercentage('new_ui', 10)) {
    // Show new UI to 10% of users
}
```

### Feature Flag Lifecycle

**1. Development:**
- Feature flag created (default: off)
- New code behind flag
- Deploy to production (flag still off)

**2. Testing:**
- Enable flag for internal team
- Test in production environment
- Fix issues while flag off for users

**3. Rollout:**
- Enable for 5% of users
- Monitor metrics
- Increase to 25%, then 50%, then 100%

**4. Cleanup:**
- When feature stable at 100%
- Remove flag from code
- Delete flag configuration
- Clean up old code path

**Never leave permanent flags in code** (tech debt).

### Feature Flag Tools

**Options:**
- LaunchDarkly (enterprise, $$$)
- Unleash (open source, self-hosted)
- Simple database table (start here)

**Simple implementation:**
```
feature_flags table:
- flag_name (string)
- enabled (boolean)
- user_percentage (int)
- enabled_users (json)
- created_at
- updated_at
```

---

## Rollback Procedures

### When to Rollback

**Immediate rollback if:**
- Critical functionality broken
- Data corruption risk
- Security vulnerability introduced
- Error rate >5% higher than baseline
- Payment processing fails

**Not immediate rollback:**
- Minor UI bugs (can hotfix)
- Low-impact features broken
- Known issues with workarounds
- Non-critical performance degradation

### Rollback Process

**Option 1: Feature Flag Rollback (Preferred)**
1. Disable feature flag
2. Users immediately see old behavior
3. No deployment needed
4. Fix issue offline
5. Re-enable when ready

**Time: 2 minutes**

---

**Option 2: Code Rollback**
1. Identify last good deployment
2. Revert to previous version
3. Deploy previous version
4. Verify issue resolved
5. Fix forward in new deployment

**Time: 15-20 minutes**

---

**Option 3: Database Rollback (Last Resort)**
1. Stop application
2. Restore database backup
3. Deploy previous code version
4. Verify data integrity
5. Resume operations

**Time: 30-60 minutes**
**Risk: Lose recent data**

### Post-Rollback

**Immediately:**
- Notify client of issue and resolution
- Document what went wrong
- Create ticket to fix properly

**Within 24 hours:**
- Root cause analysis
- Fix issue
- Add tests to prevent recurrence
- Deploy fix

**Never blame individuals** - focus on system improvements.

---

## Quality Gates

### Pre-Deployment Checklist

**Automated (must pass):**
- [ ] All unit tests passing
- [ ] All integration tests passing
- [ ] Code coverage >80%
- [ ] No architectural violations (ArchUnit)
- [ ] No security vulnerabilities
- [ ] Linting passes
- [ ] Performance tests pass

**Manual (must verify):**
- [ ] Code review approved by senior
- [ ] Testing on staging completed
- [ ] Key user flows work
- [ ] No console errors
- [ ] Responsive on mobile
- [ ] Acceptance criteria met

**Documentation:**
- [ ] CHANGELOG updated
- [ ] Release notes drafted
- [ ] Client notification prepared
- [ ] Rollback plan ready

### Deployment Approval

**Staging deployments:** Automatic (no approval needed)

**Production deployments:** Require approval from:
- Senior developer who reviewed code
- PM who validated on staging
- Technical lead (if major change)

**Approval criteria:**
- Confident in quality
- Staging validation successful
- Client expectations aligned
- Team ready to monitor

---

## Monitoring & Metrics

### What to Monitor

**During deployment:**
- Error rates
- Response times
- CPU/memory usage
- Database connections
- Queue depths

**After deployment:**
- User activity (increased/decreased?)
- Feature usage
- Conversion rates
- Error logs
- User feedback

### Alert Thresholds

**Immediate alerts:**
- Error rate >2% (normal <0.5%)
- Response time >3s (normal <1s)
- Server CPU >90%
- Database errors
- Payment failures

**Warning alerts:**
- Error rate >1%
- Response time >2s
- Memory usage increasing
- Queue backlog growing

### Tools

**Application monitoring:**
- Sentry (error tracking)
- New Relic (performance)
- Datadog (infrastructure)

**User analytics:**
- Google Analytics
- Mixpanel
- Custom dashboard

**Logs:**
- Centralized logging (ELK, Papertrail)
- Structured JSON logs
- Searchable by request ID

---

## Release Communication

### Client Communication

**Before release:**
```
Subject: Deployment scheduled for [Date]

Hi [Client],

We're deploying the following updates to production on [Date] at [Time]:

Features:
- [Feature 1] - [Brief description]
- [Feature 2] - [Brief description]

Bug fixes:
- [Fix 1]
- [Fix 2]

Estimated downtime: None (or X minutes)

We'll monitor closely and notify you of any issues.

Thanks,
[Team]
```

**After successful release:**
```
Subject: Production deployment complete

Hi [Client],

Deployment successful! All new features are live:

✅ [Feature 1]
✅ [Feature 2]

Everything is running smoothly. Let us know if you notice anything unusual.

Release notes: [Link]

Thanks,
[Team]
```

**If issues occur:**
```
Subject: Production issue - being addressed

Hi [Client],

We've identified an issue with [Feature] that's affecting [Impact].

Current status: [Investigating/Fixing/Rolled back]
Expected resolution: [Time estimate]

We'll keep you updated every [30 minutes].

Thanks,
[Team]
```

---

## Common Challenges

### Challenge 1: Fear of Deploying

**Problem:** Team afraid to deploy because of past issues.

**Solution:**
- Improve automated testing
- Practice deployments more frequently
- Build confidence through success
- Better rollback procedures
- Post-mortems that don't blame

### Challenge 2: Slow Deployments

**Problem:** Deployment takes hours, blocking work.

**Solution:**
- Optimize build process
- Parallelize tests
- Improve infrastructure
- Automate manual steps
- Better caching

### Challenge 3: Client Resistance

**Problem:** Client wants to approve every deployment.

**Response:**
> "Frequent small releases are safer than infrequent large releases. 
> We'll deploy to staging first, you can test there. Production deployments 
> happen on predictable schedule. We'll notify you but won't need approval 
> for every change."

### Challenge 4: Accumulating Flags

**Problem:** Feature flags everywhere, code confusing.

**Solution:**
- Flag cleanup sprint every quarter
- Rule: Remove flag within 2 weeks of 100% rollout
- Track flag age
- Alert when flags >30 days old

---

## Success Metrics

**Good release process when:**
- Deployments happen on schedule
- <1% of releases rolled back
- Mean time to recovery <1 hour
- Team confident deploying
- Client rarely surprised
- Minimal manual intervention

---

## Remember

**Frequent releases build trust.**

Clients see consistent progress. Team stays focused on small, valuable increments. Problems found early when they're small. Quality improves through continuous feedback.

**Shipping is a feature.**

The best code is code in production being used. Everything else is work-in-progress. Get it shipped, get feedback, improve.

---

*Related: [CI/CD Setup](enforcement-setup.md) | [Planning Game](planning-game.md) | [Testing Standards](development-system.md)*
