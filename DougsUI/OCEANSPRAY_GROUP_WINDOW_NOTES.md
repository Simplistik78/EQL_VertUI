# Vert33OceanSpray group window

Last updated: 2026-07-19

This file replaces an earlier version that described a different implementation.
See "Corrections to the previous notes" at the end for what changed and why.

## What this is

A three-member group window using authentic Vert33OceanSpray artwork, built on
the current modern group-window behavioural base. It is titlebar-less, with the
LFG button top-left and invite/disband top-right, matching the original Vert
layout rather than the default-modern one.

The skin name is the name of the folder under `uifiles\`. If the folder is
`DougsUI`, the command is `/loadskin dougsui 1`. Substitute your own folder name
throughout.

## Read this first: ExpandUpwards

**If the group window slides to the bottom of the screen and re-asserts itself
every time you move it, the cause is not in any XML file.**

Right-click the window, open **Display Types**, and untick **Expand Upwards**.

With `ExpandUpwards` enabled the client pins the window's *bottom* edge and
computes the top, so it continuously recalculates position and fights any drag.
In `UI_<char>_<server>.ini` this shows as:

```
[GroupWindow]
ExpandUpwards=1
YRef=bottom
```

`YRef=bottom` on its own is normal — many windows use it. `ExpandUpwards`
appears on the group window only. To fix it in the ini instead of the menu,
close the game first (the client rewrites this file on exit), set
`ExpandUpwards=0`, and delete any stale `[GroupWindow_1]` section.

## Installed files

| File | Role |
| --- | --- |
| `EQUI_GroupWindow.xml` | The window itself |
| `EQUI_Animations.xml` | `OS_A_VertRail*`, `OS_A_GW*` animations + `os_VertWindowPieces01.tga` TextureInfo |
| `EQUI_Templates.xml` | `OS_WDT_GroupVert` draw template |
| `os_VertWindowPieces01.tga` | Rail atlas (512x512), copied from OceanSpray |
| `os_solwindow_pieces07.tga` | Button and decoration atlas (256x256) |
| `os_window_pieces01.tga` | Frame atlas, shared with `AUM_WDT_VertSquare` |

`EQUI_GroupWindow1.xml` was **deleted**. It provided an "Expanded Vertically"
display type that duplicated the window at a fixed four-player height. Two
display types on one window was confusing and served no purpose.

## Geometry

Window is `190 x 187`, no titlebar.

| Region | Extent |
| --- | --- |
| Top strip | 0 .. 21 |
| Row 1 | 20 .. 55 |
| Row 2 | 68 .. 103 |
| Row 3 | 116 .. 151 |

Row pitch is 48. Clearance below row 3 is 28px. Border insets are 3px top and
5px bottom, so client height is `187 - 8 = 179`.

Bounds are `MinHSize 160 / MaxHSize 400 / MinVSize 187 / MaxVSize 400`.

## Artwork

All coordinates below are taken from OceanSpray's own `EQUI_*.xml`, not read by
eye off the atlases.

### Rail — `os_VertWindowPieces01.tga`

OceanSpray's rail is `GW_V_bar_image`, a uniform blue bar at `(29,1,14,172)`.
Because it is uniform it is sliced as cap / tile / cap so it survives any height:

| Animation | Slice |
| --- | --- |
| `OS_A_VertRailTop` | `(29,1,14,8)` |
| `OS_A_VertRailMiddle` | `(29,80,14,8)` |
| `OS_A_VertRailBottom` | `(29,165,14,8)` |

### Buttons — `os_solwindow_pieces07.tga`

Normal frames listed; pressed and flyby frames sit adjacent in the same atlas.

| Button | Normal | Native size | Rendered `DecalSize` |
| --- | --- | --- | --- |
| LFG | `(154,120)` | 23x14 | 26x16 |
| Invite | `(120,55)` | 14x14 | 16x16 |
| Disband | `(120,71)` | 14x14 | 16x16 |
| Follow | `(120,87)` | 14x14 | 16x16 |
| Decline | `(120,109)` | 14x14 | 16x16 |

Decals render slightly above native size. If they look soft, reduce `DecalSize`
to native and keep the strip height.

**Buttons must use `<NormalDecal>` with an explicit `<DecalSize>`,** not the
`<Normal>` background slots OceanSpray used. This client renders the decal form
(the group role buttons use it); the background-slot form produces a working,
tooltip-responsive button with no visible icon.

### Decoration — `os_solwindow_pieces07.tga`

| Animation | Slice | Use |
| --- | --- | --- |
| `OS_A_GWHBar` | `(9,39,125,14)` | Blue bar across the top strip |
| `OS_A_GWBlackbox` | `(243,243,10,10)` | Black backing behind the strip |
| `OS_A_GWBlackline` | `(149,24,103,10)` | Dark line under each health gauge |

These draw first in the `Pieces` list so everything else layers over them.

## Draw template

`OS_WDT_GroupVert` is a clone of `AUM_WDT_VertSquare` — the template the chat
container uses — with only the three left-border slots swapped for the rail:

```xml
<LeftTop>OS_A_VertRailTop</LeftTop>
<Left>OS_A_VertRailMiddle</Left>
<LeftBottom>OS_A_VertRailBottom</LeftBottom>
```

Everything else is identical to a template already proven in this client.

## Movement and sizing

The window has no titlebar, so it is moved by two transparent `DragBox`
controls: `GW_DragBox1` on the blue top bar, `GW_DragBox2` on the strip below
row 3. This is the mechanism seven other windows in the skin use.

`Style_ClientMovable` was tried and did not work here; `DragBox` does.

**The window is not user-resizable.** `Style_Sizable` is `true` and bounds are
set, and the resize cursor appears, but dragging an edge does nothing. This was
tested against `AUM_WDT_VertSquare`, with and without the `GroupSize` table,
with and without `Style_SizableBorder*` flags, and with `ExpandUpwards` off.
Resize the window by editing XML instead:

- **Width:** change `<CX>` in `<Size>`. Nothing else needs touching — gauges and
  labels are `AutoStretch`, buttons are edge-anchored.
- **Height:** change `<CY>` and `<MinVSize>` together. Keep `CY` at or above
  159. Extra height becomes empty space below row 3 unless the rows are
  re-pitched.
- **Row pitch:** currently 48. Changing it means moving ~25 anchored elements;
  do it programmatically, not by hand.

The `GroupSize1`-`GroupSize11` table is **not present**. It was removed, blamed
for unrelated symptoms, restored, and removed again; with `ExpandUpwards` off
the window is stable without it. If restored, set all eleven entries to the same
value or the client will resize the window on every membership change.

## Corrections to the previous notes

The earlier version of this file described a different, now-replaced build. It
was wrong on these points:

1. **Skin folder.** It hardcoded `aumaar_vert`. The README says `aumaar`, and in
   any case the skin name is whatever the folder is called.
2. **Rail source.** It claimed the rail came from `solwindow_pieces07.tga` at
   `(8,53,16,16)`, `(8,69,16,16)`, `(8,153,16,16)`, coordinates read by eye. That
   atlas contains sliders, tab icons and `Blackline` — no rail. The rail is in
   `VertWindowPieces01.tga`, which was never imported. The old rail was arbitrary
   pixels from a slider sheet.
3. **What `solwindow_pieces07.tga` is for.** It was imported for the wrong
   reason but is genuinely needed — it holds every group-window button and all
   the decoration.
4. **Structure.** It kept the default-modern eleven-member layout with a titlebar
   and bottom button row. That is not the Vert layout. The original is
   titlebar-less with LFG top-left and invite/disband top-right.

The original `Vert33OceanSpray/EQUI_GroupWindow.xml` remains unsuitable as a
structural base — it is a fixed `154 x 192`, five-member window
(EQTypes 11-15, 17-21, 31-40) with hand-placed static images, no `GroupSize`
entries, and `Style_Sizable>false`. It is useful only as a source of artwork
coordinates, which is how it was used here.

## Rollback

1. Set `DrawTemplate` to `AUM_WDT_VertSquare` (loses the rail, keeps a working frame).
2. Remove the `OS_WDT_GroupVert` block from `EQUI_Templates.xml`.
3. Remove the marked OceanSpray blocks from `EQUI_Animations.xml`.
4. Delete `os_VertWindowPieces01.tga`.

## Pattern for later windows

1. Preserve the current window XML and EQTypes; change appearance, not behaviour.
2. Get slice coordinates from the source skin's own XML. Never read them off the
   atlas by eye — that is what broke the first attempt.
3. Copy assets under stable `os_` names rather than replacing global filenames.
4. Clone a draw template that already works in this client and swap only the
   slots that differ.
5. Check how an equivalent control is wired in a window that renders correctly
   before inventing markup — decal vs background slots, `DragBox` vs
   `Style_ClientMovable`.
6. Change one thing per test load.
