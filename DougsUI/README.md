# Optional UI Mods

Every optional variant of this skin lives here as a zip. There is one skin folder and
one repository — no forked copies of the UI, no `aumaar-classicgems` sitting next to
`aumaar`. To use a mod, extract its zip into the skin folder and let it overwrite. To
go back, extract the matching `RESTORE_` zip.

## How to use a mod

1. Close EverQuest, or at least be ready to `/loadskin`.
2. Pick a zip from a subfolder here.
3. Extract it **into the skin folder root**
   (`C:\Users\Public\Games\EQLegends\uifiles\<YourSkin>`), choosing "replace files".
4. In game: `/loadskin <yourskin> 1`

To revert, extract that mod's `RESTORE_*.zip` the same way.

## Rules for the zips

These exist so extraction is the only step a user ever performs.

- **Flat structure.** Files sit at the zip root, no wrapper folder. Extracting into the
  skin folder must land the files directly in the skin folder.
- **Every mod zip has a matching `RESTORE_` zip** holding the exact stock files that
  the mod overwrites, so reverting is symmetrical. Build the restore zip *before*
  installing the mod for the first time.
- **Same file list on both sides.** If the mod zip contains five files, the restore zip
  contains those same five filenames with stock content. Never rely on deleting a file
  to revert — the client falls back to `uifiles\default` (classic art), which is not
  the same as this skin's stock state.
- **No XML in a mod zip unless the mod is genuinely an XML change.** Art swaps ship art
  only.
- **One `MANIFEST.md` per mod folder** listing source, contents, variants, and caveats.

## Naming convention

```
optional\<Mod-Name>\
    <Mod-Name>_<Variant>.zip           mod assets
    RESTORE_<Mod-Name>_<Variant>.zip   stock assets the variant overwrites
    MANIFEST.md
```

`<Variant>` is omitted when a mod has only one flavor. Use hyphens, not spaces —
`Classic-RoF2-Gems_Gems-Only.zip`.

## Building a RESTORE zip

Before installing any mod for the first time, capture the stock files it will replace.
By hand: select those filenames in the skin folder, right-click, Send to → Compressed
folder, rename to match the convention, drop it in the mod folder.

Or use the helper:

```powershell
.\New-RestoreZip.ps1 -SkinPath 'C:\Users\Public\Games\EQLegends\uifiles\aumaar' `
                     -ModZip   'optional\Classic-RoF2-Gems\Classic-RoF2-Gems_Full.zip'
```

It reads the file list out of the mod zip, pulls those exact files from the skin folder,
and writes `RESTORE_<same name>.zip` beside it. This is a maintainer step, not something
users run.

## Current mods

| Mod | Variants | Touches |
|---|---|---|
| `Classic-RoF2-Gems` | Gems-Only, Full | `gemicons01-02.tga`, optionally `spells01-05.tga` |
