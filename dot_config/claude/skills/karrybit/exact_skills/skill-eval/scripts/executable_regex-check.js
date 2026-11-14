#!/usr/bin/env node
// Usage: regex-check.js GRADER.md FILE
// Applies a Plugin Evals regex grader (pattern, flags, match) to FILE and prints pass/fail.
const fs = require("fs");
const [grader, file] = process.argv.slice(2);
const fm = fs.readFileSync(grader, "utf8").split(/^---$/m)[1];
const { execFileSync } = require("child_process");
const cfg = JSON.parse(execFileSync("yq", ["-o=json", "."], { input: fm }));
const text = fs.readFileSync(file, "utf8");
const n = (text.match(new RegExp(cfg.pattern, (cfg.flags || "") + "g")) || []).length;
const m = cfg.match || "contains";
const pass = m === "contains" ? n > 0 : m === "not_contains" ? n === 0 : n === Number(m.split(":")[1]);
console.log(`${pass ? "PASS" : "FAIL"} ${grader.split("/").slice(-1)[0]} (matches=${n}, match=${m})`);
