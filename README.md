We decided to import a rim light as our first shader because the rim light will happen when the player takes damage highlighting the player as red, and a toon shader because the game is a cartoony game and it brings the character to life.
For the post processing, we decided to important a blood affect to give feedback to the player when they are hit.

Toon Rim Shader

Properties within the Toon Rim Shader:

Color: Identifies the base color.
RampTex: Shading and adding textures like shadows.
RimColor: The color of the rim.
RimPower: How strong the rim will be.

Input for the Toon Rim Shader:

ViewDir: The location we’re looking at it from.
MainTex: Tracks where our colors will go on the object.

Lighting Toon Ramp:

What should be light and dark.
Makes things smoother.
Makes it look cartoony.

Surf glowing outline:

Base color and finds out where the edges are.
Makes the edges glow with rim color and how bright it is with rim power.
