# Undergraduate Capstone: FPGA-Based Finger Counting

## Abstract

This collaborative undergraduate capstone implements a finger-counting system on the Terasic DE2-115 FPGA board with a TRDB-D5M camera. The Verilog design combines color-threshold segmentation, palm estimation using a chamfer distance transform, and multi-radius circular sampling. A temporal vote stabilizes the result, while VGA diagnostics expose the binary mask and analysis geometry. Hardware tests demonstrated finger counts from 0 to 5 against a green-cloth background, with occasional errors for the closed-fist case.

## Objective

The objective was to implement a complete camera-to-output image-processing system on an FPGA. The work connects geometric image analysis with practical hardware integration: frame storage, multiple clock domains, board controls, and visible debugging output.

The count is inferred from the hand silhouette. No trained neural network is used by this implementation.

## Hardware and implementation

The system targets a Cyclone IV E `EP4CE115F29C7` on the DE2-115. The camera pipeline processes an 800 × 600 image and supplies a 160 × 120 binary mask to a 50 MHz analysis domain. Existing Terasic/Altera infrastructure provides camera configuration, RAW-to-RGB conversion, SDRAM buffering, and VGA support.

The project adds the hand-analysis path and integrates its result with the board's seven-segment displays, LEDs, and video overlay. Detailed source mapping is provided in [architecture](ARCHITECTURE.md).

## Method

1. **Segmentation:** a threshold on the 12-bit RGB channels separates the hand from the green-background setup.
2. **Mask capture:** coordinate alignment and subsampling produce a complete 160 × 120 binary frame. A handshake controls transfer to the analysis domain.
3. **Palm estimation:** a two-pass integer chamfer distance transform estimates the palm center and radius.
4. **Wrist estimation:** image-edge foreground contact provides a wrist direction.
5. **Finger counting:** 128 angular samples are taken at three radii. Connected wrist arcs are removed; sufficiently extended candidates on the 1.875R and 2R circles contribute to the count, with cross-ring merging to reduce duplicates.
6. **Output stabilization:** an eight-analysis vote window with a five-vote threshold produces the displayed count. Invalid or stale results are handled explicitly.

## Engineering considerations

The design uses integer arithmetic and a constant angle lookup table to suit FPGA implementation. It separates camera capture from analysis through controlled mask ownership and synchronizes reset release across clock domains.

Debugging is part of the system interface: switches select color, binary-mask, or geometry-overlay views; additional displays expose raw count, error code, and vote support. This helps distinguish segmentation errors from geometry or stabilization issues.

V2 removes the whole connected wrist arc instead of a fixed wrist-angle window and requires finger candidates to reach the outer acceptance circles. These rules are intended to reduce false counts from broad wrists and short folded-finger protrusions; their effectiveness across arbitrary conditions has not been quantified.

## Results

Hardware testing demonstrated counts 0–5 with a green cloth background. The closed-fist/zero case occasionally produces an incorrect result. This is a functional demonstration, with no measured accuracy percentage or frame-rate claim.

The supplied Quartus Fitter summary reports 8,002 logic elements (7%) and 249,400 memory bits (6%). These compiler figures describe resource use, not camera recognition performance. See [hardware results](VALIDATION.md) for evidence scope and limitations.

## Limitations and future work

The approach depends on a sufficiently clean binary silhouette, visible gaps between fingers, and an arm entering through an image edge. Occlusion, short thumbs, lighting variation, and folded fingers with large protrusions can cause incorrect counts. Similar silhouettes can correspond to different hand poses, which limits what geometry alone can distinguish.

Future work could improve segmentation under changing illumination, investigate zero-case errors, evaluate repeated trials under controlled conditions, and complete the external I/O timing constraints.

## Collaboration and source provenance

Two students jointly developed this capstone, with most work completed together. The repository acknowledges the shared contribution collectively. Inherited Terasic/Altera components retain their original notices; see [source provenance](../THIRD_PARTY_NOTICES.md).
