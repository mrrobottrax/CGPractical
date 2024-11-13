Ivan Ho and Andrew Hoult

We didn't add the build as a release because there wasn't enough time.

# Shader 1: Rim light
(Rim Light.shader)

Intended to highlight the enemy with a red glow. Can also be used to show enemy or player taking damage.

## Properties:

_MainTex (Main Tex): The main texture used for the model.
_RimColor (Rim Color): The color of the rim lighting effect.
_RimIntensity (Rim Intensity): A multiplier to make the rim light appear brighter.
_RimPower (Rim Power): The exponent used for the rim lighting.

# Shader 2: Toon Shader
(Toon Shader.shader)

Gives the objects in the game a cartoonish feel.

## Properties:

_MainTex (Main Tex): The main texture used for the model.
_RampTex(Ramp Texture): The texture used filter the lighting. The right side represents the colour of full brightness. The left represents full darkness.

# Post Processing Effect: Damage Bleed
Damage.shadergraph

Pressing SPACE will cause a damage effect to appear. This affect causes to screen to turn red, and an image to be overlayed on top. This is driven by the _Damage property of the material.

This shader is applied fullscreen.

## Properties:

_Blood (Blood): The blood overlay texture to use when taking damage.
_Damage (Damage): A range from 0-1 specifying the intensity of the effect. Intended to fade from 1 to 0 after taking a hit.
