# Complete Homework Assignment Guide

## General Task Description

Similar to the previous homework assignment, you must now merge two data tables:

- one containing **prices** (`price`)
- and the other containing **percentage-level attributes** (`features`).

Crucially, you must:

- Carefully consider and clearly state **what type of join** is necessary.
- **Describe the relationship** used to merge the data **and explain why**.
- In the resulting merged data table, **keep only the observations for which
  both price and guest rating are available**.
- Use only this **filtered subset** to solve the task.

---

## Preliminary Documentation Requirements

Before presenting the statistical analysis, you must document:

1. **The chosen city** and **the two selected days**.
2. **Total number of observations** in the prepared dataset:
   - separately for each of the two chosen days
   - and in total
3. **The exact variables** used for the analysis.
4. **Important descriptive statistics** for these variables.

> ✅ Throughout the process, everything must be **clearly documented** so that
> the analysis workflow is traceable.

---

## Part 1: Hypothesis Test Requirements

This assignment requires you to perform a hypothesis test that is
**fundamentally different from the one covered in class**.

### 🔑 Key Difference in Data Structure

| Scenario         | Data Type                                       | Test Type         |
| ---------------- | ----------------------------------------------- | ----------------- |
| In-Class Example | Paired observations (same units measured twice) | Paired t-test     |
| Current Homework | Two **independent** samples (Day 1 vs. Day 2)   | Two-sample t-test |

---

### ✅ Required Steps

Since you are analyzing two separate groups (**Day 1** and **Day 2**), you must
slightly restructure your dataset before running the t-test in R.

#### 1. Create a Group Variable

- Create a new categorical variable, e.g. `group`.
- It must take **exactly two distinct values** (e.g. `0` and `1`, or `"Day1"`
  and `"Day2"`).
- Assign:
  - one value to all observations from **Day 1**
  - the other value to all observations from **Day 2**

This variable identifies which group each observation belongs to.

#### 2. Perform the Hypothesis Test in R

- You will test the **equality of means** between the two groups (Day 1 vs. Day 2).
- The test can be for:
  - **average price**, or
  - **average guest rating**
- You **must** use the **formula interface** of `t.test` in R.

---

### ✅ Required R Command Syntax

```r
t.test(price ~ group, data = data)
```
