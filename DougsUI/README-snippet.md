# README addition

Paste as a new section after the paragraph beginning "The stance bar keeps the stock
`BuffIcons` button template behavior…".

---

## Optional UI Mods

All optional variants of this skin live in `optional\` as zips, inside the same skin
project. There is deliberately no second skin folder and no forked repository — one
folder, all variants contained in it.

To use a mod, extract its zip into the skin folder root and let it overwrite. To revert,
extract the matching `RESTORE_` zip. That is the whole workflow; no scripts run on the
user's side.

```
optional\
    README.md                              the convention
    New-RestoreZip.ps1                     maintainer helper
    <Mod-Name>\
        <Mod-Name>_<Variant>.zip           mod assets
        RESTORE_<Mod-Name>_<Variant>.zip   the stock assets that variant overwrites
        MANIFEST.md                        source, contents, caveats
```

Conventions that make this work:

- Zips are flat — files at the zip root, so extraction lands them directly in the skin
  folder.
- Every mod zip has a matching `RESTORE_` zip covering the identical file list. Reverting
  by deleting files is never correct here: the client falls back to `uifiles\default`,
  which is classic art, not this skin's stock state. `Spells*.tga` is the clearest
  example — this skin ships the `default_modern` copies.
- Restore zips are built from the live skin folder before a mod's first install, either
  by hand or with `New-RestoreZip.ps1`, which reads the file list out of the mod zip.
- Art mods ship art only. XML appears in a mod zip only when the mod is genuinely an XML
  change.

### Current mods

| Mod | Variants | Files touched |
|---|---|---|
| `Classic-RoF2-Gems` | Gems-Only, Full | `gemicons01-02.tga`, plus `spells01-05.tga` in Full |

`Classic-RoF2-Gems` is RoF2-era gem art from
[eqinterface file 6029](https://www.eqinterface.com/downloads/fileinfo.php?id=6029).
Gems-Only preserves the hybrid asset set. Full also replaces spell sheets 01–05, which
leaves those classic while 06 and up stay modern — a documented deviation from the
"keep modern `Spells*.tga`" rule.

---

Add to **Working Rules**:

- Optional variants ship as zips under `optional\`, never as separate skin folders or
  branches. One skin folder, all variants inside it.
- Every mod zip gets a matching `RESTORE_` zip built before its first install.
- Never rely on deleting a file to revert a mod — deletion falls back to `uifiles\default`,
  not to this skin's stock state.
