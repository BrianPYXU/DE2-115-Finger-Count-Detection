# Completing the admissions portfolio

The source and documentation explain the system. A small amount of real demonstration material will make it easier for a professor to assess the project without FPGA hardware.

## Recommended additions

1. Add the existing result photographs under `docs/media/`. Place a clear board-and-monitor photo near the top of the README, followed by selected outputs for 0–5.
2. Record a short video showing the camera setup, mask/debug view, and seven-segment output. Include the occasional zero-case error as a known limitation.
3. Optionally include the original final report, poster, or slides. The [English project summary](PROJECT_SUMMARY.md) provides a concise introduction based on the source and reported hardware results.

Use actual project photographs rather than generated illustrations of results. Label the tested source version and the green-cloth setup. For large videos, link to a hosted demonstration instead of putting the entire file in Git history.

The team acknowledgment already states that two students jointly developed the project. Separate module-by-module responsibilities are not required for this presentation.

## Suggested GitHub metadata

Description:

> Verilog FPGA finger counting on the Terasic DE2-115 with a TRDB-D5M camera, chamfer distance transform, circular sampling, and VGA diagnostics.

Topics:

`fpga`, `verilog`, `cyclone-iv`, `de2-115`, `computer-vision`, `finger-counting`, `image-processing`, `undergraduate-project`

Link directly to the repository in the application. Preserve the original notices for inherited board-support code and confirm the public distribution scope before uploading it.
