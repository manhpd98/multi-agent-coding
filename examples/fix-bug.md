# Example: Fix a Bug

A complete walkthrough of using AI Pilot to fix a crash bug, with actual prompts, code diffs, and terminal output.

## Scenario

The app crashes with `IndexOutOfBoundsException` when the user opens the onboarding screen.

---

## Step 1: User Request

> _"Fix the crash on the onboarding screen — delegate to Claude Code"_

## Step 2: Pilot Analyzes (Antigravity)

Antigravity reads the crash log and researches the codebase:

```bash
# Pilot reads the crash log
$ grep -r "IndexOutOfBounds" app/src/ --include="*.kt"
app/src/main/java/com/app/ui/OnboardingAdapter.kt:42: layouts[position]
```

Findings:
- **Error**: `IndexOutOfBoundsException` at `OnboardingAdapter.kt:42`
- **Root cause**: `getItemCount()` returns hardcoded `4`, but `layouts` array has only `3` items
- **File**: `app/src/main/java/com/app/ui/OnboardingAdapter.kt`

## Step 3: Pilot Creates Plan

```
Plan:
1. Fix getItemCount() to return layouts.size instead of hardcoded 4
2. Add bounds check in onBindViewHolder()
3. Build and verify all onboarding screens render
```

## Step 4: Delegate to Claude Code

Antigravity sends this prompt:

```
BUG FIX REQUEST

File: app/src/main/java/com/app/ui/OnboardingAdapter.kt
Function: getItemCount() and onBindViewHolder()

Current behavior:
App crashes with IndexOutOfBoundsException at line 42.
getItemCount() returns hardcoded 4, but layouts array has only 3 items.

Expected behavior:
All onboarding screens display without crash.

Fix instructions:
1. In getItemCount(), return layouts.size instead of hardcoded 4
2. Add bounds checking in onBindViewHolder() before accessing layouts[position]
3. Don't change any other files

Constraints:
- Keep existing functionality
- Follow existing Kotlin code style
```

### Claude Code Output

```diff
--- a/app/src/main/java/com/app/ui/OnboardingAdapter.kt
+++ b/app/src/main/java/com/app/ui/OnboardingAdapter.kt
@@ -38,11 +38,14 @@
 class OnboardingAdapter(
     private val layouts: List<Int>
 ) : RecyclerView.Adapter<OnboardingAdapter.ViewHolder>() {

-    override fun getItemCount(): Int = 4
+    override fun getItemCount(): Int = layouts.size

     override fun onBindViewHolder(holder: ViewHolder, position: Int) {
-        holder.bind(layouts[position])
+        if (position in layouts.indices) {
+            holder.bind(layouts[position])
+        }
     }

     // ... rest unchanged
```

## Step 5: Pilot Reviews

Antigravity reads the modified file:

- ✅ `getItemCount()` now returns `layouts.size` — dynamic, correct
- ✅ Bounds check added with `position in layouts.indices` — idiomatic Kotlin
- ✅ Only the target file was modified
- ✅ No public API changes
- ⚠️ Minor: Could add logging for out-of-bounds case (optional)

**Verdict: Changes look good. No corrections needed.**

## Step 6: Pilot Tests

```bash
$ ./gradlew assembleDebug
BUILD SUCCESSFUL in 12s
47 actionable tasks: 3 executed, 44 up-to-date

$ ./gradlew test
> Task :app:testDebugUnitTest
Tests: 42 passed, 0 failed

BUILD SUCCESSFUL in 8s
```

✅ Build succeeds
✅ All 42 tests pass

## Step 7: Report

> **✅ Fixed `IndexOutOfBoundsException` in `OnboardingAdapter.kt`**
>
> **Root cause:** `getItemCount()` returned hardcoded `4` but only 3 layout segments existed.
>
> **Changes:**
> - `getItemCount()` → returns `layouts.size` (dynamic)
> - `onBindViewHolder()` → added bounds checking
>
> **Tests:** Build ✅ | 42/42 tests ✅
>
> **Time:** ~3 minutes

---

## Lessons Learned

1. **Hardcoded values are bugs waiting to happen** — always use dynamic sizing
2. **Specific prompts produce specific fixes** — including line numbers and function names helped Claude Code make a surgical fix
3. **One task, one delegation** — keeping the scope small made review easy
