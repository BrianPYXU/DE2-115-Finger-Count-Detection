# Architecture and algorithm

## Camera and video path

The top-level `DE2_115_CAMERA` integrates camera configuration, capture, RAW-to-RGB conversion, the hand-analysis pipeline, SDRAM buffering, VGA output, and board controls. Camera/video support is inherited from the board example; the provenance is listed in [third-party notices](../THIRD_PARTY_NOTICES.md).

`skin_detect.v` applies an RGB threshold: valid pixels are foreground when red exceeds green by more than 100 and red exceeds 300, using the 12-bit RGB channels and a widened 13-bit comparison. This is a simple color heuristic whose behavior depends on lighting and background.

`hand_stream_adapter.v` aligns coordinates with the two-clock RGB latency and selects one pixel every five horizontal and vertical positions. A complete 800 × 600 raster therefore supplies 19,200 samples for a 160 × 120 mask.

## Capture and clock-domain ownership

`hand_mask_buffer.v` validates sample order and completeness before handing a mask bank to the 50 MHz analysis domain. A request/acknowledge handshake controls bank ownership. When analysis cannot accept another frame, capture can discard a whole frame rather than corrupt an in-progress analysis.

`hand_frame_ram.v` uses vendor M9K RAM for synthesis and a behavioral equivalent for simulation. Vendor simulation libraries are external toolchain dependencies and are not bundled.

`hand_reset_sync.v` synchronizes reset deassertion in each domain. `hand_debug_mailbox.v` transfers a stable analysis payload back into the camera domain for the overlay.

## Palm and wrist estimation

`hand_distance_circle.v` performs forward and backward passes of an integer chamfer distance transform, using costs 3 and 4 for axial and diagonal neighbors. Within the central search region, the foreground point with the greatest estimated distance to the background provides the palm-center estimate. The radius is derived from that distance divided by three.

The analyzer searches the central 75% of each image dimension for the palm. The default accepted radius is 5–40 analysis pixels. It selects the image side with the most foreground edge contact and uses the midpoint of the contact span to estimate the wrist entry. The direction from the palm center to that entry guides wrist-arc removal. A wrist-entry estimate is required by default.

## Circular sampling and counting

The angle lookup table contains 128 directions, giving 2.8125 degrees per bin. The analyzer samples rings at 2R, 1.875R, and 1.5R around the estimated palm center.

V2 uses the wrist direction to locate a foreground seed near the wrist, then removes the entire connected foreground arc on each ring. This addresses the residual wrist fragments that a fixed angular exclusion window can leave behind.

Counting starts on the 2R circle and uses the 1.875R circle to recover shorter candidates. The 1.5R ring is sampled but cannot independently add fingers. Angular-width thresholds reject overly narrow or broad arcs. Distinct arcs on the same ring remain separate; matching candidates across rings are merged, including wraparound at 0/360 degrees.

This is an extension-based geometric rule. The mask contains no finger-joint information and cannot uniquely distinguish two poses that produce the same silhouette.

## Stabilization and diagnostics

`hand_temporal_vote.v` uses an eight-analysis window with a five-vote acceptance threshold. Invalid results expire, a large palm displacement clears earlier votes, and no-hand results clear the output. Raw and stabilized results are exposed separately.

`hand_overlay.v` aligns RGB, validity, and debug graphics through four stages. The overlay marks the palm center and the two acceptance circles. It does not display measured confidence or a calibrated probability.

## Selected parameters

| Parameter | Default | Meaning |
| --- | ---: | --- |
| `MIN_AREA` | 100 | Foreground-area threshold for hand presence |
| `MIN_RADIUS` / `MAX_RADIUS` | 5 / 40 | Accepted palm radius in analysis pixels |
| `MIN_EXTENSION_EIGHTHS` | 15 | Secondary acceptance radius: 15/8 × R |
| `MIN_ARC` / `MAX_ARC` | 3 / 24 | Accepted arc widths in angular bins |
| `MERGE_BINS` | 4 | Cross-ring candidate matching tolerance |
| `MIN_WRIST_CONTACT` | 3 | Minimum edge-contact support |
| `REQUIRE_WRIST` | 1 | Require a wrist-entry estimate |
| `WINDOW` / `THRESHOLD` | 8 / 5 | Temporal vote window and acceptance count |
| `INVALID_LIMIT` | 6 | Invalid-analysis expiry threshold |
| `MOVE_LIMIT` | 20 | Palm-displacement reset threshold |

When changing `MIN_EXTENSION_EIGHTHS`, update both the analyzer and overlay defaults. The sampling geometry is fixed at 128 directions and must remain consistent with the lookup table. Changing resolution or scale requires changes to capture, coordinate alignment, mask dimensions, and tests together.

## Source reading order

1. `DE2_115_CAMERA.v`: how the system is wired.
2. `hand_detection/hand_pipeline.v`: how capture, analysis, and voting connect.
3. `hand_detection/hand_distance_circle.v`: the counting algorithm.
4. `hand_detection/hand_mask_buffer.v` and `hand_frame_ram.v`: frame integrity and ownership.
5. `hand_detection/hand_temporal_vote.v`: stabilized output.
