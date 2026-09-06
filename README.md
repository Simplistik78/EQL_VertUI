# Vert UI

An EverQuest Legends skin. **Vert33OceanSpray** artwork on the modern client's
window behaviour.

Source artwork: [eqinterface file 6029](https://www.eqinterface.com/downloads/fileinfo.php?id=6029)

---

## Install

1. Download this repository (**Code -> Download ZIP**) and unpack it.
2. Copy the `EQL_Vert` folder into your EverQuest `uifiles\` directory.
3. In game:

```
/loadskin EQL_Vert 1
```

That is the whole install. Nothing to run, nothing to patch. The skin name is
whatever you call the folder - rename it and the command changes with it.

## What's in the box

```
EQL_Vert\
    EQUI_*.xml      54 window definitions
    *.tga / *.dds   artwork
    README.md       full notes - windows, geometry, known behaviour
    optional\       optional artwork variants, each with its own README
```

`EQL_Vert/README.md` is the detailed reference: what each reskinned window
does, the geometry, and the client behaviours worth knowing before you change
anything. Read it first if you plan to edit the skin.

## Optional artwork

`EQL_Vert/optional/Gem-Icons/` holds spell gem variants. **The skin ships with
the classic RoF2 gems** - that is deliberate, and `Classic-Gems.zip` is simply
the current state. `Modern-Gems.zip` is there if you want the stock modern art
instead. Extract whichever you want into the skin folder root, replace files,
`/loadskin`. Every variant is a complete file set, so switching works the same
way in either direction.

## Not every window is reskinned

The client resolves files in the active skin folder first, then falls back to
`uifiles\default`. This skin ships 54 window files; the rest fall back to stock
and render in classic art. That is expected, and the conversion is ongoing.

Fully reskinned so far: **group window**, **inventory window**, **pet window**.

## Reporting a problem

Include your `UIErrors.txt` from the EverQuest directory, and say which window
and which tab. Most reports come down to one of two things, both covered in
`EQL_Vert/README.md`: a window's saved size in `UI_<char>_<server>.ini`
overriding the XML, or the group window's **Expand Upwards** display type.

## Development

Work happens in [EQL_VertUI-DEV](https://github.com/Simplistik78/EQL_VertUI-DEV),
which also carries the stock client files the skin is measured against. This
repository is the shipping copy.
