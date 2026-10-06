# Hardware Demonstration

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

## Observed limitations

The selected examples show correct outputs, but the closed-fist/zero gesture was not always recognized correctly during testing. Bringing the hand too close to the camera could also cause errors. Background color and skin-color differences made segmentation difficult, which is why we used the green background.

These photographs show the capstone hardware demonstration. They do not establish an accuracy percentage, frame rate, or latency, and do not identify the exact source revision programmed on the board.

## FPGA build information

The supplied [Fitter summary](evidence/fitter_supplied.summary) reports 8,002 logic elements (7%) and 249,400 memory bits (6%). The [timing summary](evidence/timing_supplied.summary) has a minimum reported slack of 0.089 ns. These are existing compiler reports; compilation was not rerun while preparing this documentation. External camera, SDRAM, and VGA I/O timing remains incompletely constrained.
