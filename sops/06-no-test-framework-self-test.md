# 06 — 无测试框架时的 .mjs 自测脚本

> 项目没装 jest / vitest / mocha，但需要给纯数学 helper / 公式 / 边界条件加自动化验证。

## 为什么不直接装个测试框架

很多个人项目（特别是 Next.js / vibe-coding 风格）会刻意不装：

- jest 跟 Next 14 集成要装一堆 `@types/jest` / `babel-jest` / `ts-jest`
- vitest 装起来简单但要写 `vitest.config.ts` + 改 `tsconfig`
- 单元测试本身在小项目里 ROI 不高，集成测试更重要

但完全没测试也不行：纯数学公式（线性插值 / BigInt 取整 / 边界处理）出 bug，**集成测试照样过，影响是隐藏的数值偏差**。

**折中方案**：写一个独立 `.mjs` 脚本 + Node 内置 `assert` + 公式手动复刻。

## 步骤

### 1. 在 `scripts/test-<feature>.mjs` 新建

```js
// <feature> 数学验证
// 跑：node scripts/test-<feature>.mjs
//
// 公式按 lib/<source>.ts **手动复刻在本脚本**（项目无 jest/vitest）
// INVARIANT：改 .ts 公式必同步改本脚本
```

### 2. 内置 assert / step helper

```js
function assert(cond, msg) {
  if (!cond) {
    console.error(`  ✗ ${msg}`)
    throw new Error(`ASSERTION FAILED: ${msg}`)
  }
  console.log(`  ✓ ${msg}`)
}

function step(name, fn) {
  console.log(`\n[${name}]`)
  fn()
}
```

### 3. 公式复刻

把 `.ts` 里的纯函数原样抄一份到 .mjs（**不 import**，因为 .mjs 不能 import .ts 而不上 ts-node）。每个复刻函数上方注释 `// 复刻自 lib/<file>.ts:<line>`。

### 4. 断言按"边界值表"覆盖

- 0 / 上界 / 下界 / 中间一个 / 越界
- 正 / 零 / 负
- hard cap 触发点 / 接近 cap 未触发点

### 5. 在 `.ts` 源文件顶部注释加 INVARIANT 提醒

```ts
// 配套测试：scripts/test-<feature>.mjs（公式手动复刻，改公式必同步两边）
```

### 6. 跑

```bash
node scripts/test-<feature>.mjs
```

退出码 ≠ 0 = 失败。

## 容易忘的细节

- **BigInt 在 .mjs 里直接 `123n` 可用**，不用 import。Number assert 时用 `===` 严格相等（BigInt vs Number 直接 `===` 会 false）
- **不要 import `.ts`** —— 会报 `unknown file extension`。如果想 import，要装 `tsx` 或 `ts-node` ESM loader，那还不如直接装 vitest
- **`process.exit(1)` 是 assert 抛错后自动**（throw 没 catch 时 exit code 1）
- **公式复刻后双方易漂移**：源文件改了忘改测试 → 测试通过但实际公式已坏。**唯一防漂移手段是 .ts 源文件顶部明确 INVARIANT 注释**（用户 grep "INVARIANT" 时立刻看到）
- **不要装 jest 来替代这个**：转换成本远高于复刻一次公式的成本

## 不要做什么

- 把测试脚本写成 .ts（要装额外依赖）
- 在 .mjs 测试里 `import` 项目 `.ts` 代码绕过复刻（不可行，且即使绕过也会引入 prisma client 等重量级依赖）
- 把这个模式用于集成测试（用 prisma 真连库的测试）—— 集成测试该用专门的脚本，但**它跟纯数学验证混在一起就乱了**
- 省略 INVARIANT 注释 —— 下一次改代码的 Agent 不知道有测试要同步，公式漂移就出问题
- 把 .mjs 当成代替集成测试 —— 只测纯函数 / 公式 / 边界。涉及 DB / API / UI 的逻辑必须用真集成测试

## 模板（直接复制改）

```js
// <feature> 数学验证
// 跑：node scripts/test-<feature>.mjs
//
// 测的是 lib/<source>.ts 的 <funcA> / <funcB>。
// 公式按 .ts 源文件 **手动复刻在本脚本**（项目无 jest/vitest）。
// INVARIANT：改 .ts 公式必同步改本脚本。

function assert(cond, msg) {
  if (!cond) { console.error(`  ✗ ${msg}`); throw new Error(`ASSERTION FAILED: ${msg}`) }
  console.log(`  ✓ ${msg}`)
}

function step(name, fn) { console.log(`\n[${name}]`); fn() }

// === 复刻 lib/<source>.ts ===

// 复刻自 lib/<source>.ts:<line>
function funcA(x, y) {
  // ... 跟 .ts 源完全一致
}

// === 测试 ===

step('边界值', () => {
  assert(funcA(0n, 1n) === 0n, '0 输入 → 0 输出')
  // ...
})

console.log('\n=== ALL CHECKS PASSED ===')
```

## 修订记录

- 2026-05-16：把"独立 .mjs + 手动复刻 + INVARIANT 注释"的自测套路凝成可复制模板。
