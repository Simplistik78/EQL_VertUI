# Classic RoF2 Gems

RoF2-era classic spell gem art, for players who prefer it over the shipped classic
`default` gems.

Source: [eqinterface.com file 6029](https://www.eqinterface.com/downloads/fileinfo.php?id=6029)

## Variants

### `Classic-RoF2-Gems_Gems-Only.zip` — recommended

| File | Effect |
|---|---|
| `gemicons01.tga` | Spell gems |
| `gemicons02.tga` | Spell gems |

Swaps gem art only. Stance/invocation icons keep the modern `Spells*.tga`, so the
hybrid asset set described in the main README stays intact.

### `Classic-RoF2-Gems_Full.zip` — read the caveat

| File | Effect |
|---|---|
| `gemicons01.tga`, `gemicons02.tga` | Spell gems |
| `spells01.tga` – `spells05.tga` | Classic spell icon sheets 1–5 |

**Caveat.** This skin ships modern `Spells*.tga` from `default_modern` so client-generated
stance icons match the modern UI. This pack only contains sheets 01–05. Installing Full
leaves 01–05 classic while 06 and up stay modern, so icon styling splits depending on
which sheet an icon lives on. Deliberate deviation — use only if you want classic art in
the low ranges and accept the mismatch.

## Restore zips

`RESTORE_Classic-RoF2-Gems_Gems-Only.zip` and `RESTORE_Classic-RoF2-Gems_Full.zip` are
**not included here** — they have to be built from your own skin folder, since only your
folder holds the exact stock files this skin ships. Build them before the first install:

```powershell
cd optional
.\New-RestoreZip.ps1 -SkinPath 'C:\Users\Public\Games\EQLegends\uifiles\aumaar' `
                     -ModZip   '.\Classic-RoF2-Gems\Classic-RoF2-Gems_Gems-Only.zip'
.\New-RestoreZip.ps1 -SkinPath 'C:\Users\Public\Games\EQLegends\uifiles\aumaar' `
                     -ModZip   '.\Classic-RoF2-Gems\Classic-RoF2-Gems_Full.zip'
```

Note for the Full restore: if `spells01-05.tga` are not currently in your skin folder,
copy them in from `uifiles\default_modern` first, otherwise the restore zip will not
carry them and reverting would leave you on classic fallback art.

## Technical notes

- All files are 256×256, 32-bit uncompressed TGA — matching the sizes already declared
  in `EQUI_SpellIcons.xml`. No XML changes needed, in this mod or the skin.
- Zips are flat: extract into the skin folder root and overwrite.
- Reverting by deleting files does **not** work. The client falls back to `uifiles\default`,
  which is classic art, not this skin's stock state. Always use a restore zip.
