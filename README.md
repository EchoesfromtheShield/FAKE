# F.A.K.E.

Failed At Keyboard Education  
by Echoes from the Shield

A special thanks to Arman Bohn and [`pixels`](https://github.com/distropolis/pixels), which strongly inspired this script. FAKE borrows the underlying idea of a generative, voice-driven Norns instrument from `pixels`, and includes namespaced local adaptations of two helper SuperCollider classes originally used there: the waveform/performance helper behind the engine (`Bgs`) and the voice allocator (`OneshVoicer`).

## Overview

F.A.K.E. is a generative arpeggiator built around Scale Presence: a control that limits or expands the harmonic pool used by the pattern engine, from sparse tonal anchors to full-scale motion. The script combines:

- weighted note selection
- octave spreading
- probabilistic density control
- chord and freeze performance gestures
- macro filtering with optional LFO
- deterministic timbre, presence, and rhythm automation
- a reactive pixel-art transmission tower visualizer

The script is designed as a self-running pattern machine rather than a keyboard-following arpeggiator. Incoming MIDI note input sets the root pitch class and then the system continues autonomously.

## Core Musical Model

### Root Note

- Root is selected manually or by MIDI note input.
- MIDI note input is pitch-class only: octave is ignored.
- The last received MIDI `note_on` sets the root until the next incoming note.
- Internally the root reference frequency is derived from A440 and then transposed by pitch class.

### Scales

Included scales:

- Harmonic Minor
- Major
- Natural Minor
- Pentatonic Major
- Pentatonic Minor
- Dorian
- Phrygian
- Lydian
- Mixolydian
- Locrian
- Harmonic Major
- Diminished
- Whole Tone
- Hungarian Major
- Hungarian Minor
- Arabic
- Hirajoshi
- Egyptian
- Blues

### Scale Presence

Scale Presence defines which scale degrees are available to the weighted note selector.

States:

- None
- Low
- Medium
- High

F.A.K.E. does not treat these as simple equal-probability note lists. It builds weighted profiles from harmonic roles.

#### Harmonic degree weighting

Base degree weights:

- 0 -> 1.00
- 7 -> 0.82
- 4 / 3 -> 0.66
- 2 -> 0.46
- 1 -> 0.38
- 5 -> 0.34
- 9 -> 0.30
- 8 -> 0.28
- 10 -> 0.24
- 11 -> 0.22
- 6 -> 0.18
- default fallback -> 0.20

Role target priorities:

- dominant targets: 7, 8, 6, 9, 5
- mediant targets: 4, 3, 5, 2
- color A targets: 2, 1, 9, 10, 5
- color B targets: 5, 6, 8, 10, 11

If a target degree is missing from the selected scale, the script chooses the nearest available interval by circular semitone distance, with a small role-priority bias.

#### Presence profiles

`None`

- target size: 2
- role weights:
  - root 0.72
  - dominant 0.28
- fallback weight scale: 0.45

`Low`

- target size: 3
- role weights:
  - root 0.46
  - dominant 0.32
  - mediant 0.22
- fallback weight scale: 0.50

`Medium`

- target size: 5
- role weights:
  - root 0.34
  - dominant 0.24
  - mediant 0.18
  - color A 0.14
  - color B 0.10
- fallback weight scale: 0.60

`High`

- full scale
- each scale degree uses its base harmonic weight

### Octave Spread

Available octave modes:

- `-2`
- `-1`
- `0`
- `+1`
- `+2`
- `+/-1`
- `+/-2`

Internal octave sets:

- `0` -> `{0}`
- `+1` -> `{0, 1}`
- `+2` -> `{0, 1, 2}`
- `-1` -> `{-1, 0}`
- `-2` -> `{-2, -1, 0}`
- `+/-1` -> `{-1, 0, 1}`
- `+/-2` -> `{-2, -1, 0, 1, 2}`

Octave weights:

- central octave `0` -> 1.00
- `+/-1` -> 0.85
- `+/-2` -> 0.70
- default fallback -> 0.55

### Phrase Memory and Movement Bias

The note engine remembers the previously selected pitch step and weights new candidates by melodic distance.

Movement weights:

- repeat note -> 0.28
- step (distance <= 2 semitones) -> 1.35
- near (<= 5) -> 1.05
- leap (<= 9) -> 0.72
- far (> 9) -> 0.45

This prevents flat uniform randomness and favors coherent short-range motion.

### Weighted Note Selection

For each event, candidate notes are built from:

- current Scale Presence profile
- current octave set
- octave weights
- movement bias

Each final candidate weight is:

`profile weight * octave weight * movement weight`

The next note is chosen with weighted random selection over that candidate list.

## Playback Model

### Normal Mode

One note is generated per clock event.

### Chord Mode

Chord mode is engaged manually by holding `K3` or automatically by the Rhythm Engine.

Chord construction:

- chord size: 3 notes
- the script simulates the next 3 weighted note choices sequentially
- duplicate pitch steps are excluded within the same chord
- the final chosen note in the chord updates phrase memory

### Probability

- Range: 5 to 100 percent
- Applied per event after timing is determined
- In normal mode it gates single notes
- In chord mode it gates whole chord events

### Dynamics

F.A.K.E. can add per-event level variation to avoid a flat, fully constant output level.

States:

- None
- Low
- Medium
- High

The dynamic engine is intentionally simple:

- most notes stay near full level
- some notes are attenuated
- a small number of notes receive a slight accent
- the same level scale is applied to all notes in a single chord event

This is not MIDI velocity tracking. It is an internal event-level amplitude model.

#### Dynamics: None

- fixed event level
- scale = `1.00`

#### Dynamics: Low

- attenuation chance: `35%`
- accent chance: `7%`
- attenuation range: `0.72 .. 0.95`
- accent range: `1.00 .. 1.05`

#### Dynamics: Medium

- attenuation chance: `60%`
- accent chance: `12%`
- attenuation range: `0.58 .. 0.95`
- accent range: `1.00 .. 1.07`

#### Dynamics: High

- attenuation chance: `80%`
- accent chance: `16%`
- attenuation range: `0.38 .. 0.95`
- accent range: `1.00 .. 1.10`

## Clock and Timing

### Tempo Subdivision

Available subdivisions:

- `4`
- `2`
- `1`
- `1/2`
- `1/4`
- `1/8`
- `1/16`
- `1/32`

The sequencer uses `clock.sync()` on the current effective subdivision.

### Chord Timing

When chord mode is active, the effective subdivision is multiplied by `2`.

Result:

- the same subdivision produces half as many events in chord mode
- chord mode feels slower and more spacious than note mode

## Freeze Model

Freeze is available only while chord mode is held.

Behavior:

- `K1` arms freeze while chord mode is active
- the next qualifying chord event becomes the frozen chord
- the frozen chord is sustained by the engine until release
- releasing `K1` does not cut immediately
- the frozen chord enters a quantized fade-out
- new sequencer events are held back until that fade-out has completed

Freeze release time:

- derived from the current chord step duration
- clamped to 0.15 to 3.0 seconds

There is also a small freeze-arm grace window after the chord clock edge:

- `12%` of the current step
- minimum `12 ms`
- maximum `30 ms`

This helps capture freeze intention close to the clock boundary without making the timing feel loose.

## Sound Engine

Engine: custom Crone engine wrapping `Bgs`

### Polyphony

- normal voices: 8
- freeze voices: 8

### Waveforms

UI waveform values:

- 0
- 1
- 2
- 3
- 4
- 5

Internal mapping:

- 0 -> `square`
- 1 -> `square_mod1`
- 2 -> `square_mod2`
- 3 -> `sinfmlp`
- 4 -> `sinfb`
- 5 -> internal waveform `6` -> `klanglin`

Internal waveform `5` (`reznoise`) is intentionally removed from the UI.

Waveform gain compensation:

- waveform 3 -> `1.20`
- waveform 5 / internal 6 -> `1.25`
- all others -> `1.00`

### Engine Parameters

- Attack: `0.001` to `10`
- Release: `0.1` to `10`
- Mod2: `0` to `1`
- Cutoff: `40` to `16000 Hz`
- Resonance: `0` to `4`
- Drive: `0` to `1`
- Pan Rate: `0` to `12 Hz`
- Pan Depth: `0` to `1`

Per-event amplitude:

- default scale: `1.00`
- applied as a snapshot multiplier before each note or chord event
- internal clip range in the engine: `0.4 .. 1.1`

### Internal Audio Processing

Per voice:

- `FAKE_Bgs.perform(...)`
- soft saturation via `tanh`
- `LeakDC`
- `RLPF`
- optional sinusoidal autopan with random phase per voice

Filter mapping:

- resonance `0..4`
- `rq` mapped from `1.0` down to `0.08`
- resonance boost mapped from `1.0` to `1.12`

Drive mapping:

- drive gain = `1 + drive * 8`
- output trimmed by `driveGain ^ -0.35`

## Macro Filter

The visualizer page exposes a macro filter on `E2`.

Mapping:

- minimum position -> cutoff `500 Hz`, resonance `4`
- maximum position -> cutoff `16000 Hz`, resonance `0`

This macro updates the same cutoff and resonance parameters used on the dedicated filter page.

## Filter Automation

Page 5 modulates the macro filter from Lua.

Parameters:

- LFO Rate: `0..4 Hz`
- LFO Depth: `0..1`
- LFO Wave: `Sine`, `Triangle`, `Square`

Behavior:

- the manual macro filter position is the base
- the LFO modulates around that base
- modulation amount is `waveValue * depth * 0.5`
- final macro position is clamped to `0..1`

The LFO runs in the visual refresh metro, not as an audio-rate modulation.

## Timbre Automation

Page 6 controls deterministic waveform motion.

Parameters:

- Motion: On/Off
- Preset
- Rate: `0.25x..4.00x`

General behavior:

- the manual `WaveType` acts as the anchor
- each preset is a deterministic offset sequence around that anchor
- durations are also preset-driven
- each time a preset cycle wraps, its order and duration sequences may rotate
- effective duration is `round(base duration / rate)` with a minimum of 1 step

Timbre motion advances on every sequencer step, except while freeze is active or releasing.

### Timbre preset: Anchor

Offsets:

- `0, 2, 0, 4, 1, 0, 3, 5`

Durations:

- `3, 5, 2, 7`

Cycle rotation:

- order rotation step: `1`
- duration rotation step: `1`

Character:

- repeatedly returns to the anchor waveform
- punctuates the anchor with wider jumps

### Timbre preset: Pendulum

Offsets:

- `0, 1, 2, 3, 4, 5, 4, 3, 2, 1`

Durations:

- `2, 3, 5`

Cycle rotation:

- order rotation step: `0`
- duration rotation step: `1`

Character:

- forward-and-back sweep through the available waveform positions

### Timbre preset: Braid

Offsets:

- `0, 3, 1, 4, 2, 5`

Durations:

- `5, 3, 2, 4`

Cycle rotation:

- order rotation step: `2`
- duration rotation step: `1`

Character:

- interleaves near and far timbral jumps
- cycle rotation keeps the braid offset from repeating the same way

### Timbre preset: Spiral

Offsets:

- `0, 2, 4, 1, 3, 5`

Durations:

- `3, 2, 5, 7`

Cycle rotation:

- order rotation step: `1`
- duration rotation step: `2`

Character:

- broad rotating sweep that avoids a simple linear traversal

## Scale Presence Automation

Page 7 controls deterministic automation of Scale Presence.

Parameters:

- Motion: On/Off
- Preset
- Rate: `0.25x..3.00x`

General behavior:

- manual Scale Presence is the anchor
- presets apply signed offsets around that anchor
- values reflect at the boundaries instead of clamping
- this prevents the motion from getting stuck at `None` or `High`
- effective duration is `round(base duration / rate)` with a minimum of 1 event

Presence motion advances only on events that actually sound and only when freeze is not active.

### Presence preset: Bloom

Offsets:

- `0, 1, 2, 1, 0, -1`

Durations:

- `4, 6, 3, 5`

Cycle rotation:

- order rotation step: `1`
- duration rotation step: `1`

Character:

- opens upward from the anchor, then relaxes back below it

### Presence preset: Breath

Offsets:

- `0, 1, 0, -1, 0, 1, 0, -1`

Durations:

- `3, 5, 2`

Cycle rotation:

- order rotation step: `0`
- duration rotation step: `1`

Character:

- small, even oscillation around the anchor

### Presence preset: Surge

Offsets:

- `0, 0, 1, 0, 2, 0, 3, 0`

Durations:

- `5, 2, 4, 3`

Cycle rotation:

- order rotation step: `1`
- duration rotation step: `1`

Character:

- mostly centered, with periodic upward harmonic expansions

### Presence preset: Orbit

Offsets:

- `0, 1, -1, 2, -2, 1, -1, 0`

Durations:

- `3, 4, 2, 5`

Cycle rotation:

- order rotation step: `1`
- duration rotation step: `2`

Character:

- circles around the anchor on both sides, with reflected edge behavior

## Rhythm Engine

Page 8 controls deterministic automation of time subdivision and probability.

Parameters:

- Motion: On/Off
- Preset
- Rate: `0.25x..4.00x`
- Chord Engage: `0..100%`

General behavior:

- manual Tempo Subdivision is the anchor division
- manual Probability is the anchor density
- each preset defines states as `(division offset, probability offset)`
- division offsets reflect at the available subdivision boundaries
- probability offsets clamp to `5..100`
- effective duration is `round(base duration / rate)` with a minimum of 1 step

Rhythm motion advances on every sequencer step, except while freeze is active or releasing.

### Rhythm preset: Tide

States:

- `(0, 0)`
- `(1, +10)`
- `(2, +18)`
- `(1, +5)`
- `(0, -8)`
- `(-1, -20)`

Durations:

- `4, 6, 3, 5`

Cycle rotation:

- order rotation step: `1`
- duration rotation step: `1`

Character:

- gradual opening and closing of density and event speed

### Rhythm preset: Scatter

States:

- `(-2, -30)`
- `(1, -8)`
- `(2, -18)`
- `(0, +12)`
- `(-1, -24)`
- `(1, +4)`

Durations:

- `7, 2, 5, 3`

Cycle rotation:

- order rotation step: `1`
- duration rotation step: `2`

Character:

- long sparse stretches interrupted by short, more active pockets

### Rhythm preset: Breath

States:

- `(0, 0)`
- `(1, -6)`
- `(0, +12)`
- `(-1, -15)`
- `(0, +6)`

Durations:

- `5, 3, 4, 6`

Cycle rotation:

- order rotation step: `0`
- duration rotation step: `1`

Character:

- moderate rhythmic expansion and contraction around the anchor

### Rhythm preset: Latch

States:

- `(0, 0)`
- `(2, +15)`
- `(2, -6)`
- `(-1, -20)`
- `(1, +8)`

Durations:

- `8, 3, 5, 6`

Cycle rotation:

- order rotation step: `1`
- duration rotation step: `1`

Character:

- holds a rhythmic condition for longer spans, then jumps to a new one

## Automatic Chord Engage

The Rhythm Engine includes an additional probability control: `Chord Engage`.

Behavior:

- evaluated once per sequencer step
- ignored if manual chord mode is already held
- if triggered, the current step behaves like chord mode
- chord timing still uses the chord subdivision multiplier of `2`
- auto-engaged chord mode is per-step only
- freeze remains manual

## Visualizer

Page 1 is a full-screen visualizer built as a pixel-art high-voltage transmission tower.

Behavior:

- active arm pairs correspond to current Scale Presence
- particles are emitted from active arms on note events
- particles travel to the screen edges and fade out
- tower antennas display macro filter position as two zig-zag horizontal discharge lines
- overlay values show:
  - Note
  - current effective division
  - Octaves
  - current effective presence
  - current effective probability

## MIDI and Norns MAP

F.A.K.E. has no internal MIDI setup page.

Instead:

- the script connects globally to all visible Norns MIDI ports
- incoming `note_on` messages set the root pitch class
- all major musical and performance parameters are exposed through Norns `params`
- those params can be mapped in `EDIT / MAP`

Mapped parameter groups include:

- playback
- chord mode
- freeze
- note
- tempo subdivision
- scale
- scale presence
- octaves
- probability
- dynamics
- attack
- release
- waveform
- mod2
- filter swipe
- cutoff
- resonance
- drive
- pan rate
- pan depth
- filter LFO rate/depth/wave
- timbre motion on/preset/rate
- presence motion on/preset/rate
- rhythm motion on/preset/rate
- chord engage

## Troubleshooting

If FAKE gets stuck on `loading`:

1. update to the latest version of the repo
2. restart SuperCollider or reboot Norns
3. try loading FAKE again

This issue was previously caused by missing external SuperCollider classes on clean systems. FAKE is now self-contained and should load both on clean installs and on systems that already have `pixels` or `thebangs` installed.

## Controls

### Global

- `E1` change page
- `K2` start/stop
- `K3` hold for chord mode
- `K1 + K3` freeze chord

### Page 1 - Visualizer

- `E2` macro filter swipe
- `K1 + E2` select visualizer parameter
- `E3` edit selected visualizer parameter

Visualizer parameters:

- Note
- Tempo Subdivision
- Octaves
- Scale Presence
- Probability

### Pages 2 to 8

- `E2` select parameter
- `E3` edit parameter

Page assignments:

- Page 2: ARP. SETTINGS
- Page 3: PROB. & SOUND
- Page 4: FILTER & PAN
- Page 5: FILTER AUTOMATION
- Page 6: TIMBRE AUTOMATION
- Page 7: SCALE PRESENCE AUTOMATION
- Page 8: RHYTHM ENGINE

## Page Summary

### Page 2 - ARP. SETTINGS

- Note
- Tempo Subdivision
- Scale
- Scale Presence
- Octaves

### Page 3 - PROB. & SOUND

- Probability
- Dynamics
- Attack
- Release
- WaveType
- Mod2

### Page 4 - FILTER & PAN

- Cutoff
- Resonance
- Drive
- Pan Rate
- Pan Depth

### Page 5 - FILTER AUTOMATION

- LFO Rate
- LFO Depth
- LFO Wave

### Page 6 - TIMBRE AUTOMATION

- Motion
- Preset
- Rate

### Page 7 - SCALE PRESENCE AUTOMATION

- Motion
- Preset
- Rate

### Page 8 - RHYTHM ENGINE

- Motion
- Preset
- Rate
- Chord Engage

## Operational Notes

- Timbre motion and rhythm motion advance on clocked sequencer steps.
- Presence motion advances only on sounding events.
- Freeze suspends motion advancement until release is complete.
- Chord mode always halves event density by doubling the effective subdivision value.
- The visualizer shows effective presence and effective probability, not only anchor values.
- Manual waveform selection is the anchor for timbre motion.
- Manual Scale Presence is the anchor for presence motion.
- Manual Tempo Subdivision and Probability are the anchors for rhythm motion.

## Attribution

FAKE vendors namespaced adaptations of two SuperCollider helper classes originally used by `pixels`:

- `FAKE_Bgs` adapted from `pixels/lib/bgs.sc`
- `FAKE_OneshVoicer` adapted from `pixels/lib/OneshVoicer.sc`

The local `FAKE_` class names are used only to make FAKE self-contained and to prevent duplicate class conflicts with existing `pixels` or `thebangs` installations.
