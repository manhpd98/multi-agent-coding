# Example: Refactor Code

A complete walkthrough of using AI Pilot to refactor a massive ViewController into MVVM, with actual code diffs and metrics.

## Scenario

`HomeViewController.swift` is 800+ lines with business logic, networking, and UI code all mixed together. It's hard to test and hard to maintain.

---

## Step 1: User Request

> _"Refactor HomeViewController to use MVVM — delegate to Claude Code"_

## Step 2: Pilot Analyzes

Antigravity reads the file and maps out the problems:

```bash
$ wc -l Sources/Views/HomeViewController.swift
     812 Sources/Views/HomeViewController.swift

$ grep -n "func " Sources/Views/HomeViewController.swift
24:  func viewDidLoad()
48:  func setupUI()
120: func fetchUserData()        # ← Business logic in VC
180: func fetchPosts()            # ← Network call in VC
230: func updateUI()
310: func calculateStats()        # ← Business logic in VC
380: func handleRefresh()
420: func formatDate(_ date: Date)  # ← Utility in VC
```

Findings:
- **812 lines** — Way too large for a ViewController
- **Network calls** mixed with UI (lines 120-250)
- **Business logic** in VC (lines 310-500)
- **No testability** — Can't unit test without UI
- **Reference**: `ProfileViewController` (200 lines) already uses MVVM + Combine

## Step 3: Pilot Creates Plan

```
Plan (2 tasks):
1. Create HomeViewModel.swift — extract all business logic
2. Simplify HomeViewController.swift — keep only UI code, bind to ViewModel
Goal: VC goes from 812 → ~200 lines, all logic testable
```

## Step 4: Delegate Tasks

### Task 1: Create ViewModel

**Prompt sent to Claude Code:**
```
REFACTOR REQUEST — Phase 1

Goal: Extract business logic from HomeViewController into a new ViewModel.

Create NEW file: Sources/ViewModels/HomeViewModel.swift

Extract the following from HomeViewController.swift:
- fetchUserData() (line 120) → Move to ViewModel
- fetchPosts() (line 180) → Move to ViewModel
- calculateStats() (line 310) → Move to ViewModel
- formatDate() (line 420) → Move to ViewModel

Use @Published properties for reactive state:
- userData: UserModel?
- posts: [PostModel]
- isLoading: Bool
- errorMessage: String?
- stats: StatsModel?

Reference: Follow the exact same MVVM pattern in Sources/ViewModels/ProfileViewModel.swift

Constraints:
- Use Combine framework
- Use async/await for network calls
- Keep all existing functionality identical
- Don't modify HomeViewController yet (Phase 2)
```

**Code produced:**

```diff
--- /dev/null
+++ b/Sources/ViewModels/HomeViewModel.swift
@@ -0,0 +1,68 @@
+import Foundation
+import Combine
+
+@MainActor
+final class HomeViewModel: ObservableObject {
+
+    // MARK: - Published State
+    @Published private(set) var userData: UserModel?
+    @Published private(set) var posts: [PostModel] = []
+    @Published private(set) var stats: StatsModel?
+    @Published private(set) var isLoading = false
+    @Published private(set) var errorMessage: String?
+
+    // MARK: - Dependencies
+    private let apiService: APIServiceProtocol
+    private var cancellables = Set<AnyCancellable>()
+
+    init(apiService: APIServiceProtocol = APIService.shared) {
+        self.apiService = apiService
+    }
+
+    // MARK: - Data Loading
+    func loadData() async {
+        isLoading = true
+        errorMessage = nil
+
+        do {
+            async let user = apiService.fetchUser()
+            async let feed = apiService.fetchPosts()
+
+            let (fetchedUser, fetchedPosts) = try await (user, feed)
+            self.userData = fetchedUser
+            self.posts = fetchedPosts
+            self.stats = calculateStats(for: fetchedPosts)
+        } catch {
+            self.errorMessage = error.localizedDescription
+        }
+
+        isLoading = false
+    }
+
+    func refresh() async {
+        await loadData()
+    }
+
+    // MARK: - Business Logic
+    private func calculateStats(for posts: [PostModel]) -> StatsModel {
+        let totalLikes = posts.reduce(0) { $0 + $1.likes }
+        let avgLength = posts.isEmpty ? 0 :
+            posts.reduce(0) { $0 + $1.content.count } / posts.count
+        return StatsModel(
+            totalPosts: posts.count,
+            totalLikes: totalLikes,
+            averageLength: avgLength
+        )
+    }
+
+    // MARK: - Formatting
+    func formatDate(_ date: Date) -> String {
+        let formatter = DateFormatter()
+        formatter.dateStyle = .medium
+        formatter.timeStyle = .short
+        return formatter.string(from: date)
+    }
+}
```

**Pilot Review:**
- ✅ Clean MVVM structure, follows `ProfileViewModel` pattern
- ✅ `@MainActor` for thread safety
- ✅ Dependency injection via init (`APIServiceProtocol`)
- ✅ Uses `async let` for concurrent fetches — nice improvement
- ✅ `private(set)` on Published properties — prevents external mutation

---

### Task 2: Simplify ViewController

**Prompt sent to Claude Code:**
```
REFACTOR REQUEST — Phase 2

Goal: Simplify HomeViewController to only handle UI.

Update: Sources/Views/HomeViewController.swift

Changes needed:
1. Add: private let viewModel = HomeViewModel()
2. Remove: fetchUserData(), fetchPosts(), calculateStats(), formatDate()
   (these are now in HomeViewModel)
3. Remove: all local state variables (userData, posts, isLoading, etc.)
4. Add: setupBindings() method using Combine to observe viewModel's @Published
5. Update: all UI references to use viewModel properties
6. Keep: setupUI(), all IBOutlet/IBAction, layout code

Follow the same binding pattern in Sources/Views/ProfileViewController.swift.

Constraints:
- Keep ALL existing UI behavior identical
- Keep existing tests passing
- File should be ~200 lines max
```

**Code produced (simplified diff):**

```diff
--- a/Sources/Views/HomeViewController.swift
+++ b/Sources/Views/HomeViewController.swift
@@ -1,812 +1,195 @@
 import UIKit
 import Combine

 final class HomeViewController: UIViewController {

-    // MARK: - Properties (REMOVED ~30 lines of state)
-    private var userData: UserModel?
-    private var posts: [PostModel] = []
-    private var isLoading = false
-    ...
+    // MARK: - Dependencies
+    private let viewModel = HomeViewModel()
+    private var cancellables = Set<AnyCancellable>()

     // MARK: - UI Elements (kept as-is)
     @IBOutlet weak var tableView: UITableView!
     @IBOutlet weak var refreshControl: UIRefreshControl!
     @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!

     // MARK: - Lifecycle
     override func viewDidLoad() {
         super.viewDidLoad()
         setupUI()
+        setupBindings()
+        Task { await viewModel.loadData() }
-        fetchUserData()
-        fetchPosts()
     }

-    // REMOVED: fetchUserData() — 60 lines
-    // REMOVED: fetchPosts() — 50 lines
-    // REMOVED: calculateStats() — 40 lines
-    // REMOVED: formatDate() — 15 lines
-    // REMOVED: multiple helper methods — ~200 lines

+    // MARK: - Bindings (NEW)
+    private func setupBindings() {
+        viewModel.$isLoading
+            .receive(on: DispatchQueue.main)
+            .sink { [weak self] loading in
+                loading ? self?.loadingIndicator.startAnimating()
+                        : self?.loadingIndicator.stopAnimating()
+            }
+            .store(in: &cancellables)
+
+        viewModel.$posts
+            .receive(on: DispatchQueue.main)
+            .sink { [weak self] _ in
+                self?.tableView.reloadData()
+            }
+            .store(in: &cancellables)
+
+        viewModel.$errorMessage
+            .compactMap { $0 }
+            .receive(on: DispatchQueue.main)
+            .sink { [weak self] message in
+                self?.showError(message)
+            }
+            .store(in: &cancellables)
+    }

     // MARK: - Actions
     @IBAction func refreshTapped(_ sender: Any) {
-        fetchUserData()
-        fetchPosts()
+        Task { await viewModel.refresh() }
     }

     // MARK: - UI Setup (kept as-is, ~100 lines)
     ...
 }
```

**Pilot Review:**
- ✅ VC reduced from **812 → 195 lines** (76% reduction!)
- ✅ Combine bindings follow `ProfileViewController` pattern
- ✅ `[weak self]` used correctly — no retain cycles
- ✅ All UI behavior preserved
- ✅ No business logic remaining in VC

## Step 5: Pilot Tests

```bash
$ xcodebuild -scheme MyApp -sdk iphonesimulator build
** BUILD SUCCEEDED ** [15.2s]

$ xcodebuild -scheme MyApp -sdk iphonesimulator \
    -destination 'platform=iOS Simulator,name=iPhone 16' test
Test Suite 'All tests' passed.
    Executed 67 tests, with 0 failures in 8.34 seconds

$ swiftlint
No violations found.
```

✅ Build succeeds
✅ All 67 tests pass
✅ No lint violations

## Step 6: Report

> **✅ Refactored `HomeViewController` to MVVM**
>
> **Metrics:**
> | | Before | After |
> |---|---|---|
> | VC lines | 812 | 195 |
> | Testable logic | 0% | 100% |
> | Files | 1 | 2 |
> | Separation | None | Clean MVVM |
>
> **Changes:**
> - `HomeViewModel.swift` (new) — All business logic + networking
> - `HomeViewController.swift` — UI only, binds to ViewModel via Combine
>
> **Pattern:** Follows existing `ProfileViewController` + `ProfileViewModel`
>
> **Tests:** Build ✅ | 67/67 tests ✅ | Lint ✅
>
> **Time:** ~12 minutes (2 delegation rounds)

---

## Lessons Learned

1. **Order tasks by dependency** — ViewModel first, then ViewController, so both compile at each step
2. **Keep existing tests passing throughout** — Don't break things in Phase 1
3. **Reference existing patterns** — "Follow ProfileViewModel" gave Claude consistent architecture
4. **Measure before/after** — 812 → 195 lines is a compelling metric
5. **Avoid over-engineering** — MVVM was enough, no need for VIPER/TCA here
