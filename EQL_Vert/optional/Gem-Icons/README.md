# Gem icons

Spell gem artwork. **The skin ships with the classic gems already applied** -
`Classic-Gems.zip` is the current state, not something you need to install.
That is a deliberate choice: classic gem icons are part of what this skin is
for. The modern art is here as an option, not as the baseline.

Pick one zip, extract it into the **skin folder root** (the folder containing
`EQUI_SpellIcons.xml`) choosing "replace files", then in game:

```
/loadskin <yourskin> 1
```

| Zip | Gem icons | Spell sheets 01-05 |
| --- | --- | --- |
| `Classic-Gems.zip` | classic RoF2 | modern (untouched) |
| `Modern-Gems.zip` | modern | modern (untouched) |
| `Classic-Gems-And-Spell-Sheets.zip` | classic RoF2 | classic RoF2 |
| `Modern-Gems-And-Spell-Sheets.zip` | modern | modern |

**Shipped default:** `Classic-Gems`.

The two `Modern-` zips are how you get back. There is nothing to run and no
uninstall step - every zip is a complete set of the files it touches, so
switching is always the same operation in either direction.

## Which to pick

**`Classic-Gems`** - the default, and the one to keep unless you specifically
want the modern look. Only `gemicons01.tga` and `gemicons02.tga` change. Stance and
invocation icons continue to come from the modern `Spells*.tga` sheets, so the
asset set stays internally consistent.

**`Modern-Gems`** - stock modern gem art, matching the rest of a modern client.

**The `-And-Spell-Sheets` variants - read this first.** They also replace
`Spells01-05.tga`. The classic pack only covers sheets 01 to 05, but the skin
ships sheets 01 through 63. Installing the classic variant therefore leaves
01-05 classic and 06-63 modern, and an icon's styling depends on which sheet it
happens to live on. That is a visible inconsistency, not a bug. Use it only if
you accept the split.

## Notes

- All files are 256x256 32-bit uncompressed TGA, matching the sizes already
  declared in `EQUI_SpellIcons.xml`. No XML changes are involved, in either
  direction.
- Classic art is from
  [eqinterface file 6029](https://www.eqinterface.com/downloads/fileinfo.php?id=6029).
- The classic zips name the sheets `spells01-05.tga` in lower case while the
  skin ships `Spells01-05.tga`. Windows treats these as the same file, so the
  swap works, but the casing on disk may change after extracting.
- **Never revert by deleting files.** The client falls back to
  `uifiles\default`, which is classic art and not this skin's state. Always
  extract the matching zip instead.
