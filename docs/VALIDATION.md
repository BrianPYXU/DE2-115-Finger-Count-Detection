# Hardware results and build summaries

## Reported board demonstration

The project was tested on a Terasic DE2-115 with a TRDB-D5M camera and a green cloth as the background. The system successfully recognized finger counts **0–5**, with occasional incorrect results for the closed-fist/zero case.

These results describe the project team's qualitative functional demonstration. Trial counts, aggregate accuracy, measured processing latency, and frame rate were not recorded here.

## Expected operating conditions

- One hand, with the palm facing the camera and near the image center.
- A green background and a sufficiently complete foreground mask.
- Visible gaps between extended fingers.
- An arm entering through an image edge, with the palm and fingertips inside the frame.

## Known limitations

The zero case can occasionally be misclassified. Lighting and background affect the RGB-threshold mask. Touching fingers, occlusion, perspective changes, short thumbs, and protruding folded fingers can affect the geometric count. Temporal voting smooths fluctuations but does not correct consistently incorrect mask geometry.

## Supplied Quartus build summaries

The preserved [Fitter summary](evidence/fitter_supplied.summary) and [Timing Analyzer summary](evidence/timing_supplied.summary) are compiler-generated artifacts supplied with the project, rather than recognition benchmarks.

| Resource | Used / available |
| --- | ---: |
| Logic elements | 8,002 / 114,480 (7%) |
| Dedicated logic registers | 2,823 / 114,480 (2%) |
| Memory bits | 249,400 / 3,981,312 (6%) |
| Embedded 9-bit multiplier elements | 21 / 532 (4%) |
| PLLs | 1 / 4 (25%) |

The supplied timing summary has nonnegative reported slack, with a minimum of 0.089 ns. These are supplied build summaries; compilation was not rerun during documentation preparation. External camera, SDRAM, and VGA I/O constraints remain incomplete, so this is not a complete board-level timing sign-off.

## Future evaluation

A future benchmark could record repeated trials for each finger count, lighting and camera conditions, errors by class, and measured latency. The current portfolio presents the working hardware demonstration and its observed limitations without assigning an unmeasured accuracy percentage.
