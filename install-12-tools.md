# مهمة: تثبيت 12 أداة على جهاز ويندوز ده (Hegazy-PC)

انسخ النص كله وحطه في Claude Code شغال على جهازك (من PowerShell اكتب `claude` داخل مجلد عادي، مثلا `C:\Tools-Setup`).

---

أنت شغال على جهاز ويندوز بتاعي أنا. نفذ التثبيت بالترتيب، وتحقق من كل أداة بعد تثبيتها. كلمني بالمصري. في الآخر اكتب سطر واحد لكل أداة: PASS أو FAIL، ومعاه الدليل (ناتج أمر التحقق). ممنوع تقول إن حاجة اتثبتت من غير ما تتحقق منها.

## قواعد

- ممنوع أي `curl ... | bash` أو `irm ... | iex`. لو الأداة مسارها الوحيد سكريبت بعيد، نزله في ملف، اقرأه، قولي بيعمل إيه، وبعدين شغله.
- لو أي شيء ناقص (Node أو Git أو claude)، قولي واسألني قبل ما تنزله.
- لو حاجة فشلت، اعرض الخطأ بنصه واقترح علاج. ما تعيدش المحاولة عشوائيا.
- لو أمر `claude plugin ...` مش متاح في نسخة الـ CLI، اطبع لي أسطر `/plugin marketplace add` و`/plugin install` للصق، وقولي مين لسه معلق.

## الخطوة 0: فحص المتطلبات

شغل وأعرض النتيجة:

```powershell
node -v
npm -v
git --version
claude --version
Get-Command bash | Format-List Source
```

- المطلوب: Node.js LTS (والأفضل 20.9 أو أحدث، لأن Pake محتاجه)، وGit for Windows، وClaude Code CLI.
- لو `bash` طلع `C:\WINDOWS\System32\bash.exe` فده launcher بتاع WSL مش Git Bash. نبهني (مهم لـ career-ops).

## المرحلة 1

### 1) last30days (plugin)

ثبته عن طريق الـ plugin فقط. ممنوع `npx skills` معاه، لأن `/last30days` هيظهر مرتين.

```powershell
claude plugin marketplace add mvanhorn/last30days-skill
claude plugin install last30days@last30days-skill
```

### 2) ai-memory

المصدر: https://github.com/akitaonrails/ai-memory

اتقرأ سكريبت `install.ps1` وطلع سليم (بيتحقق من SHA-256 ومبيحتاجش أدمن). برضه نزله في ملف واقراه بنفسك وقولي ملخص، وبعدين شغله:

```powershell
Invoke-WebRequest https://github.com/akitaonrails/ai-memory/releases/latest/download/install.ps1 -OutFile "$env:TEMP\ai-memory-install.ps1"
Get-Content "$env:TEMP\ai-memory-install.ps1"
# بعد ما تعرضه عليا وأوافق:
& "$env:TEMP\ai-memory-install.ps1"
ai-memory setup
ai-memory --version
```

- اسألني الأول: Claude Code عندي بيشتغل على ويندوز native ولا داخل WSL2؟ لازم ثبت في نفس البيئة. ولو WSL2، اتبع docs/windows.md (Scenario A).
- قولي إن ويندوز native معلّم تجريبي (experimental) وإن WSL2 هو المسار المدعوم رسميا.
- بديل Scoop يحتاج ai-memory 3.4.0 أو أحدث.
- لو المسار فشل، اقرأ docs/windows.md وارجعلي.
- ماتعملش Scheduled Task بـ Start-Process للسيرفر، لأن بيتقتل بصمت بعد الريبوت.

### 3) productivity

ثبت الـ plugin ده فقط من الـ 14 اللي في الـ repo:

```powershell
claude plugin marketplace add anthropics/knowledge-work-plugins
claude plugin install productivity@knowledge-work-plugins
```

بعد المرحلة 1: شغل `claude plugin list` وأعرضه عليا قبل ما تكمل.

## المرحلة 2

### 4) Understand-Anything

ماتستخدمش `install.sh | bash`.

```powershell
claude plugin marketplace add Egonex-AI/Understand-Anything
claude plugin install understand-anything@understand-anything
```

### 5) claude-seo

```powershell
claude plugin marketplace add AgriciDaniel/claude-seo
claude plugin install claude-seo@agricidaniel-claude-seo
```

### 6) scroll-craft

```powershell
claude plugin marketplace add nateherkai/scroll-craft
claude plugin install nateherk-design@nateherk
```

### 7) oh-my-claudecode (ثبته آخر plugin)

حذرني الأول: بيضيف عشرات الـ agents والـ hooks ويزود استهلاك الـ context. استنى موافقتي.

```powershell
claude plugin marketplace add https://github.com/Yeachan-Heo/oh-my-claudecode
claude plugin install oh-my-claudecode@omc
```

حزمة npm اسمها `oh-my-claude-sisyphus`، وتلزم فقط لو عايز أمر `omc` في الطرفية. ماتثبتهاش إلا لو قلتلك.

### 8) Pake

قولي المتطلبات الأول، وبعدين اسألني قبل ما تكمل:

- Node 20.9.0 أو أحدث.
- Rust 1.85.0 أو أحدث.
- على ويندوز الافتراضي: Visual Studio Build Tools مع workload اسمه "Desktop development with C++". البديل `gnu` محتاج MSYS2 مع gcc وld وdlltool.
- الرخصة GPL v3.
- لو بس عايز تطبيقات جاهزة بدون بناء، فيه تطبيق desktop منفصل من pake.run.

```powershell
npm i -g pake-cli
pake --version
```

### 9) promptfoo

```powershell
npm i -g promptfoo
promptfoo --version
```

### 10) career-ops

اسألني أنا عايز المجلد فين (لا تختار انت). وبعدين:

```powershell
npx @santifer/career-ops init
```

- المصدر الفعلي: github.com/santifer/career-ops (رخصة MIT). الأمر مش بيعتمد على اسم الـ repo.
- اقرأ docs/WINDOWS.md. لو `bash` على الـ PATH هو WSL، فاستخدم Git Bash بمساره الكامل (`C:\Program Files\Git\bin\bash.exe`).
- بعدها شغل `node doctor.mjs --json` وأعرض النتيجة، ولو PDF مطلوب: `npx playwright install chromium`.
- تأكد إن المجلد اتعمل فعلا.

### 11) Claude-Code-Game-Studios

اسألني على المجلد، وبعدين:

```powershell
git clone https://github.com/Donchitos/Claude-Code-Game-Studios.git my-game
```

- ده template مش أداة. بعد الـ clone أفتح Claude Code جواه وأكتب `/prototype <فكرة>` أو `/start`.
- محتاج Chrome أو Edge أو Chromium عشان `/prototype` يشغل ويصور اللعبة.

### 12) Karpathy guidelines

اتحقق: الـ repoين `multica-ai/andrej-karpathy-skills` و`forrestchang/andrej-karpathy-skills` نفس الـ commit (`2c60614`) ونفس التاريخ. الأصل المعتمد في الـ README هو forrestchang. مفيش LICENSE في أي منهم، لكن plugin.json بيعلن MIT. نزل من forrestchang:

```powershell
claude plugin marketplace add forrestchang/andrej-karpathy-skills
claude plugin install andrej-karpathy-skills@karpathy-skills
```

البديل: لو أنا فضلت أضيف الـ CLAUDE.md لمشروع بدل الـ plugin، قولي وهنزله في المشروع اللي أحدده.

## التحقق النهائي (لازم يتعمل كله)

```powershell
claude plugin list
pake --version
promptfoo --version
ai-memory --version
Test-Path "<مجلد career-ops>"
Test-Path "<مجلد my-game>"
```

اكتب في الآخر جدول: أداة | PASS/FAIL | الدليل | ملاحظة. وأي FAIL معاه الخطأ بنصه وعلاج مقترح.

## معلومات مهمة

- أرقام النجوم اللي في البوست (مثل 232k للـ Karpathy) لسه غير متحقق منها.
- الرخص: MIT لمعظمهم، Apache 2.0 لـ knowledge-work-plugins، GPL v3 لـ Pake.
