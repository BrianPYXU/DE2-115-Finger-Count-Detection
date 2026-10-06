# Third-party notices and publication status

## Terasic board-example code

The project builds on a DE2-115 camera/video example. Terasic copyright and permission notices appear in:

- `DE2_115_CAMERA.v`.
- Camera, I2C, RAW-to-RGB, reset, seven-segment, and VGA support files under `v/`.
- SDRAM controller files under `Sdram_Control/`.

The notices grant use and modification for synthesis on specified Terasic boards and development kits, and contain restrictions on other use, including duplication. The notices are preserved verbatim in the files.

This draft does not establish a public-redistribution right for those sources. Before publishing the complete project publicly, confirm the applicable original distribution terms or obtain permission. Attribution alone does not establish permission to redistribute. If permission is unavailable, publish only team-owned material and documentation, and describe how authorized users obtain the vendor dependencies themselves. Such a reduced publication must clearly identify the missing board-integration dependencies.

## Altera/Intel generated IP and project files

PLL, line-buffer, FIFO wrappers, block symbols, and Quartus project files contain Altera notices referring to applicable tool/IP license agreements. Their presence does not make these files subject to a new repository-wide license.

The `altsyncram` simulation model is loaded from the user's Quartus installation when requested. Its library is not included in this repository.

## Team-owned additions

The `hand_detection/` modules are presented as project additions developed collaboratively by the two-student team. Confirm applicable school/project terms and ownership with the team before selecting a license.

No MIT, Apache, or other blanket license has been applied. This file records provenance and unresolved publication questions; it is not a replacement license.

## Dependencies and references

- [Terasic](https://www.terasic.com/): board and camera vendor; obtain the applicable original board/camera package and its terms.
- Quartus Prime Lite 18.1: external FPGA toolchain with Cyclone IV support.

Retain all original copyright headers when exporting the project. Review code, media, and any report separately before public distribution.
