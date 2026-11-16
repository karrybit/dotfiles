// Usage: node shoot.mjs <page.html> <out-dir>
// Opens the page in headless Chrome at 1280x900 with reduced motion and
// scroll-behavior: auto, opens every <details>, and saves one screenshot per
// scroll step as screen-NN.png. Exits non-zero when a step does not land at
// its scroll position, so a page that scrolls smoothly cannot be shot halfway.
import { spawn } from 'node:child_process';
import { mkdtempSync, readFileSync, writeFileSync, existsSync, mkdirSync, rmSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join, resolve } from 'node:path';

const [page, outDir] = process.argv.slice(2);
if (!page || !outDir) { console.error('usage: shoot.mjs <page.html> <out-dir>'); process.exit(2); }
const CHROME = process.env.CHROME || '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
const W = 1280, H = 900, STEP = 800;

const profile = mkdtempSync(join(tmpdir(), 'shoot-'));
const chrome = spawn(CHROME, ['--headless=new', '--remote-debugging-port=0', `--user-data-dir=${profile}`,
  '--no-first-run', '--hide-scrollbars', 'about:blank'], { stdio: 'ignore' });
const sleep = (ms) => new Promise((r) => setTimeout(r, ms));
try {
  const portFile = join(profile, 'DevToolsActivePort');
  for (let i = 0; !existsSync(portFile); i++) { if (i > 100) throw new Error('Chrome did not start'); await sleep(100); }
  const port = readFileSync(portFile, 'utf8').split('\n')[0];
  const target = (await (await fetch(`http://127.0.0.1:${port}/json/list`)).json()).find((t) => t.type === 'page');
  const ws = new WebSocket(target.webSocketDebuggerUrl);
  await new Promise((r, j) => { ws.onopen = r; ws.onerror = j; });
  let id = 0; const pending = new Map(); const events = [];
  ws.onmessage = (m) => { const d = JSON.parse(m.data); if (d.id) { pending.get(d.id)(d); pending.delete(d.id); } else events.push(d.method); };
  const send = (method, params = {}) => new Promise((r, j) => { const n = ++id; pending.set(n, (d) => d.error ? j(new Error(d.error.message)) : r(d.result)); ws.send(JSON.stringify({ id: n, method, params })); });
  const evaluate = async (expression) => (await send('Runtime.evaluate', { expression, awaitPromise: true, returnByValue: true })).result.value;

  await send('Page.enable');
  await send('Emulation.setDeviceMetricsOverride', { width: W, height: H, deviceScaleFactor: 1, mobile: false });
  await send('Emulation.setEmulatedMedia', { features: [{ name: 'prefers-reduced-motion', value: 'reduce' }] });
  await send('Page.navigate', { url: 'file://' + resolve(page) });
  for (let i = 0; !events.includes('Page.loadEventFired'); i++) { if (i > 300) throw new Error('page did not load'); await sleep(100); }
  const height = await evaluate(`document.querySelectorAll('details').forEach((d) => { d.open = true; });
    const s = document.createElement('style'); s.textContent = '* { scroll-behavior: auto !important; }'; document.head.append(s);
    new Promise((r) => requestAnimationFrame(() => r(document.documentElement.scrollHeight)))`);
  mkdirSync(outDir, { recursive: true });
  let n = 0;
  for (let y = 0; y === 0 || y < height - H + STEP; y += STEP) {
    const at = await evaluate(`window.scrollTo(0, ${y}); new Promise((r) => requestAnimationFrame(() => requestAnimationFrame(() => r(window.scrollY))))`);
    const want = Math.max(0, Math.min(y, height - H));
    if (Math.abs(at - want) > 1) throw new Error(`step ${n + 1} is at scrollY ${at}, not ${want}`);
    const { data } = await send('Page.captureScreenshot', { format: 'png' });
    writeFileSync(join(outDir, `screen-${String(++n).padStart(2, '0')}.png`), Buffer.from(data, 'base64'));
  }
  console.log(`${n} screens, page height ${height}px`);
  ws.close();
} finally {
  chrome.kill();
  await sleep(300);
  rmSync(profile, { recursive: true, force: true });
}
