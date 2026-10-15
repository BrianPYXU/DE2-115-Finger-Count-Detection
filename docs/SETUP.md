# Setup and board operation

## Requirements

- Terasic DE2-115 with Cyclone IV E `EP4CE115F29C7`.
- TRDB-D5M camera attached to the board's designated D5M connection, following the board/camera documentation and the project's pin assignments.
- VGA monitor and cable, USB-Blaster connection, and board power.
- Quartus Prime Lite 18.1 with Cyclone IV device support.
- PowerShell for the optional build script.

Tool installers and Quartus simulation libraries are external dependencies. Keep the repository path simple and extract the complete project before opening it.

## Supported configuration

The documented hand-analysis configuration is 800 × 600 camera processing, five-pixel subsampling in each direction, and a 160 × 120 mask. The RGB coordinate alignment assumes two clocks of RAW-to-RGB latency.

The `SCALE` declaration in the stream adapter does not make the current constant-based sampling logic freely configurable. Likewise, the inherited 640 × 480 macro does not switch all hand-analysis dimensions together. See [configuration scope](ARCHITECTURE.md#configuration-scope) for these limits.

## Build

Open `DE2_115_CAMERA.qpf` in Quartus and confirm the top-level entity `DE2_115_CAMERA` and device `EP4CE115F29C7`. Run **Processing → Start Compilation**.

Alternatively, from the repository root:

```powershell
.\build.ps1 -QuartusRoot C:\intelFPGA_lite\18.1\quartus
```

The original script records the build log in `docs/quartus_compile.txt`, checks Quartus exit status, and checks the reported timing-summary slack. Nonnegative internal slack does not establish complete external I/O timing closure.

The `.qpf` header retains the original example's Quartus 9.1 metadata. The supplied compilation evidence was produced with Quartus Prime Lite 18.1.

## Program

1. Set the board's RUN/PROG switch to RUN.
2. Open **Tools → Programmer**, choose JTAG mode and the connected USB-Blaster.
3. Add the newly built `output_files/DE2_115_CAMERA.sof`.
4. Select **Program/Configure** and start programming.
5. Press KEY0 to reset the system and start capture.

JTAG `.sof` configuration is volatile and is lost when power is removed. Persistent flash programming is outside this repository's instructions.

## Switches and displays

| Control | Behavior |
| --- | --- |
| SW17 off | Color camera image |
| SW17 on, SW15 off | White foreground / black background mask |
| SW17 on, SW15 on | Mask with cyan palm marker, magenta 1.875R circle, yellow 2R circle |
| SW14 on | Enable HEX1–HEX3 diagnostics |
| SW16 | Inherited camera scaling option; reset and recheck the silhouette after changing it |
| KEY0 | Reset |
| KEY1, SW0 | Inherited exposure adjustment controls |
| HEX0 | Last accepted stabilized count; `E` when the display-valid flag is clear |
| HEX1 | Latest raw count; interpret together with HEX2 |
| HEX2 | Analysis error code |
| HEX3 | Leading vote count from the latest completed vote scan; it may differ from support for a held HEX0 result |

| HEX2 | Meaning |
| --- | --- |
| 0 | Normal analysis, including an empty frame |
| 1 | Incomplete, misordered, or incompatible mask frame |
| 2 | Palm radius outside the accepted range |
| 3 | No usable wrist entry |
| 4 | More than five candidates |

LEDG[8] indicates stabilized-result validity, LEDG[7] raw validity, LEDG[6] hand presence, LEDG[5] analysis busy, LEDG[4:1] the error code, and LEDG[0] capture handoff waiting. LEDR mirrors the switches.

## Interpreting the stabilized display

The count is accepted when one candidate reaches five votes within an eight-analysis window. After acceptance, a later window without five votes for any candidate retains the earlier count and its valid flag. A low HEX3 value does not automatically make HEX0 change to `E`.

For example, after zero has been accepted, a window containing four results of 1 and four results of 2 can still display the earlier zero. This describes the implemented retention rule, not an additional hardware accuracy measurement.

Other events have separate behavior:

- At startup, the display waits for an accepted result.
- A large palm displacement clears the voting context and requires a newly accepted count.
- Six consecutive invalid analyses clear display validity; the counter measures analyses, not a fixed number of milliseconds.
- A valid no-hand analysis immediately clears the history and displays zero. Use the hand-presence indicator to distinguish this from a detected closed fist.

HEX1 is the raw analysis result, HEX2 supplies its error context, and HEX3 reports leading vote support. Read these together when interpreting a held HEX0 value. The [architecture](ARCHITECTURE.md#stabilization-and-diagnostics) describes the voting behavior in more detail.

## First hardware inspection

Use a single hand against a green background. Keep the palm near the image center and the fingertips inside the image. Let the arm enter from an image edge and keep visible gaps between extended fingers.

Start by inspecting the binary mask with SW17. Then inspect the palm marker and acceptance circles with SW15. Check raw HEX1 and the error code before judging the stabilized HEX0 result. Hold each pose long enough to observe multiple analyses, and check counts 0–5.

The team observed incorrect counts when the hand was too close to the camera. If this occurs, move the hand farther away and inspect the mask and palm estimate again. Additional evaluation could compare different hand distances and orientations; the photographs in this repository do not establish performance across all such conditions.

The saved photographs document the capstone demonstration rather than a controlled repeated-trial evaluation. See [validation](VALIDATION.md) for the available evidence and its limits. Any later evaluation should record both successes and failures, test conditions, and the programmed source revision.
