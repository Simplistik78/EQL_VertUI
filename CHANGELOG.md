# Changelog

## 19 September 2026 (3)

Four fixes.

### Hot buttons

Pressing a button does something visible again. The buttons are the modern
client's own art, whose pressed state is almost entirely transparent so that the
blue Vert slot underneath shows through. An earlier change in this release
replaced the resting and hover art with opaque blue tiles, which covered that
slot permanently - so every button read as a flat blue slab and a press revealed
nothing. The original art is back.

### Player window

The flashing attack indicator draws again. It had been hidden behind the
sub-window added to make clicking the window target you; that sub-window is now
inset, and the indicator traces the window frame.

Threat readouts are gone from this window. Three labels had lost their
horizontal anchors and were stretching the full width across the XP and AA bars,
drawing over both - and because a label takes the click here, they were also
swallowing click-to-target-self across that band. The threat window already
shows all three numbers.

The combat state icon is anchored to the right edge instead of a fixed position,
so a change in border thickness cannot push it off the window.

### Target bar

A 4px black seam between each bar, so they no longer run together. The target's
name now reads before the level and class rather than after them, and the
target-of-target class field is wide enough for a three-class mix.

### Threat window - `198 x 104`

Twelve pixels shorter, trimmed from empty space below the most-hated row, so it
no longer overlaps the group window's controls. The window is a fixed size, so
an existing layout keeps the old height until `Width` and `Height` are removed
from its `[AggroMeterWnd]` section with the game closed.

## 19 September 2026 (2)

### Map window

Rebuilt. The map now fills the whole window - the search row and the control
panel float over it instead of taking a strip out of it.

Controls are 20x20 squares grouped by job down the right edge: zoom and
auto-zoom, the label/group/name toggles, zone guide and edit map, the two layer
rows, Z filtering with its low and high boxes, and the fade slider. Every one
carries a tooltip, because the letters on their own are cryptic.

Vert artwork throughout - the dark rock frame with the black square border the
player and pet windows use, and the flat Vert buttons from the pet window.

The window drags down to `300 x 240` instead of `600 x 556`, so it can sit in a
corner as a minimap. A size you have already saved still wins over the skin, so
drag the window in to find the new floor.

Dropped: the pan arrows, Center, Current Zone, and the text headings the old
panel carried. Panning is a drag on the map; everything else is a button.

The two floating strips take clicks, so the map does not pan underneath them.

### Find window

Now skinned. It had been loading the client's classic art all along because the
skin carried no copy of the file. It gets the same dark rock frame and inset
boxes as the map window it opens from.

## 19 September 2026

A console band across the bottom of the screen: every window and hot bar in it
carries a 4px black outer border, and neighbours overlap by 4px so each seam
reads as one black line. The skin now ships that arrangement as
`default1080.ini`.

### The shipped layout

`default1080.ini` is loaded by unticking **Keep Your Layout** in the Load Skin
window. Leave it ticked and nothing changes for you.

Unticking replaces your window positions and cannot be undone in game, so back
up `UI_<Char>_<server>.ini` first. Chat filters are not part of the layout and
need setting up again. It is built for 1920x1080 only.

### Player window - `193 x 247`

Rebuilt on NewWorld_RoF's stats layout: name on the HP bar, mana and endurance
with icons and numbers, XP and AA, AA banked, AC/ATK, haste, velocity, mana and
endurance regen, seven stats and six resists in two columns. Stat values come
from the same client values the inventory window uses, so the two agree.

Clicking anywhere in the window targets you again.

### Target bar - `458 x 120`

Flat: two rows of target buffs on top, HP with level, class and name, then
mana | endurance, then target-of-target | cast bar. The con-colour box is now a
2px ring inside the frame instead of a thick border.

### Threat window - `198 x 116`

Target name, your threat bar and percentage, and the most-hated player's name
and percentage in gold.

### Pet bar - `788 x 66`

Flat: gauges at the left, twelve 24px equipment slots along the top, command
buttons in one row beneath, and a scrolling buff box at the right end. Two extra
command buttons sit above `leave` and `inventory`.

### Bag bar - `649 x 67`

New: 35 inventory slots in one strip - worn slots and power source at 24px,
twelve bag slots, and primary / secondary / range / ammo at 48px.

It is hosted in the **Audio Triggers** window, because the client will not let a
skin add a window. Bind **Toggle Audio Trigger Window** under Options > Keys to
open it.

### Hot bars

A button holding an item, social or ability now draws the blue Vert slot behind
it instead of a grey square, matching the empty slots. The 2px padding inside
each bar is gone, so a bar's black border is the spacing around its buttons.

## 7 September 2026 (2)

### Find Item window now skinned

`EQUI_FindItemWnd.xml` ships with the skin for the first time - previously it
fell back to `default` and rendered in classic art.

Vert frame and templates throughout, and relaid out: Item Name, Select By Slot
and Location at the top, secondary filters compacted into two columns, and the
results list given the rest. Window is 511x459 so it sits beside the Inventory
window.

Native behaviour is untouched - control names, ScreenIDs, EQTypes and the six
result columns are identical to stock.

## 7 September 2026

### Pet stats on the inventory Pet tab

Two bugs, both fixed.

`IWM_Level` and `IWM_Class` had their `EQType` commented out, so Level and
Class rendered permanently blank. Restored to `1051` and `1050`.

`IW_PetInv` was 325 wide while its two columns need 356, so every value in the
Pet Stats and Resists column was clipped outside the box - the labels showed
but the numbers did not. Widened to 356.

## 6 September 2026

First update since the initial publish. The repository now contains only
`EQL_Vert` - the old `DougsUI\` and `Vert33OceanSpray\` folders have been
removed from the working tree and the `EQL_Vert` branch folded into `main`.
Both remain in git history.

### Group window: 3 -> 8 members

Member slots 4 through 8 added - `GW_Gauge4-8`, their black backing gauges, and
`GW_AggroPctPlayer4-8`. The window was previously a fixed three-member layout.

### Pet window: 7 -> 12 inventory slots

`PIW_PetInvSlot07` through `11` added, with new `OS_A_Pet08-12` animations and
an updated `os_petslots.tga`. Previously only the first seven pet inventory
slots were drawn; the rest were reachable only from the inventory Pet tab.

### Inventory window: pet illusion selector

`IWM_PetIllusionComboBox` and its label added to the pet tab. New
`os_invany.tga` with `OS_A_InvAny1` / `OS_A_InvAny2`.

### Options window: seven missing controls

The client logged five missing children every time the Options window opened.
All are now present, along with the two labels stock pairs with them:

| Control | Where |
| --- | --- |
| `ODP_SystemCursor` | System > Display |
| `ODP_SpellbookButtonToggle` | System > Display |
| `ODP_CursorScale` + label | System > Display |
| `ODP_NameplateThreatOptions` + label | Interface > Nameplates |
| `OMP_SmoothCameraMotion` | Controls > Camera and Mouse |

`UIErrors.txt` is now clean when the Options window opens.

Threat Indicators keeps all three of its choices, **including No Aggro Mode**.
An EQL client crash was previously tied to that setting - an access violation
on zoning, worst right after swapping loadouts. It was not a UI fault: it
reproduced on the stock client at the same address, and was reported fixed in
the 2 September 2026 patch. The value is set in the client whether or not the
skin draws a control for it, so having the control is what lets you see and
change it.

### Optional gem art reorganised

Now `EQL_Vert/optional/Gem-Icons/`, with zips named for the result rather than
the operation:

| Was | Now |
| --- | --- |
| `Classic-RoF2-Gems_Gems-Only.zip` | `Classic-Gems.zip` |
| `RESTORE_Classic-RoF2-Gems_Gems-Only.zip` | `Modern-Gems.zip` |
| `Classic-RoF2-Gems_Full.zip` | `Classic-Gems-And-Spell-Sheets.zip` |
| `RESTORE_Classic-RoF2-Gems_Full.zip` | `Modern-Gems-And-Spell-Sheets.zip` |

The old names described the maintainer's build step, not the outcome. Since the
skin ships with classic gems already applied, the zip named for the classic
gems did nothing, and the file you needed for modern gems was called `RESTORE_`.
The folder now has its own README saying which variant is shipped.

### Skin folder is drop-in

No scripts ship with the skin any more. `EQL_Vert/README.md` previously told you
to run a validation script before every load; that is a maintainer concern and
happens before release now. Leftover working directories and a stray extracted
copy of a mod zip were removed, cutting roughly 2 MB.

The folder now contains only what the client reads: `EQUI_*.xml`, artwork,
`README.md`, and `optional\`.
