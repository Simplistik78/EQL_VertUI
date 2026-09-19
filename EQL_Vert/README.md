# Vert UI

An EverQuest Legends skin. A modern-behaviour UI wearing **Vert33OceanSpray**
artwork, built by reskinning windows one at a time rather than porting a 2003
layout wholesale.

Source artwork: [eqinterface.com file 6029](https://www.eqinterface.com/downloads/fileinfo.php?id=6029)
Repository: <https://github.com/Simplistik78/EQL_VertUI>

---

## Contents

1. [Install](#install)
2. [Six rules](#six-rules) — read before changing anything
3. [The shipped layout](#the-shipped-layout)
4. [Reskinned windows](#reskinned-windows)
5. [Optional mods](#optional-mods)
6. [File reference](#file-reference)
7. [Adding a window](#adding-a-window)

---

## Install

Copy the skin folder into `uifiles\`, then in game:

```
/loadskin <foldername> 1
```

**The skin name is whatever the folder is called.** If the folder is `DougsUI`,
the command is `/loadskin dougsui 1`. This README uses `<yourskin>` throughout
rather than hardcoding a name — earlier docs disagreed with each other on this.

That is the whole install. Nothing to run, nothing to patch - the folder is
shipped ready to load.

---

## The shipped layout

The skin ships `default1080.ini`: one console band across the bottom of the
screen, every window edge meeting its neighbour on a 4px black seam.

**You only get it if you untick "Keep Your Layout"** in the Load Skin window.
Leave it ticked — the default — and your own window positions are kept, which is
usually what you want.

**Unticking replaces your arrangement, and there is no undo in game.** Close the
game and copy `UI_<Char>_<server>.ini` somewhere outside the game folder first.
That file also holds your chat filters, which the layout does not carry: set
those up again afterwards (Options > Chat, or right-click a chat window).

**It is built for 1920x1080.** There is no 1440, 4K or 720 version, so at other
resolutions the windows will not line up.

Two things no layout file can carry:

| Thing | Where it lives | What to do |
| --- | --- | --- |
| Bag bar keybind | `eqclient.ini` | Options > Keys, bind **Toggle Audio Trigger Window** |
| Chat filters | your character's UI ini | set per chat window after loading |

**If a window looks the wrong size after loading the skin,** your ini has a saved
size for it and the ini always wins. Close the game and delete the `Width=` and
`Height=` lines from that window's section in `UI_<Char>_<server>.ini`.

## Six rules

Every one of these was learned by breaking something.

### 1. The client loads a fixed list of `EQUI_<Name>.xml` files

Not everything matching `EQUI*.xml`. A file named `EQUI_Animations_OS_Inventory.snippet.xml`
sits in the folder looking like a UI file and is **silently ignored**.

That happened here. 19 animation declarations never entered the symbol table while
two patched windows referenced them, and the client threw away the whole skin:

```
XML reference error! Ui2DAnimation[7]:OS_A_InvPrimary[1781] referenced but NEVER declared!
Error validating symbol table.
Error loading skin: loading default skin instead.
```

Not the inventory window — everything.

**Never ship a fragment.** `EQUI_Animations.xml` in this skin is always the
complete file with blocks already merged. There is nothing to paste, and
nothing for you to run - releases are validated before they are published.

A reference error is not a syntax error. Both files parsed fine.

### 2. Window geometry persists in the ini and overrides the XML

Size and position live in `UI_<char>_<server>.ini` and are restored **over**
whatever the XML declares. A changed `<CY>` does not take effect on a window the
client has already saved.

This produced three separate "the layout is broken" reports during the pet window
work, all the same cause. One measurement: a window rendering 192px tall against a
declared 268, silently clipping everything below.

**When you change a window's size:**

1. Quit EverQuest completely — the client rewrites the ini on exit, so editing it
   while running achieves nothing.
2. Delete the `[WindowName]` section, and any `[WindowName_1]`.
3. Relaunch and `/loadskin`.

### 3. Buttons and `InvSlot` controls have no anchors

Gauges and labels carry `AutoStretch` and anchor blocks. Buttons and `InvSlot`s
carry neither — not one `InvSlot` anywhere in this skin uses an anchor.

So:

- Layouts that depend on moving or resizing buttons are fighting the file.
- Windows are not usefully resizable. `Style_Sizable` can be set and the cursor
  appears, but frames and gauges stretch while buttons and slots stay put. The
  group window has `Style_Sizable>true` with bounds and the client ignores edge
  drags entirely.
- Resize by editing XML instead.

### 4. Anchors are relative to the parent *in the same file*

There is no cross-window anchoring. Nothing binds one top-level window's position
to another's; each is positioned independently and persisted separately. Two
windows cannot be made to move together.

Within a file, watch what a control is parented to. In the pet window
`PIWDragBox1` is anchored to `PetInfoWindow`, not `PetInfoSubWindow` — so when the
sub-window moved, the drag strip stayed put and ended up lying across the command
buttons, showing a move cursor over them.

### 5. You cannot add a window

The client instantiates a fixed set of window classes. A new
`EQUI_PetInventoryWnd.xml` is not read. A top-level `<Screen>` renders only if the
client already knows that window.

### 6. Never revert by deleting files

The client falls back to `uifiles\default`, which is classic art — **not this
skin's stock state**. `Spells*.tga` is the clearest case: this skin ships the
`default_modern` copies.

Always switch by extracting the zip for the state you want from
`optional\`. Every variant there is a complete set of the files it touches,
including the one the skin ships with, so there is always a way back.

### Also worth knowing

**Window alpha.** Inventory-family windows draw art at **0.75**; hotbars draw at
**1.00**. Measured off a single frame:

| | In the TGA | Drawn | Ratio |
| --- | --- | --- | --- |
| Slot plate | `(24,48,92)` | `(18,36,68)` | 0.75 |
| Slot glyph | `(212,226,248)` | `(149,162,186)` | 0.75 |
| Hotbar fill | `(24,48,93)` | `(24,48,93)` | **1.00** |

Art can be pre-divided to compensate, and the `_Alpha75` variants do exactly that.
Highlights cannot be recovered: at 0.75 the brightest drawable value is 191, and
the glyph wants 212. Unreachable at any source value.

Better fix: right-click the window title bar and raise its alpha, then use the
`HotbarMatch` art.

**Line endings are inconsistent.** `EQUI_PetInfoWindow.xml` is bare LF,
`EQUI_InventoryWindow.xml` is CRLF. Generators should detect and match the host
file. A mismatch still parses but makes every line look changed in a diff.

**Take slice coordinates from the source skin's own XML**, never by eye off an
atlas. The first group window attempt read them by eye and pulled arbitrary pixels
off a slider sheet.

---

## Reskinned windows

### Group window — `190 x 187`

Three-member, titlebar-less, LFG top-left and invite/disband top-right, matching
the original Vert layout rather than default-modern.

Draw template `OS_WDT_GroupVert` — a clone of `AUM_WDT_VertSquare` with the three
left-border slots swapped for the Vert rail:

```xml
<LeftTop>OS_A_VertRailTop</LeftTop>
<Left>OS_A_VertRailMiddle</Left>
<LeftBottom>OS_A_VertRailBottom</LeftBottom>
```

Rail source is OceanSpray's `GW_V_bar_image`, a uniform blue bar at
`os_VertWindowPieces01.tga (29,1,14,172)`, sliced cap/tile/cap so it survives any
height. Buttons and decoration come from `os_solwindow_pieces07.tga`.

Row pitch 48. Rows at `20..55`, `68..103`, `116..151`.

**Buttons must use `<NormalDecal>` with an explicit `<DecalSize>`**, not the
`<Normal>` background slots OceanSpray used. The background form produces a
working, tooltip-responsive button with no visible icon.

**If the window slides to the bottom of the screen and re-asserts itself when you
move it:** right-click → Display Types → untick **Expand Upwards**. With it on,
the client pins the bottom edge and recomputes the top, fighting every drag. In
the ini it appears as `ExpandUpwards=1` under `[GroupWindow]`.

Moved by two transparent `DragBox` controls. `Style_ClientMovable` was tried and
does not work here.

The `GroupSize1`-`GroupSize11` table is deliberately absent. If restored, set all
eleven to the same value or the client resizes the window on every membership
change.

### Inventory window — `504 x 495`

**Vert33OceanSpray ships no inventory window.** It never skinned one — it
inherited the client default. So there was no layout to port, only slot
iconography.

Second finding: this skin's `A_Inv*` definitions were **already
coordinate-identical** to OceanSpray's for 18 of 20 slots. Same filenames, same
`<Location>`, same `40x40`. Both descend from the same EQ defaults. The only real
divergence was `A_InvCharm`.

The visible difference was never XML — it was **which `.tga` sits in the folder**.
The skin did not ship `window_pieces01/02/04/05.tga`, so those slots fell back to
default art. The fix was to ship OceanSpray's atlases under the `os_` namespace
and repoint.

| Change | Detail |
| --- | --- |
| Outer frame | `AUM_WDT_Rounded` → `AUM_WDT_VertSquare` |
| Equipment slots | 44 `<Background>` refs → `OS_A_Inv*` |
| Bag slots | `InvSlot23-34` → `OS_A_Bag01`-`OS_A_Bag12`, numbered tiles |
| Pet tab slots | → `OS_A_RecessedBox` |
| Bandolier | 4 `<Normal>` refs → `OS_A_Inv*` |

`AUM_WDT_VertSquare` on the outer frame is house convention — Player, Target,
Extended Target, Chat and Chat Container already wear it. Inner panels keep
`AUM_WDT_Inner`; the 8 `AUM_WDT_Def` uses are tab pages, which count as inner
surfaces.

`OS_A_RecessedBox` exists so only the inventory window's slots repoint. Bank,
BigBank, Container and Templates keep stock `A_RecessedBox`.

Bandolier is in scope because it is the only other consumer of the equipment slot
art.

### Pet bar — `788 x 66`

A flat bar: pet and pet-target gauges at the left, twelve equipment slots along
the top, the command buttons in one row beneath them, and a scrolling buff box at
the right end.

`petInventory/Equip N` **does** bind from `EQUI_PetInfoWindow.xml`, not just the
inventory window. This was genuinely unknown — the type is implemented by the
inventory window, OceanSpray predates pet inventory entirely, and the Project 1999
reference warns that inventory EQTypes in unintended contexts can crash the
client. Tested with a throwaway probe before anything was built on it.

**Twelve slots at 24px.** The client draws only the slots the pet actually has,
so most pets fill the first seven and the rest stay empty.

`PetInfoSubWindow` fills the window and carries the frame. Sub-window
coordinates:

| Region | sub-x | sub-y |
| --- | --- | --- |
| pet / pet-target gauges | 1..109 | 1..48 |
| equipment, 12 x 24px | 113..401 | 1..25 |
| command buttons, 49x22 | 113..612 | 26..48 |
| two more buttons | 513..612 | 1..23 |
| buff box, scrolling | 616..770 | 0..50 |

The buff box holds a `138 x 115` tile box — six icons per row, two rows visible,
the rest reached with its scroll bar. The grip bar between the equipment slots
and the two extra buttons is the only place the bar can be dragged.

`PIWDragBox1` covers the grip bar. The bar itself is `OS_A_GWHBar` stretched:
`StaticAnimation` accepts `AutoStretch`, so a 125x14 texture becomes any width at
4px tall — no tiling, no new template.

**Flat buttons.** `BDT_Normal` draws `A_BtnNormal`, a gradient running 165 down to
71 — the wrong *kind* of art, not the wrong shade. `A_BtnNormal` lives in
`window_pieces03.tga`, which this skin does not ship, so it cannot be edited.
Hence `os_petbuttons.tga` and `OS_BDT_PetFlat`, drawing `(41,44,49)` with a 1px
`(16,16,16)` edge at 0.75 alpha. `BDT_Normal` itself is untouched.

### Player window — `193 x 247`

Rebuilt from NewWorld_RoF's layout: name on the HP bar, mana and endurance with
their icons and numbers, XP and AA bars, AA banked, then AC/ATK, haste, velocity,
mana and endurance regen, the seven stats and six resists in two columns.

Stat values use the same client values as the inventory window, so the two always
agree.

**Clicking the window targets you**, as stock does. That needs the controls to
sit inside `PlayerSubWindow`: placed directly on a `Style_ClientMovable` window, a
left click starts a window drag and never reaches the client. For the same
reason, the name is drawn by the HP bar itself rather than by a label over it —
a label takes the click. `PW_ClickTarget`, an undrawn copy of the HP bar covering
the window, extends that to the whole window; the buttons listed after it stay
clickable.

The window is moved by `PW_DragBox`, an invisible grip on the empty right half of
the **AA Banked** row.

### Target bar — `458 x 120`

Flat: two stacked rows of target buffs across the top, the HP bar with level,
class and name, then mana | endurance, then target-of-target | cast bar.

The con-colour box (`A_TargetBoxStaticAnim*`) is a 2px ring on the inside edge of
the frame rather than a thick border.

### Threat window — `198 x 116`

Target name, your threat bar with your percentage, then the most-hated player's
name and percentage in gold. Sized to sit between the player window and the group
window.

### Bag bar — `649 x 67`

35 inventory slots in one strip: the worn slots and power source at 24px, twelve
bag slots, and primary / secondary / range / ammo at 48px.

**It lives in the Audio Triggers window.** The client instantiates a fixed set of
windows and you cannot add one, so the bar reuses a window nothing else needs.
Bind **Toggle Audio Trigger Window** under Options > Keys to open it. The
window's own controls are kept — the client looks them up — but parked at
`-2000,-2000`.

**Real Estate Items cannot host it.** While that window is open the client is in
place-an-item mode, and clicking an item in a bag highlights it instead of picking
it up. Any replacement host must be a display-only window.

**If Esc closes the bar,** your ini has `Escapable=1` saved for that window from
before, which beats the XML. Right-click the bar and untick **Escapable**.

### Console band

Every window and hot bar in the band carries a 4px black border, and neighbours
overlap by 4px so each seam reads as one black line. Three draw templates provide
it, each a copy of an existing frame with black added outside every border slice:

| Template | Copy of | Used by |
| --- | --- | --- |
| `OS_WDT_VertSquareBlack` | `AUM_WDT_VertSquare` | player, target, threat, pet, bag bar, extended target |
| `OS_WDT_ConsoleVertBlack` | `AUM_WDT_Console` | group window, all chat windows |
| `OS_WDT_ConsoleBlack` | `AUM_WDT_Console` | the 11 hot bars (plain black, no blue frame) |

A window using one of these is 8px larger than before, and its inside is
unchanged.

**Hot bar buttons.** A button holding an item, social or ability draws its
`Normal` art underneath, which was a solid grey square hiding the blue Vert slot.
`A_HotButtonNNormal` now draws `os_hotbar_normal.tga`, the empty-slot art plus the
1px grey frame empty slots show, so full and empty slots match. Hovering draws
`os_hotbar_flyby.tga`, the same 45% brighter.

**No slot padding.** Slot sets start at `0,0`, so a bar's black border is the
spacing between its edge and its buttons. Rows are `468 x 48`, single columns
`48` wide.

---

## Optional mods

Optional artwork lives in `optional\` as zips. One skin folder, one repository -
no forked copies of the UI.

```
optional\
    <Mod-Name>\
        <Result>.zip      a complete set of the files it touches
        README.md         what each zip does, and which is the shipped default
```

**To install or switch:** extract a zip into the **skin folder root**, choosing
"replace files", then `/loadskin <yourskin> 1`.

There is no separate uninstall step and nothing to run. Every zip is a complete
set of the files it touches, so moving between variants - in either direction -
is always the same operation.

### Rules for the zips

- **Flat structure.** Files at the zip root, no wrapper folder. Extracting into
  the skin folder must land them directly in it.
- **Named for the result, not the operation.** `Modern-Gems.zip`, not
  `RESTORE_Classic-RoF2-Gems_Gems-Only.zip`. A user picking a zip should not
  have to know which state the skin shipped in.
- **Every variant is a complete set**, including the one matching the shipped
  default, so there is always a way back without deleting anything.
- **Never revert by deleting** - see rule 6.
- **Art mods ship art only.** XML appears only when the mod is genuinely an XML
  change.
- **One `README.md` per mod folder**, stating which variant is shipped.

Use hyphens, not spaces.

### Current mods

| Mod | Variants | Touches |
| --- | --- | --- |
| `Gem-Icons` | Classic-Gems *(shipped)*, Modern-Gems, and `-And-Spell-Sheets` versions of each | `gemicons01-02.tga`, plus `spells01-05.tga` in the spell-sheet variants |

RoF2-era classic spell gem art, from
[eqinterface file 6029](https://www.eqinterface.com/downloads/fileinfo.php?id=6029).
**The skin ships with the classic gems already applied.** See
[`optional/Gem-Icons/README.md`](optional/Gem-Icons/README.md) for which zip does
what and for the caveat on the spell-sheet variants.

---

## File reference

### Custom textures

| File | Size | Used by |
| --- | --- | --- |
| `os_VertWindowPieces01.tga` | 768 KB | group window rail |
| `os_solwindow_pieces07.tga` | 256 KB | group buttons, decoration, pet rules |
| `os_window_pieces01.tga` | 256 KB | frame atlas, `AUM_WDT_VertSquare` |
| `os_window_pieces02.tga` | 256 KB | 18 equipment slots |
| `os_solWindowPieces03.tga` | 1024 KB | charm slot |
| `os_bagslots.tga` | 256 KB | 12 numbered bag tiles |
| `os_recessedbox.tga` | 16 KB | inventory bag / pet tab slots |
| `os_petslots.tga` | 256 KB | 7 `PET n` tiles |
| `os_petbuttons.tga` | 128 KB | flat pet command buttons |
| `os_hotbar_empty.tga` | 16 KB | hotbar fill — the `(24,48,93)` colour reference |
| `os_hotbar_normal.tga` | 16 KB | hot buttons holding something |
| `os_hotbar_flyby.tga` | 16 KB | hot button under the mouse |
| `os_vertsq_black.tga` | 64 KB | Vert square frame with its 4px black border |
| `os_console_black.tga` | 64 KB | console frame with its 4px black border |

### Namespaces

| Prefix | Meaning |
| --- | --- |
| `OS_A_*` | animation, imported from OceanSpray |
| `OS_WDT_*` / `OS_BDT_*` | window / button draw template, this project |
| `AUM_*` | from the base skin |
| `A_*` | stock, resolves from `uifiles\default` |

Assets are copied under `os_` names rather than replacing global filenames, so
nothing outside this skin can be affected by a change here.

---

## Adding a window

The pattern, confirmed across three windows now:

1. **Check whether the source skin even has the window.** OceanSpray has no
   inventory window at all. Two of the three inventory findings only surfaced
   because the source was read before work started.
2. **Preserve window XML and `EQType`s.** Change appearance, not behaviour.
3. **Take slice coordinates from the source skin's own XML**, never by eye.
4. **Copy assets under stable `os_` names**, never replace global filenames.
5. **Clone a draw template that already works in this client** and swap only the
   slots that differ.
6. **Check how an equivalent control is wired in a window that renders correctly**
   before inventing markup — decal vs background slots, `DragBox` vs
   `Style_ClientMovable`.
7. **Verify unknowns with a throwaway probe** before building on them. The pet
   inventory binding was settled in one `/loadskin` rather than assumed.
8. **Change one thing per test load.**
