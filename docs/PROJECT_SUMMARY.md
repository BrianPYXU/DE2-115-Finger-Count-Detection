# Project Report: FPGA Finger Counting

## Project goal

My teammate and I chose this undergraduate capstone to practice RTL design and gain experience building a hardware system. Image processing gave us a visible way to inspect our work: a hand gesture could be compared with the binary mask on a monitor and the count on the FPGA board.

We initially considered detecting left or right movement, then chose finger counting to include more shape analysis. The task required us to separate the hand from the background, estimate the palm, distinguish fingers from the wrist, and stabilize the displayed result.

The capstone has been submitted. This report describes the implementation and evidence available in the repository.

## System and implementation

The system uses a Terasic DE2-115 FPGA board, a TRDB-D5M camera, and a VGA monitor. Verilog logic analyzes a binary hand mask and sends the count to the board's seven-segment display.

The processing path is:

1. Apply RGB thresholds to obtain a foreground mask.
2. Sample the 800 × 600 input into a 160 × 120 analysis mask.
3. Estimate the palm center and radius using a two-pass integer distance transform.
4. Estimate the wrist direction from foreground contact near an image edge.
5. Sample circles around the palm, remove the connected wrist arc, and count the remaining finger candidates.
6. Use temporal voting to stabilize the output.

The camera, VGA, SDRAM, and generated IP infrastructure includes inherited Terasic/Altera material. Our work focused on the hand-analysis path and its integration with the board outputs. See [architecture](ARCHITECTURE.md) for the modules and parameters, and [source attribution](../THIRD_PARTY_NOTICES.md) for provenance.

## Problems and design decisions

### Segmentation affected everything downstream

Deciding which pixels belonged to the hand was the main practical difficulty. Skin color, lighting, and similar-colored background objects could change the binary mask. Once fingers were missing or connected in the mask, later geometric processing could give a wrong count even when the original hand pose was clear to us.

We used a green-cloth background for hardware testing. The VGA mask view let us inspect the foreground before interpreting the final count. The palm marker and sampling circles provided another view of how the geometry was behaving.

This setup made the demonstration easier to inspect. It also limited what the results could establish: we did not demonstrate reliable operation across arbitrary people, lighting, or backgrounds.

### The wrist could look like another finger

Circular samples can intersect the wrist as well as the fingers. The implementation estimates where the arm enters the image and uses that direction to remove the connected wrist arc on each sampled ring.

The 2R and 1.875R circles provide accepted finger candidates. The 1.5R circle is sampled, but inner-only arcs do not independently increase the count. Width filtering and cross-ring merging reduce unwanted and duplicate candidates.

The project report previously identified wrist miscounting as a practical problem. The source documents how it is addressed, but the repository does not contain a controlled before/after experiment measuring the improvement.

### A stable display can retain an earlier result

The voting logic uses an eight-analysis window and a five-vote acceptance threshold. A count that reaches the threshold becomes the displayed result.

When a later window has no count reaching five votes, the submitted logic retains the last accepted count and its valid flag. Thus, the displayed count can remain unchanged while the raw count and leading vote support change. Movement reset, invalid-result expiry, and valid no-hand analyses have separate behavior.

This is part of the implemented display policy. The [architecture](ARCHITECTURE.md#stabilization-and-diagnostics) and [setup guide](SETUP.md#interpreting-the-stabilized-display) explain how to interpret it.

## Results and evidence

The [hardware examples](VALIDATION.md) show finger counts from 0 to 5 against the green background. Each gesture has an external hand photograph, a VGA view, and a board-output photograph.

The closed-fist/zero case was occasionally misclassified. Bringing the hand too close to the camera could also produce incorrect counts. No repeated-trial totals were recorded from which to calculate accuracy, and measured frame rate and response latency are unavailable.

The supplied Quartus reports list resource use and internal timing results for a recorded build. The photographs and reports have not been tied to an exact source revision. They are preserved as project evidence with those limits stated explicitly.

## What this project demonstrates

The project brings together geometric image analysis, sequential RTL, frame buffering, clock-domain handshakes, and board-level diagnostics. Its most useful engineering lesson is the dependence between stages: a stable numeric output is easier to understand when the mask and intermediate geometry can also be inspected.

A useful later investigation would compare the mask, palm estimate, and sampled arcs at different hand distances, particularly for zero-count failures. Such an evaluation is future work and is not included in the submitted results.

## Collaboration

This was a two-student capstone, with most work carried out together. The report uses “we” for the team's shared work rather than assigning whole modules to one person. See [team acknowledgment](AUTHORS.md).

## Further reading

- [Project overview](PORTFOLIO.md)
- [Architecture and implemented behavior](ARCHITECTURE.md)
- [Hardware examples and evidence limits](VALIDATION.md)
- [Setup and board operation](SETUP.md)
