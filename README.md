# Water Shader with Buoyancy in Godot
This repository contains the code and resources for creating a water shader with buoyancy effects in the Godot 4 Engine. The project demonstrates how to use Gerstner waves to simulate realistic water surfaces and incorporate buoyancy to make objects like boats float and react naturally to the wave movements.

[Blog Post](https://www.seacreaturegame.com/blog/gerstner-waves-with-buoyancy-godot)

## Features
Gerstner Waves Simulation: Utilizes mathematical properties to accurately model ocean wave movements.
Buoyancy Effects: Objects such as boats float and react dynamically to the wave patterns.
Realistic Shading: Adjusts color blending based on water depth and wave height to create realistic water and foam effects.
Interactive Buoyancy: Updates the position of floating objects based on wave height, ensuring a natural interaction with the ocean surface.
Getting Started
Follow these instructions to set up the project locally.

## Prerequisites
- Godot Engine

## Installation
- Clone the repository:
``` git clone https://github.com/stvgale/realistic-ocean-shader.git ```
- Open the project in Godot Engine

## Shader Setup
The water shader is set up with parameters for Gerstner waves, including amplitude, steepness, wavelength, and direction for each wave component.

## Buoyancy Implementation
The buoyancy effect is achieved by updating the position of objects based on the wave height at their location. This ensures that objects like boats float and react naturally to the wave movements.

## Example
An example scene is provided where a boat interacts with the ocean shader, demonstrating the buoyancy effect in action.

## Contributing
Contributions are welcome! Feel free to open an issue or submit a pull request.

## License
This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments
Inspired by various resources and tutorials on ocean simulation and shading in game development.
Special thanks to the Godot community for their support and contributions.
