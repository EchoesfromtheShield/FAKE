# Changelog

## Version 1.1

- Fixed the macro filter LFO sine-wave issue that could make one half of the cycle sound truncated.
- Changed `Base` and `Sweep` display in Filter Automation from percentage values to frequency values.
- Fixed the filter behavior so `Cutoff` and `Resonance` are independently adjustable on the filter page; they are now only overridden when the macro filter or filter LFO is active.
- Made the SuperCollider engine self-contained by bundling namespaced local helper classes, removing the practical dependency on `pixels` / `thebangs` for clean installs.
- Implemented MIDI transport send and receive.
- Added selectable MIDI input channel listening for the script.
- Extended Tempo Subdivision with slower values: `8`, `16`, and `32`.
- Added a dedicated Chord Engine page with `Chord Chance` and `Tempo Multiplier`.
- Added `Root Accent` to the Rhythm Engine, allowing root note changes to force an event on the next available step.
- Added a Scenes page with save/load of full parameter snapshots.
- Updated the Norns MIDI-mappable parameter set to include the new controls.
- Updated the README.
