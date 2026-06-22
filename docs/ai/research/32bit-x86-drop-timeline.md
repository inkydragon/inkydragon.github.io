# When Software Dropped 32-bit x86 (i386) Support

A comprehensive timeline across operating systems, programming languages, and numerical computing software.

---

## Summary of Key Trends

**The decade of decline: 2015--2025.** 32-bit x86 support eroded in three overlapping waves:

1. **Server and low-level shift (2008--2015).** Windows Server (2008 R2, 2009) and RHEL (2014) led the server-side transition. ANSYS and MATLAB cut Linux 32-bit early (2012). ARM-driven mobile and embedded kept some 32-bit targets alive, but those were ARM (armv7), not x86.

2. **Desktop OS tipping point (2018--2025).** Ubuntu (2018/2019), Arch (2017), Fedora (2019), macOS Catalina (2019), and Windows 11 (2021) ended the era where a consumer could buy or install a current, supported 32-bit desktop OS. Windows 10 end-of-support (October 14, 2025) was the symbolic final bell.

3. **Ecosystem cascade (2020--2025).** Once OS vendors and toolchain maintainers stopped testing on 32-bit, downstream software followed: R dropped 32-bit Windows (2022), SciPy dropped 32-bit wheels (2022), Java removed 32-bit entirely (2023--2025), GROMACS removed it (2022), and LAMMPS followed (2025). The critical domino was SciPy 1.9.2 (October 2022), which triggered scikit-learn and Pandas to drop 32-bit within months.

**What remains.** As of mid-2026, 32-bit x86 survives in two niches:
- **Software that hasn't needed to care yet** -- Ruby, GCC, LLVM, OpenBLAS, LAPACK, Quantum ESPRESSO, .NET, and NumPy still support 32-bit at the source or binary level. PHP is debating removal with no vote yet.
- **Deliberate holdouts** -- NetBSD keeps i386 at Tier I. Slackware, Void Linux, Alpine, MX Linux, antiX, and Puppy Linux actively ship 32-bit distro releases. Gentoo still supports it (under debate). Rust and Go still have Tier 1 and Tier 2 `linux/386` targets, respectively.

**Key milestone years:**
| Year | Significance |
|------|-------------|
| 2009 | Windows Server 2008 R2: first 64-bit-only Server; first major OS line to drop 32-bit |
| 2012 | Linux kernel drops original 80386; MATLAB drops Linux 32-bit; OS X kernel goes 64-bit only |
| 2014 | RHEL 7 64-bit only; DragonFly BSD 4.0 64-bit only |
| 2017 | Arch Linux drops i686 |
| 2018 | Mathematica 11.3 drops 32-bit Windows |
| 2019 | macOS Catalina drops 32-bit apps; Ubuntu drops i386 repo; Fedora drops 32-bit kernel; Stata 16 64-bit only |
| 2020 | Windows 10 v2004 stops 32-bit OEM builds; SPSS 27, Origin 2020, Maple 2021 drop 32-bit |
| 2021 | Windows 11: no 32-bit edition |
| 2022 | R 4.2, SciPy 1.9.2, scikit-learn 1.1.3, GROMACS 2022 drop 32-bit |
| 2023 | Java JDK 23 removes Windows 32-bit; Pandas 2.1 drops win32; Octave 8.4 drops 32-bit binaries |
| 2025 | Debian 13, FreeBSD 15.0 drop i386; JDK 25 removes Linux 32-bit; Windows 10 EOL; LAMMPS drops 32-bit; openSUSE Leap 16 defaults to no-32-bit |

---

## Flagged Inconsistencies and Limitations

- **Mint LMDE version numbering.** The research mentions "LMDE 7 Gigi (2025)" but LMDE numbering lags Debian; confirm whether LMDE 7 dropped 32-bit alongside Debian 13 or made an independent decision. The data says LMDE 6 (based on Debian 12) was the last 32-bit LMDE, which is consistent.
- **GROMACS version years.** GROMACS 2020 was *released* in 2020 and deprecated 32-bit; GROMACS 2022 *removed* it (released ~January 2022). The dates align with their version numbers.
- **LAMMPS removal date.** The PR (#4500) was merged March 17, 2025, into the `develop` branch. The stable release `stable_22Jul2025_update3` (July 2025) still predates this merge, so the first 64-bit-only stable release is the one *after* that. The research notes this correctly.
- **SAS on Windows.** SAS never made a clean version cut for 32-bit Windows. Different university distribution portals show different policies. The research is vague because the official policy is genuinely vague -- SAS 9.4 still *technically* lists 32-bit Windows in its support matrix through M7+ but it's effectively deprecated in practice. This is not an error in the research; it reflects the real ambiguity.
- **LLVM and Debian i386.** The research correctly identifies the tension: upstream LLVM assumes SSE2 on i686, but Debian patches LLVM to support a no-MMX/no-SSE x87 baseline, which upstream considers unsound. This is not inconsistent research -- it documents a real divergence between upstream and Debian's patched baseline.
- **Python 32-bit Windows installers.** One agent initially found conflicting claims that Python 3.12 removed 32-bit Windows installers. Cross-referencing with actual python.org download pages shows this is false: 32-bit Windows remains Tier 1. The agent correctly identified several things that are commonly conflated (minimum Windows version bump, installer format changes, source-only EOL releases).

---

## I. Operating Systems

### 1.1 Linux Distributions

#### Arch Linux
- **Dropped:** November 2017 (announced January 25, 2017)
- **Last ISO:** March 1, 2017
- **Status:** Community fork **Arch Linux 32** continues independently. The `[multilib]` repo (32-bit libs on 64-bit systems) was unaffected.
- **Reference:** archlinux.org/news/phasing-out-i686-support

#### RHEL / CentOS
- **Dropped:** RHEL 7 (June 2014)
- **Last version with 32-bit:** RHEL 6
- **Status:** All RHEL 7+ (including 8, 9, 10) are 64-bit only. RHEL 9 additionally requires x86-64-v2; RHEL 10 will require x86-64-v3.
- **Reference:** Red Hat customer portal documentation

#### Ubuntu
- **Dropped:** 32-bit install ISO at 18.10 (October 2018); full i386 package repo at 19.10 (October 2019)
- **Last LTS with full 32-bit:** Ubuntu 18.04 LTS
- **Status:** After community backlash (Steam/Wine/gaming), Canonical partially reversed course. Selected i386 multilib packages continue to be built, frozen at 18.04 library versions.
- **Reference:** lists.ubuntu.com (June 2019 announcement)

#### Fedora
- **Dropped:** Fedora 31 (October 2019) -- kernel and bootable install images
- **Status:** Fedora 27 (2017) moved i686 to community-support status. Multilib 32-bit packages still exist on 64-bit systems. A 2025 proposal (Fedora 44) to drop multilib entirely was withdrawn after pushback, deferred to Fedora 46 or later.
- **Reference:** fedoramagazine.org (2019)

#### openSUSE
- **Dropped:** Leap 16.0 (October 2025) -- 32-bit execution disabled by default in kernel
- **Status:** Users can manually re-enable via `grub2-compat-ia32` and kernel parameter `ia32_emulation=1`. Tumbleweed (rolling) still supports i686+SSE2. openSUSE never supported true i386 -- historical minimum was i586.

#### Debian
- **Dropped:** Debian 13 "Trixie" (August 2025) -- no longer a standalone installation architecture
- **Last full 32-bit release:** Debian 12 "Bookworm" (2023)
- **Status:** i386 remains available as a multiarch secondary architecture for running 32-bit apps on amd64 systems (libraries, chroots, containers). Debian 9 "Stretch" (2017) raised minimum CPU to i686.
- **Reference:** debian.org release notes

#### Linux Mint
- **Dropped:** Mainstream edition: Mint 20 "Ulyana" (June 2020); LMDE edition: LMDE 7 "Gigi" (2025)
- **Last 32-bit:** LMDE 6 (based on Debian 12)
- **Status:** Both product lines now fully 64-bit only.

#### Manjaro
- **Dropped:** Main distro: November 2017; Community Manjaro-32 spin-off: March 2020
- **Status:** No 32-bit support remains in any form.

#### elementary OS / Pop!_OS / Zorin OS
- **Dropped:** Various dates, tracking Ubuntu's upstream decision (2018--2020)
- **Status:** All 64-bit only. None offer 32-bit ISOs.

#### Kali Linux
- **Dropped:** Approximately 2023--2024
- **Status:** No i386 ISOs offered for recent releases; only amd64, ARM, and other architectures.

#### Parrot OS
- **Dropped:** 2024 (Parrot 6.x 64-bit only; Parrot 5.x was last with i386)

#### Gentoo Linux
- **Dropped:** Not fully dropped yet, but **decaying**
- **Status:** Formal proposal (mid-2024) to reclassify x86 from stable to testing/dev-only, with mass de-keywording of packages. Full removal not yet announced but trajectory is clear.

---

#### Linux Distros Still Shipping 32-bit (as of mid-2026)

| Distro | Notes |
|--------|-------|
| **Slackware** | Ships 32-bit `-current` tree; minimum CPU bumped to Pentium 4 (i686+SSE2); maintainer acknowledges Linux 6.15+ will make 32-bit bare-metal "dead" |
| **Void Linux** | Rolling release with i686 ISOs and packages |
| **Alpine Linux** | x86 (32-bit) images for containers and lightweight systems |
| **MX Linux** | 32-bit ISOs, Debian-based, systemd-free, ~300 MB idle RAM |
| **antiX Linux** | 32-bit including non-PAE kernels for Pentium II/III, ~150 MB idle RAM |
| **Puppy Linux** | 32-bit, runs entirely in RAM (~50--100 MB), supports non-PAE |

---

### 1.2 Microsoft Windows

| Date | Milestone |
|------|-----------|
| **Feb 2008** | Windows Server 2008 -- last Server release with 32-bit x86 edition |
| **Oct 2009** | Windows Server 2008 R2 -- first 64-bit-only Server (32-bit x86 dropped entirely from server line) |
| **May 2020** | Windows 10 v2004 -- 32-bit OEM builds discontinued (retail 32-bit still available) |
| **Oct 2021** | Windows 11 released -- no 32-bit version exists (64-bit only) |
| **Oct 14, 2025** | Windows 10 end of support -- effectively ends all supported 32-bit Windows for consumers |

**Notes:** Microsoft never issued a single "end of 32-bit" proclamation. The deprecation was communicated incrementally through Windows Hardware Minimum Requirements documentation, Windows Server release notes, and Windows 11 system requirements.

---

### 1.3 Apple macOS

| Event | macOS Version | Name | Date |
|-------|--------------|------|------|
| 32-bit kernel dropped | 10.8 | Mountain Lion | July 2012 |
| Last to run 32-bit apps | 10.14 | Mojave | September 2018 |
| 32-bit app support dropped | 10.15 | Catalina | October 2019 |
| Apple Silicon (ARM64) announced | -- | WWDC 2020 | June 2020 |
| First Apple Silicon Mac (M1) | 11.0 | Big Sur | November 2020 |

**Architecture timeline:**
```
2005: Tiger (10.4)     -- 32-bit only kernel and apps
2007: Leopard (10.5)   -- 64-bit apps supported (32-bit kernel)
2009: Snow Leopard     -- 64-bit kernel introduced (32-bit default)
2011: Lion (10.7)      -- most Macs boot 64-bit kernel
2012: Mountain Lion    -- 64-bit kernel ONLY
2018: Mojave (10.14)   -- LAST macOS with 32-bit app support
2019: Catalina (10.15) -- 64-bit apps ONLY
2020: Big Sur / M1     -- ARM64 introduced; Rosetta 2 for Intel apps
2023: Mac Pro M2 Ultra -- Apple Silicon transition complete
2025: macOS Tahoe (26) -- last macOS supporting Intel Macs
~2027: macOS 28+       -- Intel binary support expected to end
```

---

### 1.4 BSD and Other Unix Derivatives

| OS | 32-bit x86 Status | When |
|----|-------------------|------|
| **DragonFly BSD** | Dropped entirely | Nov 2014 (4.0) |
| **illumos** | Kernel dropped | 2018 (user-space at distro discretion) |
| **FreeBSD** | Fully retired | Dec 2025 (15.0); demoted to Tier 2 in 13.0 (2021); 32-bit app compat via `compat32`/`lib32` |
| **OpenBSD** | Still builds, reduced support | Ongoing (i386 receives only easy/critical security fixes; minimum CPU is i586) |
| **NetBSD** | Tier I, fully supported | Ongoing (last major BSD with first-class 32-bit x86) |

---

### 1.5 Linux Kernel Upstream

- **2012:** Original i386 (80386) support dropped
- **April 2025:** RFC patch series proposes dropping all i486 and early i586 (TSC-less, CX8-less) CPU support. Linus Torvalds endorsed the removal. Still under discussion.
- **Reference:** Phoronix coverage

---

## II. Programming Languages and Compilers

| Language | 32-bit x86 Status | Last Change | Date | Notes |
|----------|-------------------|-------------|------|-------|
| **Java / OpenJDK** | REMOVED | JEP 503 removes Linux 32-bit in JDK 25 | Sep 2025 | Windows 32-bit deprecated JDK 21, removed JDK 23. Linux 32-bit deprecated JDK 24, removed JDK 25. Fallback: Zero port (pure interpreter, no JIT). [JEP 449](https://openjdk.org/jeps/449), [JEP 479](https://openjdk.org/jeps/479), [JEP 501](https://openjdk.org/jeps/501), [JEP 503](https://openjdk.org/jeps/503) |
| **Go** | PARTIALLY DROPPED | windows/386 removed Go 1.23; darwin/386 removed Go 1.15 | 2024/2020 | linux/386 remains Tier 2; freebsd/386 Tier 2. SSE2 required since Go 1.16. No formal removal proposal for linux/386. [golang/go#40255](https://github.com/golang/go/issues/40255) |
| **Node.js / V8** | REMOVED | Linux i686 unbuildable since Node.js 22; Windows 32-bit binaries dropped Node.js 23 | 2024 | Linux i686 demoted from Tier 1 in Node.js 10.x (2018). V8 dropped 32-bit x86 JIT backend ~2014. Fedora declared end of i686 Node.js (May 2024). |
| **Rust** | STILL SUPPORTED (Tier 1) | i586-pc-windows-msvc removed Rust 1.87; i686-pc-windows-gnu demoted to Tier 2 in Rust 1.88 | 2025 | i686-unknown-linux-gnu and i686-pc-windows-msvc remain Tier 1 with Host Tools. docs.rs dropped i686-linux as default target (Oct 2025). i686-apple-darwin demoted to Tier 3 in Rust 1.42 (2020). |
| **Python (CPython)** | STILL SUPPORTED (Tier 1 on Windows) | -- | -- | 32-bit Windows: Tier 1, installers still ship in 3.14.6. 32-bit x86 Linux: not listed in any PEP 11 tier (effectively unsupported). [PEP 11](https://peps.python.org/pep-0011/) |
| **GCC** | STILL SUPPORTED | -- | -- | i386/i686 target is not deprecated and actively maintained. IA-64 (Itanium) and NDS32 were removed in GCC 14/15, but those are different architectures. |
| **LLVM / Clang** | STILL SUPPORTED (upstream) | -- | -- | X86 backend is a unified 16/32/64-bit backend, not deprecated. Caveats: Debian's patched i386 baseline (x87-only, no SSE) is unsound per upstream. Ubuntu dropped i386 LLVM 19 packages. FreeBSD dropped 32-bit sanitizers. |
| **.NET / C#** | STILL SUPPORTED | -- | -- | x86 runtime installers for .NET 8, 9, and 10. No deprecation announced. Primarily serves running 32-bit apps on 64-bit Windows via WOW64. |
| **Ruby** | STILL SUPPORTED | -- | -- | No deprecation announced. Recent YJIT work on Microsoft x86 calling convention (Dec 2024) suggests continued investment. |
| **PHP** | UNDER DISCUSSION | RFC filed June 18, 2025 | Vote TBD | Proposal to deprecate in PHP 8.next, remove entirely in PHP 9.0. Catalyst: Year 2038 problem. Xdebug dropped 32-bit "long ago" with zero complaints. Fedora 41 already dropped 32-bit PHP. Requires 2/3 majority. [PHP RFC wiki](https://wiki.php.net/rfc/drop_32bit_support) |

---

## III. Numerical and Scientific Computing Software

### 3.1 Python Numerical Ecosystem

| Library | 32-bit Status | Last Version | Date | Notes |
|---------|---------------|-------------|------|-------|
| **NumPy** | **Still ships win32 wheels** (2.x) | Current | -- | Dropped 32-bit Linux wheels around 1.22.x (late 2021). Windows win32 remains. |
| **SciPy** | Dropped win32 + i686 | 1.9.1 | Oct 2022 | Dropped both Windows and Linux 32-bit wheels in 1.9.2. Meson build system and Fortran compiler issues cited. |
| **scikit-learn** | Dropped win32 | 1.1.2 | Oct 2022 | Explicitly cascaded from SciPy 1.9.2 dropping 32-bit. |
| **Pandas** | Dropped win32 | 2.0.3 | Aug 2023 | ~1% of total downloads. Workaround: `pip install numpy==1.24.3 pandas==2.0.3`. |
| **PyTorch** | Never supported 32-bit | N/A | N/A | Always 64-bit only. Deep learning impractical on 32-bit. |
| **TensorFlow** | Never supported 32-bit | N/A | N/A | Always 64-bit only on all platforms. |
| **JAX** | Never supported 32-bit | N/A | N/A | Requires AVX and FMA CPU instructions (Intel Haswell, 2013+). |

**Cascade chain:** SciPy 1.9.2 (October 2022) was the domino that triggered scikit-learn in the same month and Pandas 10 months later. NumPy is the last holdout still shipping 32-bit Windows wheels.

---

### 3.2 Proprietary Numerical / Statistical Software

| Software | Last 32-bit Version | 32-bit Dropped | Year | Platform Notes |
|----------|---------------------|----------------|------|----------------|
| **MATLAB** | R2015b | R2016a (Win); R2012b (Linux); R2010b (macOS) | 2010--2016 | Phased out per platform. Simulink followed identical schedule. License Manager also 64-bit only from R2016a. |
| **ANSYS (core)** | 14.5 | 15.0 | 2013 | Linux 32-bit dropped at 14.0 (2011). SpaceClaim 2015 last 32-bit (2015). medini Analyze dropped at 19.0 (2018). |
| **COMSOL** | 5.0 | 5.1/5.2 | 2015 | All versions 5.2 through 6.4+ are 64-bit only on all platforms. |
| **Stata** | 15 | 16 | 2019 | macOS 32-bit dropped much earlier (Stata 13). StataCorp: "Stata 16 is for 64-bit Windows only." |
| **SPSS Statistics** | 26 | 27 | 2020 | IBM: "Beginning with SPSS Statistics 27, Microsoft Windows 32-bit edition will no longer be supported." |
| **Maple** | 2020 | 2021 | 2021 | Linux 64-bit only since Maple 2018. Classic Worksheet interface was 32-bit Windows only. |
| **Origin / OriginPro** | 2019b | 2020 | 2019--2020 | OriginLab: "As of Origin 2020, only 64-bit versions." Legacy 2019b available on request. |
| **Mathematica / Wolfram** | 11.2 (Win/Linux) | 11.3 (Win/Linux) | 2018 | macOS 32-bit front-end dropped in 12.0 (2019). 64-bit only on all platforms since 12.0+. |
| **SAS** | No clean cutoff | Gradual phase-out | 2017+ (practical) | SAS 9.4 still technically lists 32-bit Windows in its support matrix, but 32-bit is effectively deprecated. SAS Viya is 64-bit only from inception. SAS Enterprise Guide remains a 32-bit application (runs via WoW64). |

---

### 3.3 Open-Source Numerical / Scientific Software

| Software | 32-bit Status | Version/Date | Notes |
|----------|---------------|-------------|-------|
| **GROMACS** | Fully dropped | 2020 deprecated, 2022 removed | Hard removal. No 32-bit builds possible. Debian/Ubuntu removed 32-bit packages in 2022. |
| **LAMMPS** | Dropped (develop) | PR #4500 merged March 17, 2025 | 64-bit integers now required. This will land in the first stable release after July 2025. |
| **Octave** | Dropped (binaries) | Octave 8.4.0, November 2023 | Windows binaries only; source can still compile. MSYS2 provides third-party 32-bit builds. |
| **R** | Dropped Windows 32-bit | R 4.2.0, April 2022 | R 4.1.0 announcement: "the 4.1.x series will be the last to support 32-bit Windows." Linux no formal cutoff. macOS dropped with Catalina. |
| **Julia** | Still Tier 1 (eroding) | As of 2026 | Official binaries still provided. Active community push to drop. Package ecosystem breaking (JSON.jl, PackageCompiler.jl, CpuId.jl already broken on 32-bit). |
| **GSL** | De facto dropped | ~GSL 2.4+ | No formal deprecation; 32-bit binaries not available in practice on any major distribution channel. |
| **FFTW** | De facto dropped (platform) | Gradual, ~2020--2023 | Library supports 32-bit builds; pre-built 32-bit platform binaries disappearing. |
| **OpenBLAS** | Still supported | As of 0.3.33 (2025) | Needs `BINARY=32` flag at build time. Actively maintained (Debian changelogs show ongoing i386 fixes). |
| **LAPACK** | Still supported | As of 3.12.x | LP64 (32-bit integer) API remains the default. 32-bit platform builds maintained by distributions. |
| **Quantum ESPRESSO** | Still supported | As of v7.4+ | Explicit `ia32` configure target. Documentation confirms 32-bit support. |

---

*Compiled June 2026 from publicly available release notes, announcements, package repositories, and mailing list discussions.*
