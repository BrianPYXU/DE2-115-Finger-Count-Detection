# Hardware Demonstration and Evidence

We tested the system on a DE2-115 board with a TRDB-D5M camera, using a green cloth background. The examples below cover gestures from 0 to 5.

Each row contains three views of one gesture: an external photograph of the hand, the processed image on the VGA monitor, and the board display. These are demonstration photographs, not three separate test trials.

The white area on the monitor shows the hand mask. A cyan cross and magenta/yellow circles visualize the estimated palm center and sampling geometry. On the board, **HEX0, the rightmost display, shows the finger count**. The other digits are debug outputs, not part of a multi-digit finger count.

| Count | Hand gesture | VGA mask and overlay | Board output |
| --- | --- | --- | --- |
| 0 | <img src="media/count-0-hand.jpg" width="180" alt="Closed-fist gesture"> | <img src="media/count-0-screen.jpg" width="180" alt="Processed closed-fist image"> | <img src="media/count-0-board.jpg" width="180" alt="HEX0 showing 0"> |
| 1 | <img src="media/count-1-hand.jpg" width="180" alt="One extended finger"> | <img src="media/count-1-screen.jpg" width="180" alt="Processed one-finger image"> | <img src="media/count-1-board.jpg" width="180" alt="HEX0 showing 1"> |
| 2 | <img src="media/count-2-hand.jpg" width="180" alt="Two extended fingers"> | <img src="media/count-2-screen.jpg" width="180" alt="Processed two-finger image"> | <img src="media/count-2-board.jpg" width="180" alt="HEX0 showing 2"> |
| 3 | <img src="media/count-3-hand.jpg" width="180" alt="Three extended fingers"> | <img src="media/count-3-screen.jpg" width="180" alt="Processed three-finger image"> | <img src="media/count-3-board.jpg" width="180" alt="HEX0 showing 3"> |
| 4 | <img src="media/count-4-hand.jpg" width="180" alt="Four extended fingers"> | <img src="media/count-4-screen.jpg" width="180" alt="Processed four-finger image"> | <img src="media/count-4-board.jpg" width="180" alt="HEX0 showing 4"> |
| 5 | <img src="media/count-5-hand.jpg" width="180" alt="Five extended fingers"> | <img src="media/count-5-screen.jpg" width="180" alt="Processed five-finger image"> | <img src="media/count-5-board.jpg" width="180" alt="HEX0 showing 5"> |

## What the available evidence establishes

| Material | What it records | Limit |
| --- | --- | --- |
| Hand, VGA, and board photographs | Functional examples for counts 0–5 under a green-background setup | Selected examples, without repeated-trial totals |
| Supplied Fitter summary | Resource use for a recorded Quartus build | Exact source revision not recorded with the report |
| Supplied timing summary | Reported slack for the paths covered by that build's constraints | External I/O timing is incompletely constrained |
| RTL source | The represented counting, buffering, voting, and display logic | No automated simulation testbench is included in this repository snapshot |

The capstone has been submitted. The photographs and compiler summaries are retained as historical project evidence. Editing these descriptions does not create a new hardware experiment or establish a missing source-to-bitstream mapping.

## Observed limitations

The selected examples show correct outputs, but the closed-fist/zero gesture was not always recognized correctly during testing. Bringing the hand too close to the camera could also cause errors. Background color and skin-color differences made segmentation difficult, which is why we used the green background.

These photographs show the capstone hardware demonstration. They do not establish an accuracy percentage, frame rate, or latency, and do not identify the exact source revision programmed on the board.

The following details were not recorded with the available results:

- Trial totals and per-count success, error, and invalid-output counts.
- A controlled series of camera distances, lighting conditions, or participants.
- Measured frame rate, analysis time, or stabilized-output response time.
- A source commit and bitstream identifier for each photograph or compiler report.

The displayed number must also be read in light of the voting policy: once accepted, an earlier count can be held during a later low-support window. See [display interpretation](SETUP.md#interpreting-the-stabilized-display). The photos alone do not measure how quickly the output follows a changed pose.

## FPGA build information

The supplied [Fitter summary](evidence/fitter_supplied.summary) reports 8,002 logic elements (7%) and 249,400 memory bits (6%). The [timing summary](evidence/timing_supplied.summary) has a minimum reported slack of 0.089 ns. These are existing compiler reports; compilation was not rerun while preparing this documentation. External camera, SDRAM, and VGA I/O timing remains incompletely constrained.

## Reading the results

The evidence supports a working demonstration of the pipeline under the stated setup, with known failure cases. The 50 MHz analysis clock is a processing clock, not a measured camera frame rate or count-update rate.

A later evaluation could investigate zero-count and near-camera failures while recording raw and stabilized results separately. Such work would be a new evaluation; it is not part of the submitted measurements.

For the project's goal and engineering observations, see the [project report](PROJECT_SUMMARY.md). For the method and implemented assumptions, see the [architecture](ARCHITECTURE.md).
