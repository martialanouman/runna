---
name: code-review
description: Code review skill for the Runna project. Use after completing any task, feature, or before merging. Extends the standard code review with grammar/spelling checks on user-facing text and code comments, and enforces React Native + Expo best practices. Trigger whenever code changes are ready for review, when you finish implementing a feature, or when the user asks to "review", "vérifier", "relire" or "check" the code.
---

# Code Review — Runna Project

Performs a thorough review of code changes covering:
1. Standard code quality (based on `requesting-code-review`)
2. Grammar and spelling in user-facing strings and comments
3. React Native and Expo best practices

## How to Request

**1. Get git SHAs:**
```bash
BASE_SHA=$(git rev-parse origin/main)  # or a specific commit
HEAD_SHA=$(git rev-parse HEAD)
```

**2. Run the review** using the checklist below against the diff:
```bash
git diff --stat $BASE_SHA..$HEAD_SHA
git diff $BASE_SHA..$HEAD_SHA
```

**3. Act on findings:**
- Fix Critical issues immediately before anything else
- Fix Important issues before moving to the next task
- Log Minor issues for a cleanup pass

---

## Review Checklist

### 1. Code Quality (from requesting-code-review)

**Correctness:**
- Logic is sound and matches requirements?
- Edge cases handled (empty arrays, null, undefined)?
- Async flows awaited properly, no unhandled promises?
- Error states surfaced to the user (not silently swallowed)?

**Clean Code:**
- No dead code or commented-out blocks left behind?
- DRY — no copy-pasted logic that belongs in a shared helper?
- Types are accurate (no `any` casts that hide real types)?
- No hardcoded secrets, API keys, or magic numbers without constants?

**Tests (when applicable):**
- New logic covered by tests?
- Tests assert behavior, not implementation details?
- No tests that trivially always pass?

---

### 2. Grammar & Spelling

Check every user-visible string and every code comment for correct French (primary language) and English (fallback / dev comments).

**User-facing strings (French):**
- Accents correct: `é è ê ë à â ù û ü ç ô î ï`?
- No false cognates or anglicisms when a proper French term exists?
- Consistent tu/vous register throughout?
- Punctuation: space before `:` `!` `?` `;` in French?
- No truncated or placeholder strings left in (`TODO:`, `XXX`, `lorem ipsum`)?

**Code comments (French or English, whichever is used consistently in the file):**
- No spelling mistakes?
- Sentences make sense in context?
- Comments explain *why*, not just *what*?

**Report format for language issues:**
```
File:line — [Incorrect] → [Corrected] (reason)
```

---

### 3. React Native Best Practices

**Layout & Styling:**
- Inline styles are consistent with the project convention (project uses inline styles — no StyleSheet.create required)?
- No pixel values that should use the design scale (`width: 375` for full-screen = bad)?
- `flex: 1` on screens so they fill available space?
- Keyboard avoiding handled where text inputs are present (`KeyboardAvoidingView` or `KeyboardAwareScrollView`)?

**Lists:**
- Long or dynamic lists use `FlatList` / `SectionList`, not `ScrollView` with `.map()`?
- `keyExtractor` provided on list components?
- `getItemLayout` provided for fixed-height items (performance)?
- Empty state (`ListEmptyComponent`) defined?

**Images:**
- `resizeMode` specified on `<Image>` components?
- Remote images have fallback/placeholder?

**Accessibility:**
- Interactive elements have `accessibilityLabel` or `accessibilityHint`?
- `accessibilityRole` set where appropriate (button, link, header)?
- Touch targets are at least 44×44 pt?

**Platform:**
- Platform-specific code uses `Platform.OS === 'ios'` / `'android'`, not user-agent sniffing?
- Shadow props use correct API (`shadow*` on iOS, `elevation` on Android)?

**Performance:**
- Callbacks passed to child components wrapped in `useCallback` where needed?
- Expensive computations wrapped in `useMemo`?
- No inline function or object literals in JSX props on components that re-render often?
- Images not re-loaded on every render (stable URI references)?

**State management:**
- Local state stays local; only shared state lifted up?
- No unnecessary `useEffect` where derived state or event handlers would do?

---

### 4. Expo & Expo Router Best Practices

**Expo Router:**
- File-based routes follow the `app/` directory convention?
- `<Stack>`, `<Tabs>`, `<Drawer>` used from `expo-router`, not `@react-navigation/*` directly?
- `useRouter()` / `<Link>` used for navigation, not manual `navigation.navigate()`?
- Route params typed with `useLocalSearchParams<{ id: string }>()`?
- Loading states handled (Suspense or `expo-router` `+not-found` / `+error` screens)?

**Safe Area:**
- `SafeAreaView` from `react-native-safe-area-context` used (not core RN)?
- `useSafeAreaInsets()` used for custom layouts instead of hardcoded status bar heights?

**Expo APIs:**
- `expo-secure-store` used for sensitive data, not `AsyncStorage`?
- `expo-image` preferred over core `<Image>` for remote images (caching, blurhash)?
- Permissions requested at the right moment (not on app launch)?

**Environment / Config:**
- Env vars accessed via `process.env.EXPO_PUBLIC_*` for public values?
- No secrets in client-side code (they go in server-side Edge Functions)?

**Build / EAS:**
- No native module added without updating `app.json` plugins array?

---

## Output Format

### Strengths
[Specific things done well — cite file:line]

### Issues

#### Critical (Must Fix)
[Bugs, data loss, broken navigation, security issues]

#### Important (Should Fix Before Next Task)
[Missing best practices, language errors in primary UI strings, performance pitfalls]

#### Minor (Nice to Have)
[Style nits, optimisation opportunities, comment improvements]

**For each issue:** `File:line — what's wrong — why it matters — how to fix`

### Language Report
[All spelling/grammar findings using the `File:line — [wrong] → [correct]` format]

### Assessment

**Ready to proceed?** [Yes / Yes with fixes / No]

**Reasoning:** [1–2 sentences]

---

## Critical Rules

- Severity must reflect actual impact — not every imperfection is Critical
- Be specific: cite file and line number, not vague area
- Explain *why* an issue matters, not just that it's wrong
- Acknowledge what works well — not everything is a problem
- Give a clear, unambiguous verdict
