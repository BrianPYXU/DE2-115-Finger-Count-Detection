# Project Overview: FPGA Finger Counting

A two-student undergraduate capstone implementing geometric finger counting in Verilog on a Terasic DE2-115 board with a TRDB-D5M camera.

## Goal and outcome

We chose the project to practice RTL design and integrate an image-analysis path with working hardware. The system extracts a hand mask, estimates the palm and wrist, and counts finger candidates along circles around the palm. A VGA monitor shows the mask and analysis overlay, while the board displays the stabilized count.

The saved hardware examples cover counts 0–5 under a green-cloth setup. Zero-count and near-camera errors remained, and aggregate accuracy, frame rate, and latency were not measured.

## Engineering content

| Area | Where to look |
| --- | --- |
| Foreground extraction and geometric counting | [Architecture](ARCHITECTURE.md): RGB thresholds, distance transform, wrist removal, and circular samples |
| Hardware integration | [Architecture](ARCHITECTURE.md): mask ownership, clock-domain handshakes, and debug metadata |
| Debugging and design choices | [Project report](PROJECT_SUMMARY.md): segmentation and wrist-counting problems |
| Hardware evidence | [Demonstration](VALIDATION.md): hand, VGA, and board photographs for counts 0–5 |
| Build and operation | [Setup guide](SETUP.md): toolchain, programming, switches, and display interpretation |

## Reading the evidence

The photographs establish functional examples under the recorded setup. They are not repeated-trial statistics. The supplied Quartus summaries record resource use and internal timing results for an existing build; external I/O timing is incompletely constrained, and an exact source revision has not been established for the historical evidence.

The display uses a last-accepted-result policy: once a count is accepted, a later window without a five-vote majority can retain that earlier count. The [display explanation](SETUP.md#interpreting-the-stabilized-display) separates raw count, vote support, and stabilized output.

## Team and scope

Most work was carried out jointly by two students. The hand-analysis path and integration are presented as shared contributions. The camera, SDRAM, VGA, and generated IP support includes inherited Terasic/Altera material; see [team acknowledgment](AUTHORS.md) and [source attribution](../THIRD_PARTY_NOTICES.md).

The capstone has been submitted. These pages describe the completed project and its available evidence.

[Return to the repository introduction](../README.md)
