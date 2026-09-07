# Changelog

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
