# Project Report: FPGA Finger Counting

## Project goal

We chose this project to practice RTL design and gain experience implementing and testing a hardware system. Image processing provided visible results: we could compare the hand gesture, the processed mask on a monitor, and the count displayed by the FPGA board.

We considered detecting left or right movement, then chose finger counting to include more shape analysis. This required us to separate the hand from the background, estimate the palm, and distinguish fingers from the wrist. We used arithmetic and geometric rules that could be implemented directly in RTL. The design does not use a trained neural network.

## How the system works

The project uses a DE2-115 FPGA board, a TRDB-D5M camera, and a VGA monitor. The analysis is written in Verilog and uses the board's seven-segment display to show the count.

First, RGB thresholds produce a binary hand mask. A distance transform estimates the palm center and size. The system then samples the silhouette along circles around the palm, excludes the wrist region, and counts the remaining finger candidates. Voting over successive analysis results helps stabilize the displayed count.

The camera and display path includes existing Terasic/Altera support code. Our work focused on the hand-analysis path and its integration with the board outputs. See [architecture](ARCHITECTURE.md) for the source modules and parameters.

## Problems we encountered

### Separating the hand from the background

The most difficult part was deciding which pixels belonged to the hand. Skin color varies between people, and some background colors could also pass the color thresholds. When the mask was wrong, the later finger-counting steps could give the wrong result even if the hand gesture was clear to us.

We used a fixed green cloth background for testing. This made it easier to separate the hand from the background, but also limited the conditions under which we demonstrated the system. We did not establish that it works across arbitrary skin tones or backgrounds.

### Avoiding an extra count from the wrist

The wrist could be counted as another finger. To address this, we used the estimated palm center together with the part of the foreground touching an image edge to estimate the wrist direction. The counting logic excludes the connected wrist arc from the circular samples.

This helped reduce the wrist problem in our tests. However, moving the hand too close to the camera could still produce incorrect counts.

## Results and future work

We demonstrated finger counts from 0 to 5 against the green background. The [photo examples](VALIDATION.md) show the actual gestures, processed monitor views, and board outputs. The closed-fist/zero case was occasionally misclassified during testing. We did not record enough repeated trials to report an accuracy percentage.

A useful next step would be to investigate the near-camera failure by comparing the mask, estimated palm position, and count at different hand distances. This would help determine whether to improve the geometry rules or detect when the hand is outside the usable range. Repeated trials would also allow a more systematic evaluation of the zero-case errors.

## Collaboration

This project was developed jointly by two students, with most work carried out together. The documentation describes the team's shared work. The source files retain the original notices for inherited Terasic/Altera components; see [team acknowledgment](AUTHORS.md) and [third-party notices](../THIRD_PARTY_NOTICES.md).
