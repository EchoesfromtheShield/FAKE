-- Failed At Keyboard
-- Education
-- by
-- Echoes from the Shield
--
-- F.A.K.E. is a
-- generative
-- arpeggiator built
-- around Scale
-- Presence, shaping
-- patterns from
-- sparse tonal
-- anchors to rich
-- harmonic motion
-- with timbral,
-- rhythmic, and
-- performance-driven
-- variation.
--
-- General controls:
-- E1 change page
-- K2 start/stop
-- K3 hold for
-- chord mode
-- K1 + K3 freeze
-- chord
--
-- Page 1 -
-- Visualizer:
-- E2 macro filter
-- swipe
-- K1 + E2 select
-- visualizer
-- parameter
-- E3 edit selected
-- parameter
-- Parameters:
-- Note
-- Tempo
-- Subdivision
-- Octaves
-- Scale Presence
-- Probability
--
-- Page 2 - 8:
-- E2 select
-- parameter
-- E3 edit
-- parameter
--
-- Page 2 -
-- ARP. SETTINGS:
-- Parameters:
-- Note
-- Tempo
-- Subdivision
-- Scale
-- Scale Presence
-- Octaves
--
-- Page 3 -
-- PROB. & SOUND:
-- Parameters:
-- Probability
-- Dynamics
-- Attack
-- Release
-- WaveType
-- Mod2
--
-- Page 4 -
-- FILTER & PAN:
-- Parameters:
-- Cutoff
-- Resonance
-- Drive
-- Pan Rate
-- Pan Depth
--
-- Page 5 -
-- FILTER
-- AUTOMATION:
-- Parameters:
-- LFO Rate
-- LFO Depth
-- LFO Wave
--
-- Page 6 -
-- TIMBRE
-- AUTOMATION:
-- Parameters:
-- Motion
-- Preset
-- Rate
--
-- Page 7 -
-- SCALE PRESENCE
-- AUTOMATION:
-- Parameters:
-- Motion
-- Preset
-- Rate
--
-- Page 8 -
-- RHYTHM ENGINE:
-- Parameters:
-- Motion
-- Preset
-- Rate
-- Chord Engage %

engine.name = "FAKE"

local notes = {"C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"}
local tempo_divisions = {"4", "2", "1", "1/2", "1/4", "1/8", "1/16", "1/32"}
local clock_divisions = {4, 2, 1, 1 / 2, 1 / 4, 1 / 8, 1 / 16, 1 / 32}
local scales = {
    {name = "Harmonic Minor", intervals = {0, 2, 3, 5, 7, 8, 11}},
    {name = "Major", intervals = {0, 2, 4, 5, 7, 9, 11}},
    {name = "Natural Minor", intervals = {0, 2, 3, 5, 7, 8, 10}},
    {name = "Pentatonic Major", intervals = {0, 2, 4, 7, 9}},
    {name = "Pentatonic Minor", intervals = {0, 3, 5, 7, 10}},
    {name = "Dorian", intervals = {0, 2, 3, 5, 7, 9, 10}},
    {name = "Phrygian", intervals = {0, 1, 3, 5, 7, 8, 10}},
    {name = "Lydian", intervals = {0, 2, 4, 6, 7, 9, 11}},
    {name = "Mixolydian", intervals = {0, 2, 4, 5, 7, 9, 10}},
    {name = "Locrian", intervals = {0, 1, 3, 5, 6, 8, 10}},
    {name = "Harmonic Major", intervals = {0, 2, 4, 5, 7, 8, 11}},
    {name = "Diminished", intervals = {0, 1, 3, 4, 6, 7, 9, 10}},
    {name = "Whole Tone", intervals = {0, 2, 4, 6, 8, 10}},
    {name = "Hungarian Major", intervals = {0, 3, 4, 6, 7, 9, 10}},
    {name = "Hungarian Minor", intervals = {0, 2, 3, 6, 7, 8, 11}},
    {name = "Arabic", intervals = {0, 2, 4, 5, 6, 8, 10}},
    {name = "Hirajoshi", intervals = {0, 2, 3, 7, 8}},
    {name = "Egyptian", intervals = {0, 2, 3, 6, 7}},
    {name = "Blues", intervals = {0, 3, 5, 6, 7, 10}}
}

local presences = {"None", "Low", "Medium", "High"}
local octaves_options = {"-2", "-1", "0", "+1", "+2", "+/-1", "+/-2"}
local wave_type_options = {0, 1, 2, 3, 4, 5}
local tower_crown_segments = {
    {-1, 4, -7, 0},
    {1, 4, 7, 0},
    {-5, 0, 0, 4},
    {5, 0, 0, 4},
    {-2, 4, -3, 7},
    {2, 4, 3, 7}
}

local tower_body_nodes = {
    {y = 7, half = 2},
    {y = 11, half = 1},
    {y = 15, half = 2},
    {y = 19, half = 1},
    {y = 23, half = 2},
    {y = 27, half = 1},
    {y = 31, half = 3},
    {y = 35, half = 2},
    {y = 39, half = 4},
    {y = 44, half = 3},
    {y = 50, half = 5},
    {y = 57, half = 8}
}

local tower_arm_pairs = {
    {
        segments = {
            {-3, 31, -11, 35},
            {3, 31, 11, 35},
            {-11, 35, -8, 35},
            {8, 35, 11, 35},
            {-1, 29, -6, 33},
            {1, 29, 6, 33}
        },
        emitters = {
            {x = -11, y = 35},
            {x = 11, y = 35}
        }
    },
    {
        segments = {
            {-3, 24, -10, 24},
            {3, 24, 10, 24},
            {-1, 26, -6, 24},
            {1, 26, 6, 24}
        },
        emitters = {
            {x = -10, y = 24},
            {x = 10, y = 24}
        }
    },
    {
        segments = {
            {-2, 16, -8, 16},
            {2, 16, 8, 16},
            {-1, 18, -5, 16},
            {1, 18, 5, 16}
        },
        emitters = {
            {x = -8, y = 16},
            {x = 8, y = 16}
        }
    },
    {
        segments = {
            {-2, 8, -7, 8},
            {2, 8, 7, 8},
            {-2, 8, -2, 11},
            {2, 8, 2, 11},
            {-1, 11, -4, 8},
            {1, 11, 4, 8}
        },
        emitters = {
            {x = -7, y = 8},
            {x = 7, y = 8}
        }
    }
}

local playing = false
local clock_id = nil
local visual_metro = nil

local page = 1
local max_pages = 8

local selected_note = 1
local selected_division = 3
local selected_scale = 1
local selected_presence = 1
local current_presence = 1
local selected_octave_index = 3
local presence_profiles = {}
local octave_intervals = {}
local last_pitch_steps = nil

local probability = 100
local engine_attack = 0.01
local engine_release = 2.0
local engine_wave_type = 0
local current_wave_type = 0
local engine_mod2 = 0.5
local engine_cutoff = 16000
local engine_resonance = 0.0
local engine_drive = 0.0
local engine_pan_lfo_rate = 0.0
local engine_pan_lfo_depth = 0.0
local filter_lfo_waves = {"Sine", "Triangle", "Square"}
local filter_swipe_base = 1.0
local filter_swipe = 1.0
local filter_lfo_rate = 0.0
local filter_lfo_depth = 0.0
local filter_lfo_wave_index = 1
local filter_lfo_phase = 0.0
local filter_lfo_current = 0.0
local timbre_motion = {
    presets = {
    {
        name = "Anchor",
        offsets = {0, 2, 0, 4, 1, 0, 3, 5},
        durations = {3, 5, 2, 7},
        order_rotation_step = 1,
        duration_rotation_step = 1
    },
    {
        name = "Pendulum",
        offsets = {0, 1, 2, 3, 4, 5, 4, 3, 2, 1},
        durations = {2, 3, 5},
        order_rotation_step = 0,
        duration_rotation_step = 1
    },
    {
        name = "Braid",
        offsets = {0, 3, 1, 4, 2, 5},
        durations = {5, 3, 2, 4},
        order_rotation_step = 2,
        duration_rotation_step = 1
    },
    {
        name = "Spiral",
        offsets = {0, 2, 4, 1, 3, 5},
        durations = {3, 2, 5, 7},
        order_rotation_step = 1,
        duration_rotation_step = 2
    }
    },
    enabled = false,
    preset_index = 1,
    rate = 1.0,
    step_index = 1,
    order_rotation = 0,
    duration_rotation = 0,
    steps_remaining = 0
}
local presence_motion = {
    presets = {
    {
        name = "Bloom",
        offsets = {0, 1, 2, 1, 0, -1},
        durations = {4, 6, 3, 5},
        order_rotation_step = 1,
        duration_rotation_step = 1
    },
    {
        name = "Breath",
        offsets = {0, 1, 0, -1, 0, 1, 0, -1},
        durations = {3, 5, 2},
        order_rotation_step = 0,
        duration_rotation_step = 1
    },
    {
        name = "Surge",
        offsets = {0, 0, 1, 0, 2, 0, 3, 0},
        durations = {5, 2, 4, 3},
        order_rotation_step = 1,
        duration_rotation_step = 1
    },
    {
        name = "Orbit",
        offsets = {0, 1, -1, 2, -2, 1, -1, 0},
        durations = {3, 4, 2, 5},
        order_rotation_step = 1,
        duration_rotation_step = 2
    }
    },
    enabled = false,
    preset_index = 1,
    rate = 1.0,
    step_index = 1,
    order_rotation = 0,
    duration_rotation = 0,
    steps_remaining = 0
}
local rhythm_motion = {
    presets = {
    {
        name = "Tide",
        states = {
            {division_offset = 0, probability_offset = 0},
            {division_offset = 1, probability_offset = 10},
            {division_offset = 2, probability_offset = 18},
            {division_offset = 1, probability_offset = 5},
            {division_offset = 0, probability_offset = -8},
            {division_offset = -1, probability_offset = -20}
        },
        durations = {4, 6, 3, 5},
        order_rotation_step = 1,
        duration_rotation_step = 1
    },
    {
        name = "Scatter",
        states = {
            {division_offset = -2, probability_offset = -30},
            {division_offset = 1, probability_offset = -8},
            {division_offset = 2, probability_offset = -18},
            {division_offset = 0, probability_offset = 12},
            {division_offset = -1, probability_offset = -24},
            {division_offset = 1, probability_offset = 4}
        },
        durations = {7, 2, 5, 3},
        order_rotation_step = 1,
        duration_rotation_step = 2
    },
    {
        name = "Breath",
        states = {
            {division_offset = 0, probability_offset = 0},
            {division_offset = 1, probability_offset = -6},
            {division_offset = 0, probability_offset = 12},
            {division_offset = -1, probability_offset = -15},
            {division_offset = 0, probability_offset = 6}
        },
        durations = {5, 3, 4, 6},
        order_rotation_step = 0,
        duration_rotation_step = 1
    },
    {
        name = "Latch",
        states = {
            {division_offset = 0, probability_offset = 0},
            {division_offset = 2, probability_offset = 15},
            {division_offset = 2, probability_offset = -6},
            {division_offset = -1, probability_offset = -20},
            {division_offset = 1, probability_offset = 8}
        },
        durations = {8, 3, 5, 6},
        order_rotation_step = 1,
        duration_rotation_step = 1
    }
    },
    enabled = false,
    preset_index = 1,
    rate = 1.0,
    step_index = 1,
    order_rotation = 0,
    duration_rotation = 0,
    steps_remaining = 0,
    current_division_index = 3,
    current_probability = 100,
    chord_engage = 0
}
local visual_frame = 0
local visual_flash = 0
local visual_pitch_bias = 0
local visual_last_interval = 0
local visual_last_octave = 0
local visual_particles = {}
local ui_state = {
    visualizer_shift_held = false,
    visualizer_param_index = 1,
    current_params = {1, 1, 1, 1, 1, 1, 1}
}
local performance_state = {
    button_1_held = false,
    button_3_held = false,
    chord_mode_held = false,
    chord_param_held = false,
    dynamics_index = 1,
    freeze_active = false,
    freeze_armed = false,
    freeze_param_held = false,
    freeze_releasing = false,
    freeze_release_until = 0,
    freeze_release_seconds = 0.25,
    auto_chord_for_step = false
}
local midi_state = {devices = {}}
local param_state = {
    syncing = false,
    ids = {
        playback = "fake_playback",
        chord_mode = "fake_chord_mode",
        freeze = "fake_freeze",
        note = "fake_note",
        division = "fake_division",
        scale = "fake_scale",
        presence = "fake_presence",
        octaves = "fake_octaves",
        probability = "fake_probability",
        attack = "fake_attack",
        release = "fake_release",
        wave_type = "fake_wave_type",
        mod2 = "fake_mod2",
        dynamics = "fake_dynamics",
        filter_swipe = "fake_filter_swipe",
        cutoff = "fake_cutoff",
        resonance = "fake_resonance",
        drive = "fake_drive",
        pan_rate = "fake_pan_rate",
        pan_depth = "fake_pan_depth",
        filter_lfo_rate = "fake_filter_lfo_rate",
        filter_lfo_depth = "fake_filter_lfo_depth",
        filter_lfo_wave = "fake_filter_lfo_wave",
        timbre_motion = "fake_timbre_motion",
        timbre_preset = "fake_timbre_preset",
        timbre_rate = "fake_timbre_rate",
        presence_motion = "fake_presence_motion",
        presence_preset = "fake_presence_preset",
        presence_rate = "fake_presence_rate",
        rhythm_motion = "fake_rhythm_motion",
        rhythm_preset = "fake_rhythm_preset",
        rhythm_rate = "fake_rhythm_rate",
        rhythm_chord = "fake_rhythm_chord"
    }
}

local params_page_1 = {"Note", "Tempo Subdivision", "Scale", "Scale Presence", "Octaves"}
local params_page_2 = {"Probability", "Dynamics", "Attack", "Release", "WaveType", "Mod2"}
local params_page_3 = {"Cutoff", "Resonance", "Drive", "Pan Rate", "Pan Depth"}
local params_page_4 = {"LFO Rate", "LFO Depth", "LFO Wave"}
local params_page_5 = {"Motion", "Preset", "Rate"}
local params_page_6 = {"Motion", "Preset", "Rate"}
local params_page_7 = {"Motion", "Preset", "Rate", "Chord Engage"}
local visualizer_params = {"Note", "Tempo Subdivision", "Octaves", "Scale Presence", "Probability"}
local page_titles = {
    [2] = "2 - ARP. SETTINGS",
    [3] = "3 - PROB. & SOUND",
    [4] = "4 - FILTER & PAN",
    [5] = "5 - FILTER AUTOMATION",
    [6] = "6 - TIMBRE AUTOMATION",
    [7] = "7 - SCALE PRESENCE AUTOMATION",
    [8] = "8 - RHYTHM ENGINE"
}
local chord_note_count = 3

local update_presence_profiles
local update_octave_intervals
local apply_engine_params
local current_step_division, update_freeze_state, start_playback, stop_playback
local sync_script_params

local harmony_model = {
    default_degree_weight = 0.2,
    role_target_priority_step = 0.2,
    default_octave_weight = 0.55,
    degree_weights = {
        [0] = 1.00,
        [7] = 0.82,
        [4] = 0.66,
        [3] = 0.66,
        [2] = 0.46,
        [1] = 0.38,
        [5] = 0.34,
        [9] = 0.30,
        [8] = 0.28,
        [10] = 0.24,
        [11] = 0.22,
        [6] = 0.18
    },
    role_targets = {
        dominant = {7, 8, 6, 9, 5},
        mediant = {4, 3, 5, 2},
        color_a = {2, 1, 9, 10, 5},
        color_b = {5, 6, 8, 10, 11}
    },
    presence_profiles = {
        {
            key = "none",
            target_size = 2,
            fallback_weight_scale = 0.45,
            role_weights = {
                root = 0.72,
                dominant = 0.28
            }
        },
        {
            key = "low",
            target_size = 3,
            fallback_weight_scale = 0.50,
            role_weights = {
                root = 0.46,
                dominant = 0.32,
                mediant = 0.22
            }
        },
        {
            key = "medium",
            target_size = 5,
            fallback_weight_scale = 0.60,
            role_weights = {
                root = 0.34,
                dominant = 0.24,
                mediant = 0.18,
                color_a = 0.14,
                color_b = 0.10
            }
        },
        {
            key = "high",
            full_scale = true
        }
    },
    movement_weights = {
        repeat_note = 0.28,
        step = 1.35,
        near = 1.05,
        leap = 0.72,
        far = 0.45
    },
    octave_weights = {
        [0] = 1.00,
        [1] = 0.85,
        [2] = 0.70
    },
    dynamic_labels = {"None", "Low", "Medium", "High"},
    dynamic_profiles = {
        {attenuation_chance = 0.00, accent_chance = 0.00, attenuation_min = 1.00, attenuation_max = 1.00, accent_min = 1.00, accent_max = 1.00},
        {attenuation_chance = 0.35, accent_chance = 0.07, attenuation_min = 0.72, attenuation_max = 0.95, accent_min = 1.00, accent_max = 1.05},
        {attenuation_chance = 0.60, accent_chance = 0.12, attenuation_min = 0.58, attenuation_max = 0.95, accent_min = 1.00, accent_max = 1.07},
        {attenuation_chance = 0.80, accent_chance = 0.16, attenuation_min = 0.38, attenuation_max = 0.95, accent_min = 1.00, accent_max = 1.10}
    }
}

local function get_harmonic_weight(interval)
    return harmony_model.degree_weights[interval] or harmony_model.default_degree_weight
end

local function find_wave_type_option_index(value)
    if value == 6 then
        return #wave_type_options
    end

    for index, option in ipairs(wave_type_options) do
        if option == value then
            return index
        end
    end

    return 1
end

local function timbre_motion_preset()
    return timbre_motion.presets[timbre_motion.preset_index]
end

local function timbre_motion_sequence_index(length, position, rotation)
    return util.wrap(position + rotation, 1, length)
end

local function reflect_motion_index(index, max_index)
    local reflected = index

    while reflected < 1 or reflected > max_index do
        if reflected < 1 then
            reflected = 2 - reflected
        elseif reflected > max_index then
            reflected = (max_index * 2) - reflected
        end
    end

    return reflected
end

local function timbre_motion_effective_wave()
    if not timbre_motion.enabled then
        return engine_wave_type
    end

    local preset = timbre_motion_preset()
    local anchor_index = find_wave_type_option_index(engine_wave_type)
    local sequence_index = timbre_motion_sequence_index(#preset.offsets, timbre_motion.step_index, timbre_motion.order_rotation)
    local wave_index = util.wrap(anchor_index + preset.offsets[sequence_index], 1, #wave_type_options)
    return wave_type_options[wave_index]
end

local function timbre_motion_effective_duration()
    local preset = timbre_motion_preset()
    local sequence_index = timbre_motion_sequence_index(#preset.durations, timbre_motion.step_index, timbre_motion.duration_rotation)
    local scaled_duration = preset.durations[sequence_index] / timbre_motion.rate
    return math.max(1, math.floor(scaled_duration + 0.5))
end

local function push_current_wave_type()
    engine.waveType(current_wave_type)
end

local function reset_timbre_motion(push_to_engine)
    timbre_motion.step_index = 1
    timbre_motion.order_rotation = 0
    timbre_motion.duration_rotation = 0

    if timbre_motion.enabled then
        current_wave_type = timbre_motion_effective_wave()
        timbre_motion.steps_remaining = timbre_motion_effective_duration()
    else
        current_wave_type = engine_wave_type
        timbre_motion.steps_remaining = 0
    end

    if push_to_engine then
        push_current_wave_type()
    end
end

local function advance_timbre_motion_cycle()
    local preset = timbre_motion_preset()
    timbre_motion.step_index = timbre_motion.step_index + 1

    if timbre_motion.step_index > #preset.offsets then
        timbre_motion.step_index = 1
        timbre_motion.order_rotation = timbre_motion.order_rotation + (preset.order_rotation_step or 0)
        timbre_motion.duration_rotation = timbre_motion.duration_rotation + (preset.duration_rotation_step or 0)
    end
end

local function consume_timbre_motion_step()
    if not timbre_motion.enabled then
        return false
    end

    if timbre_motion.steps_remaining <= 1 then
        advance_timbre_motion_cycle()
        current_wave_type = timbre_motion_effective_wave()
        timbre_motion.steps_remaining = timbre_motion_effective_duration()
        push_current_wave_type()
        return true
    else
        timbre_motion.steps_remaining = timbre_motion.steps_remaining - 1
        return false
    end
end

local function presence_motion_preset()
    return presence_motion.presets[presence_motion.preset_index]
end

local function presence_motion_effective_presence()
    if not presence_motion.enabled then
        return selected_presence
    end

    local preset = presence_motion_preset()
    local sequence_index = timbre_motion_sequence_index(#preset.offsets, presence_motion.step_index, presence_motion.order_rotation)
    return reflect_motion_index(selected_presence + preset.offsets[sequence_index], #presences)
end

local function presence_motion_effective_duration()
    local preset = presence_motion_preset()
    local sequence_index = timbre_motion_sequence_index(#preset.durations, presence_motion.step_index, presence_motion.duration_rotation)
    local scaled_duration = preset.durations[sequence_index] / presence_motion.rate
    return math.max(1, math.floor(scaled_duration + 0.5))
end

local function reset_presence_motion()
    presence_motion.step_index = 1
    presence_motion.order_rotation = 0
    presence_motion.duration_rotation = 0

    if presence_motion.enabled then
        current_presence = presence_motion_effective_presence()
        presence_motion.steps_remaining = presence_motion_effective_duration()
    else
        current_presence = selected_presence
        presence_motion.steps_remaining = 0
    end
end

local function advance_presence_motion_cycle()
    local preset = presence_motion_preset()
    presence_motion.step_index = presence_motion.step_index + 1

    if presence_motion.step_index > #preset.offsets then
        presence_motion.step_index = 1
        presence_motion.order_rotation = presence_motion.order_rotation + (preset.order_rotation_step or 0)
        presence_motion.duration_rotation = presence_motion.duration_rotation + (preset.duration_rotation_step or 0)
    end
end

local function consume_presence_motion_step()
    if not presence_motion.enabled then
        return false
    end

    if presence_motion.steps_remaining <= 1 then
        advance_presence_motion_cycle()
        current_presence = presence_motion_effective_presence()
        presence_motion.steps_remaining = presence_motion_effective_duration()
        return true
    end

    presence_motion.steps_remaining = presence_motion.steps_remaining - 1
    return false
end

local function rhythm_motion_preset()
    return rhythm_motion.presets[rhythm_motion.preset_index]
end

local function rhythm_motion_effective_state()
    if not rhythm_motion.enabled then
        return selected_division, probability
    end

    local preset = rhythm_motion_preset()
    local sequence_index = timbre_motion_sequence_index(#preset.states, rhythm_motion.step_index, rhythm_motion.order_rotation)
    local state = preset.states[sequence_index]
    local division_index = reflect_motion_index(selected_division + state.division_offset, #tempo_divisions)
    local probability_value = util.clamp(probability + state.probability_offset, 5, 100)
    return division_index, probability_value
end

local function rhythm_motion_effective_duration()
    local preset = rhythm_motion_preset()
    local sequence_index = timbre_motion_sequence_index(#preset.durations, rhythm_motion.step_index, rhythm_motion.duration_rotation)
    local scaled_duration = preset.durations[sequence_index] / rhythm_motion.rate
    return math.max(1, math.floor(scaled_duration + 0.5))
end

local function reset_rhythm_motion()
    rhythm_motion.step_index = 1
    rhythm_motion.order_rotation = 0
    rhythm_motion.duration_rotation = 0

    if rhythm_motion.enabled then
        rhythm_motion.current_division_index, rhythm_motion.current_probability = rhythm_motion_effective_state()
        rhythm_motion.steps_remaining = rhythm_motion_effective_duration()
    else
        rhythm_motion.current_division_index = selected_division
        rhythm_motion.current_probability = probability
        rhythm_motion.steps_remaining = 0
    end
end

local function advance_rhythm_motion_cycle()
    local preset = rhythm_motion_preset()
    rhythm_motion.step_index = rhythm_motion.step_index + 1

    if rhythm_motion.step_index > #preset.states then
        rhythm_motion.step_index = 1
        rhythm_motion.order_rotation = rhythm_motion.order_rotation + (preset.order_rotation_step or 0)
        rhythm_motion.duration_rotation = rhythm_motion.duration_rotation + (preset.duration_rotation_step or 0)
    end
end

local function consume_rhythm_motion_step()
    if not rhythm_motion.enabled then
        return false
    end

    if rhythm_motion.steps_remaining <= 1 then
        advance_rhythm_motion_cycle()
        rhythm_motion.current_division_index, rhythm_motion.current_probability = rhythm_motion_effective_state()
        rhythm_motion.steps_remaining = rhythm_motion_effective_duration()
        return true
    end

    rhythm_motion.steps_remaining = rhythm_motion.steps_remaining - 1
    return false
end

local function chord_mode_active()
    return performance_state.chord_mode_held or performance_state.auto_chord_for_step
end

local function pixel_fill(x, y, size, level)
    local clipped_x = math.max(0, x)
    local clipped_y = math.max(0, y)
    local clipped_right = math.min(128, x + size)
    local clipped_bottom = math.min(64, y + size)
    local clipped_width = clipped_right - clipped_x
    local clipped_height = clipped_bottom - clipped_y

    if clipped_width <= 0 or clipped_height <= 0 then
        return
    end

    screen.level(level)
    screen.rect(clipped_x, clipped_y, clipped_width, clipped_height)
    screen.fill()
end

local function draw_pixel_line(x1, y1, x2, y2, size, level)
    local dx = x2 - x1
    local dy = y2 - y1
    local steps = math.max(math.abs(dx), math.abs(dy))

    if steps == 0 then
        pixel_fill(x1, y1, size, level)
        return
    end

    for step = 0, steps do
        local t = step / steps
        local x = math.floor(x1 + (dx * t) + 0.5)
        local y = math.floor(y1 + (dy * t) + 0.5)
        pixel_fill(x, y, size, level)
    end
end

local function draw_relative_segments(center_x, tower_y, segments, level)
    for _, segment in ipairs(segments) do
        draw_pixel_line(
            center_x + segment[1],
            tower_y + segment[2],
            center_x + segment[3],
            tower_y + segment[4],
            1,
            level
        )
    end
end

local function draw_tower_arm(center_x, tower_y, pair, active, active_level, inactive_level)
    local level = active and active_level or inactive_level

    draw_relative_segments(center_x, tower_y, pair.segments, level)

    for _, emitter in ipairs(pair.emitters) do
        local glow_size = active and 3 or 2
        local glow_level = active and active_level or inactive_level
        pixel_fill(center_x + emitter.x - 1, tower_y + emitter.y - 1, glow_size, glow_level)
    end
end

local function draw_tower_body(center_x, tower_y, body_level, accent_level)
    draw_relative_segments(center_x, tower_y, tower_crown_segments, body_level)

    for index = 1, #tower_body_nodes - 1 do
        local current = tower_body_nodes[index]
        local next_point = tower_body_nodes[index + 1]
        local current_y = tower_y + current.y
        local next_y = tower_y + next_point.y

        draw_pixel_line(center_x - current.half, current_y, center_x - next_point.half, next_y, 1, body_level)
        draw_pixel_line(center_x + current.half, current_y, center_x + next_point.half, next_y, 1, body_level)
        draw_pixel_line(center_x - current.half, current_y, center_x + next_point.half, next_y, 1, body_level)
        draw_pixel_line(center_x + current.half, current_y, center_x - next_point.half, next_y, 1, body_level)
        draw_pixel_line(center_x - current.half, current_y, center_x + current.half, current_y, 1, accent_level)
    end

    draw_pixel_line(center_x - 2, tower_y + 6, center_x + 2, tower_y + 6, 1, accent_level)
    draw_pixel_line(center_x - 8, tower_y + 57, center_x - 10, tower_y + 61, 1, body_level)
    draw_pixel_line(center_x + 8, tower_y + 57, center_x + 10, tower_y + 61, 1, body_level)
    draw_pixel_line(center_x - 4, tower_y + 57, center_x - 1, tower_y + 61, 1, body_level)
    draw_pixel_line(center_x + 4, tower_y + 57, center_x + 1, tower_y + 61, 1, body_level)
end

local function draw_filter_swipe_zigzag(x1, y1, direction, length, level)
    local segment_length = 4
    local steps = math.max(1, math.floor(length / segment_length))
    local current_x = x1
    local current_y = y1

    for step = 1, steps do
        local next_x = current_x + (direction * segment_length)
        local next_y = y1 + ((step % 2 == 0) and -1 or 1)

        draw_pixel_line(current_x, current_y, next_x, next_y, 1, level)
        current_x = next_x
        current_y = next_y
    end
end

local function draw_filter_swipe_feedback(center_x, tower_y, level)
    local antenna_y = tower_y + 1
    local antenna_left_x = center_x - 8
    local antenna_right_x = center_x + 8
    local length = 4 + math.floor(filter_swipe * 44)

    draw_filter_swipe_zigzag(antenna_left_x, antenna_y, -1, length, level)
    draw_filter_swipe_zigzag(antenna_right_x, antenna_y, 1, length, level)
end

local function clamp_number(value, min_value, max_value)
    return math.max(min_value, math.min(max_value, value))
end

local function build_visual_particles(presence, pitch_steps)
    local particles = {}
    local active_pairs = clamp_number(presence, 1, #tower_arm_pairs)
    local pitch_seed = math.abs(pitch_steps) + selected_note

    for pair_index = 1, active_pairs do
        local pair = tower_arm_pairs[pair_index]
        local lane_count = 2 + ((pitch_seed + pair_index) % 2)
        local pitch_drift = (clamp_number(pitch_steps, -24, 24) / 24) * 0.12

        for emitter_index, emitter in ipairs(pair.emitters) do
            local direction = emitter.x < 0 and -1 or 1

            for lane = 1, lane_count do
                local speed = 1.7 + (lane * 0.45) + ((pair_index - 1) * 0.12) + ((pitch_seed + emitter_index) % 3 * 0.08)
                local y_jitter = (((pitch_seed + lane + pair_index + emitter_index) % 5) - 2) * 0.12

                particles[#particles + 1] = {
                    x = emitter.x + (direction * (1 + (lane % 2))),
                    y = emitter.y + ((lane % 2 == 0) and -1 or 0),
                    vx = direction * speed,
                    vy = y_jitter - pitch_drift,
                    age = 0,
                    life = 26 + (lane * 3) + (pair_index * 2),
                    size = lane == 1 and 2 or 1,
                    base_level = clamp_number(14 - pair_index + presence, 6, 15)
                }
            end
        end
    end

    return particles
end

local function trigger_visualizer(candidate)
    visual_flash = 1
    visual_last_interval = candidate.interval
    visual_last_octave = candidate.octave_offset
    visual_pitch_bias = clamp_number(candidate.pitch_steps, -24, 24)

    for _, particle in ipairs(build_visual_particles(current_presence, candidate.pitch_steps)) do
        visual_particles[#visual_particles + 1] = particle
    end

    if #visual_particles > 160 then
        local trimmed_particles = {}

        for index = #visual_particles - 159, #visual_particles do
            trimmed_particles[#trimmed_particles + 1] = visual_particles[index]
        end

        visual_particles = trimmed_particles
    end

end

local function interval_distance(a, b)
    local diff = math.abs(a - b)
    return math.min(diff, 12 - diff)
end

local function append_interval(profile, seen, interval, weight)
    if interval == nil or seen[interval] then
        return
    end

    profile[#profile + 1] = {interval = interval, weight = weight}
    seen[interval] = true
end

local function add_remaining_intervals(profile, scale, seen, target_size, weight_scale)
    local remaining = {}

    for _, interval in ipairs(scale) do
        if not seen[interval] then
            remaining[#remaining + 1] = interval
        end
    end

    table.sort(remaining, function(a, b)
        local a_weight = get_harmonic_weight(a)
        local b_weight = get_harmonic_weight(b)

        if a_weight == b_weight then
            return a < b
        end

        return a_weight > b_weight
    end)

    for _, interval in ipairs(remaining) do
        append_interval(profile, seen, interval, get_harmonic_weight(interval) * weight_scale)

        if #profile >= target_size then
            break
        end
    end
end

local function find_role_interval(scale, targets, used)
    local best_interval = nil
    local best_score = nil

    for _, interval in ipairs(scale) do
        if not used[interval] then
            for target_index, target in ipairs(targets) do
                local score = interval_distance(interval, target) + ((target_index - 1) * harmony_model.role_target_priority_step)

                if best_score == nil or score < best_score then
                    best_score = score
                    best_interval = interval
                elseif score == best_score and get_harmonic_weight(interval) > get_harmonic_weight(best_interval) then
                    best_interval = interval
                end
            end
        end
    end

    return best_interval
end

local function resolve_role_intervals(scale)
    local role_intervals = {root = 0}
    local used_roles = {[0] = true}

    for _, role_name in ipairs({"dominant", "mediant", "color_a", "color_b"}) do
        local interval = find_role_interval(scale, harmony_model.role_targets[role_name], used_roles)
        role_intervals[role_name] = interval

        if interval ~= nil then
            used_roles[interval] = true
        end
    end

    return role_intervals
end

local function build_weighted_presence_profile(scale, role_intervals, config)
    local profile = {}
    local seen = {}

    for _, role_name in ipairs({"root", "dominant", "mediant", "color_a", "color_b"}) do
        local role_weight = config.role_weights[role_name]
        if role_weight ~= nil then
            append_interval(profile, seen, role_intervals[role_name], role_weight)
        end
    end

    add_remaining_intervals(
        profile,
        scale,
        seen,
        math.min(config.target_size, #scale),
        config.fallback_weight_scale
    )

    return profile
end

local function build_presence_profiles(scale)
    local role_intervals = resolve_role_intervals(scale)
    local profiles = {}

    for index, config in ipairs(harmony_model.presence_profiles) do
        if config.full_scale then
            profiles[index] = {}

            for _, interval in ipairs(scale) do
                profiles[index][#profiles[index] + 1] = {
                    interval = interval,
                    weight = get_harmonic_weight(interval)
                }
            end
        else
            profiles[index] = build_weighted_presence_profile(scale, role_intervals, config)
        end
    end

    return profiles
end

update_octave_intervals = function()
    local opt = octaves_options[selected_octave_index]

    if opt == "0" then
        octave_intervals = {0}
    elseif opt == "+1" then
        octave_intervals = {0, 1}
    elseif opt == "+2" then
        octave_intervals = {0, 1, 2}
    elseif opt == "-1" then
        octave_intervals = {-1, 0}
    elseif opt == "-2" then
        octave_intervals = {-2, -1, 0}
    elseif opt == "+/-2" then
        octave_intervals = {-2, -1, 0, 1, 2}
    else
        octave_intervals = {-1, 0, 1}
    end
end

update_presence_profiles = function()
    presence_profiles = build_presence_profiles(scales[selected_scale].intervals)
end

local function reset_phrase_memory()
    last_pitch_steps = nil
end

local function change_note(delta)
    selected_note = util.wrap(selected_note + delta, 1, #notes)
    reset_phrase_memory()
end

local function change_division(delta)
    selected_division = util.clamp(selected_division + delta, 1, #tempo_divisions)
    reset_rhythm_motion()
end

local function change_scale(delta)
    selected_scale = util.clamp(selected_scale + delta, 1, #scales)
    update_presence_profiles()
    reset_presence_motion()
    reset_phrase_memory()
end

local function change_presence(delta)
    selected_presence = util.clamp(selected_presence + delta, 1, #presences)
    reset_presence_motion()
    reset_phrase_memory()
end

local function change_octaves(delta)
    selected_octave_index = util.wrap(selected_octave_index + delta, 1, #octaves_options)
    update_octave_intervals()
    reset_phrase_memory()
end

local function change_probability(delta)
    probability = util.clamp(probability + (delta * 5), 5, 100)
    reset_rhythm_motion()
end

local function change_attack(delta)
    engine_attack = util.clamp(engine_attack + (delta * 0.01), 0.001, 10)
end

local function change_release(delta)
    engine_release = util.clamp(engine_release + (delta * 0.1), 0.1, 10)
end

local function change_wave_type(delta)
    local wave_type_option_index = find_wave_type_option_index(engine_wave_type)
    wave_type_option_index = util.clamp(wave_type_option_index + delta, 1, #wave_type_options)
    engine_wave_type = wave_type_options[wave_type_option_index]
    reset_timbre_motion(true)
end

local function change_mod2(delta)
    engine_mod2 = util.clamp(engine_mod2 + (delta * 0.05), 0, 1)
end

local function event_dynamics_scale()
    local profile = harmony_model.dynamic_profiles[performance_state.dynamics_index]

    if profile == nil or performance_state.dynamics_index == 1 then
        return 1.0
    end

    local roll = math.random()

    if roll < profile.accent_chance then
        return util.linlin(0, 1, profile.accent_min, profile.accent_max, math.random())
    end

    if roll < (profile.accent_chance + profile.attenuation_chance) then
        return util.linlin(0, 1, profile.attenuation_min, profile.attenuation_max, math.random())
    end

    return 1.0
end

local function change_timbre_motion_enabled(delta)
    if delta == 0 then
        return
    end

    timbre_motion.enabled = delta > 0
    reset_timbre_motion(true)
end

local function change_timbre_motion_preset(delta)
    timbre_motion.preset_index = util.wrap(timbre_motion.preset_index + delta, 1, #timbre_motion.presets)
    reset_timbre_motion(true)
end

local function change_timbre_motion_rate(delta)
    timbre_motion.rate = util.clamp(timbre_motion.rate + (delta * 0.1), 0.25, 4.0)
    reset_timbre_motion(true)
end

local function change_presence_motion_enabled(delta)
    if delta == 0 then
        return
    end

    presence_motion.enabled = delta > 0
    reset_presence_motion()
end

local function change_presence_motion_preset(delta)
    presence_motion.preset_index = util.wrap(presence_motion.preset_index + delta, 1, #presence_motion.presets)
    reset_presence_motion()
end

local function change_presence_motion_rate(delta)
    presence_motion.rate = util.clamp(presence_motion.rate + (delta * 0.1), 0.25, 3.0)
    reset_presence_motion()
end

local function change_rhythm_motion_enabled(delta)
    if delta == 0 then
        return
    end

    rhythm_motion.enabled = delta > 0
    reset_rhythm_motion()
end

local function change_rhythm_motion_preset(delta)
    rhythm_motion.preset_index = util.wrap(rhythm_motion.preset_index + delta, 1, #rhythm_motion.presets)
    reset_rhythm_motion()
end

local function change_rhythm_motion_rate(delta)
    rhythm_motion.rate = util.clamp(rhythm_motion.rate + (delta * 0.1), 0.25, 4.0)
    reset_rhythm_motion()
end

local function change_rhythm_chord_engage(delta)
    rhythm_motion.chord_engage = util.clamp(rhythm_motion.chord_engage + (delta * 5), 0, 100)
end

local function cutoff_from_filter_swipe(value)
    local min_cutoff = 500
    local max_cutoff = 16000
    return util.clamp(min_cutoff * math.pow(max_cutoff / min_cutoff, value), min_cutoff, max_cutoff)
end

local function resonance_from_filter_swipe(value)
    return util.clamp((1 - value) * 4, 0, 4)
end

local function filter_lfo_wave_value(phase)
    if filter_lfo_wave_index == 1 then
        return math.sin(phase * math.pi * 2)
    elseif filter_lfo_wave_index == 2 then
        return 1 - (4 * math.abs(phase - 0.5))
    end

    return phase < 0.5 and 1 or -1
end

local function update_filter_swipe_state(push_to_engine)
    local modulation = 0

    if filter_lfo_rate > 0 and filter_lfo_depth > 0 then
        modulation = filter_lfo_current * filter_lfo_depth * 0.5
    end

    local next_swipe = util.clamp(filter_swipe_base + modulation, 0, 1)
    local changed = math.abs(next_swipe - filter_swipe) > 0.0001
    filter_swipe = next_swipe
    engine_cutoff = cutoff_from_filter_swipe(filter_swipe)
    engine_resonance = resonance_from_filter_swipe(filter_swipe)

    if push_to_engine or changed then
        engine.cutoff(engine_cutoff)
        engine.resonance(engine_resonance)
    end

    return changed
end

local function sync_filter_swipe_from_tone()
    local min_cutoff = 500
    local max_cutoff = 16000
    local cutoff_position = math.log(util.clamp(engine_cutoff, min_cutoff, max_cutoff) / min_cutoff) / math.log(max_cutoff / min_cutoff)
    local resonance_position = 1 - (util.clamp(engine_resonance, 0, 4) / 4)
    filter_swipe_base = util.clamp((cutoff_position + resonance_position) * 0.5, 0, 1)
    update_filter_swipe_state(false)
end

local function apply_filter_swipe()
    update_filter_swipe_state(true)
end

local function change_filter_swipe(delta)
    filter_swipe_base = util.clamp(filter_swipe_base + (delta * 0.04), 0, 1)
    apply_filter_swipe()
    sync_script_params()
end

local function change_filter_lfo_rate(delta)
    local previous_rate = filter_lfo_rate
    filter_lfo_rate = util.clamp(filter_lfo_rate + (delta * 0.05), 0, 4)

    if previous_rate == 0 and filter_lfo_rate > 0 then
        filter_lfo_phase = 0
    elseif filter_lfo_rate == 0 then
        filter_lfo_current = 0
        update_filter_swipe_state(true)
    end
end

local function change_filter_lfo_depth(delta)
    filter_lfo_depth = util.clamp(filter_lfo_depth + (delta * 0.05), 0, 1)

    if filter_lfo_depth == 0 then
        filter_lfo_current = 0
    end

    update_filter_swipe_state(true)
end

local function change_filter_lfo_wave(delta)
    filter_lfo_wave_index = util.wrap(filter_lfo_wave_index + delta, 1, #filter_lfo_waves)
    update_filter_swipe_state(true)
end

local function change_cutoff(delta)
    engine_cutoff = util.clamp(engine_cutoff * math.pow(2, delta / 12), 40, 16000)
    sync_filter_swipe_from_tone()
end

local function change_resonance(delta)
    engine_resonance = util.clamp(engine_resonance + (delta * 0.05), 0, 4)
    sync_filter_swipe_from_tone()
end

local function change_drive(delta)
    engine_drive = util.clamp(engine_drive + (delta * 0.05), 0, 1)
end

local function change_pan_lfo_rate(delta)
    engine_pan_lfo_rate = util.clamp(engine_pan_lfo_rate + (delta * 0.1), 0, 12)
end

local function change_pan_lfo_depth(delta)
    engine_pan_lfo_depth = util.clamp(engine_pan_lfo_depth + (delta * 0.05), 0, 1)
end

local function change_musical_param(param_name, delta)
    if param_name == "Note" then
        change_note(delta)
    elseif param_name == "Tempo Subdivision" then
        change_division(delta)
    elseif param_name == "Scale" then
        change_scale(delta)
    elseif param_name == "Scale Presence" then
        change_presence(delta)
    elseif param_name == "Octaves" then
        change_octaves(delta)
    elseif param_name == "Probability" then
        change_probability(delta)
    end

    sync_script_params()
end

local function change_engine_param(param_name, delta)
    if param_name == "Probability" then
        change_probability(delta)
    elseif param_name == "Dynamics" then
        performance_state.dynamics_index = util.clamp(performance_state.dynamics_index + delta, 1, #harmony_model.dynamic_labels)
    elseif param_name == "Attack" then
        change_attack(delta)
    elseif param_name == "Release" then
        change_release(delta)
    elseif param_name == "WaveType" then
        change_wave_type(delta)
    elseif param_name == "Mod2" then
        change_mod2(delta)
    end

    apply_engine_params()
    sync_script_params()
end

local function change_tone_param(param_name, delta)
    if param_name == "Cutoff" then
        change_cutoff(delta)
    elseif param_name == "Resonance" then
        change_resonance(delta)
    elseif param_name == "Drive" then
        change_drive(delta)
    elseif param_name == "Pan Rate" then
        change_pan_lfo_rate(delta)
    elseif param_name == "Pan Depth" then
        change_pan_lfo_depth(delta)
    end

    apply_engine_params()
    sync_script_params()
end

local function change_filter_lfo_param(param_name, delta)
    if param_name == "LFO Rate" then
        change_filter_lfo_rate(delta)
    elseif param_name == "LFO Depth" then
        change_filter_lfo_depth(delta)
    elseif param_name == "LFO Wave" then
        change_filter_lfo_wave(delta)
    end

    sync_script_params()
end

local function change_timbre_motion_param(param_name, delta)
    if param_name == "Motion" then
        change_timbre_motion_enabled(delta)
    elseif param_name == "Preset" then
        change_timbre_motion_preset(delta)
    elseif param_name == "Rate" then
        change_timbre_motion_rate(delta)
    end

    sync_script_params()
end

local function change_presence_motion_param(param_name, delta)
    if param_name == "Motion" then
        change_presence_motion_enabled(delta)
    elseif param_name == "Preset" then
        change_presence_motion_preset(delta)
    elseif param_name == "Rate" then
        change_presence_motion_rate(delta)
    end

    sync_script_params()
end

local function change_rhythm_motion_param(param_name, delta)
    if param_name == "Motion" then
        change_rhythm_motion_enabled(delta)
    elseif param_name == "Preset" then
        change_rhythm_motion_preset(delta)
    elseif param_name == "Rate" then
        change_rhythm_motion_rate(delta)
    elseif param_name == "Chord Engage" then
        change_rhythm_chord_engage(delta)
    end

    sync_script_params()
end

local function format_cutoff_value()
    if engine_cutoff >= 1000 then
        return string.format("%.1fk", engine_cutoff / 1000)
    end

    return string.format("%d", math.floor(engine_cutoff + 0.5))
end

local function format_filter_lfo_rate()
    if filter_lfo_rate <= 0 then
        return "Off"
    end

    return string.format("%.2f Hz", filter_lfo_rate)
end

local function format_filter_lfo_depth()
    return string.format("%.0f%%", filter_lfo_depth * 100)
end

local function filter_lfo_wave_name()
    return filter_lfo_waves[filter_lfo_wave_index]
end

local function timbre_motion_status_text()
    return timbre_motion.enabled and "On" or "Off"
end

local function timbre_motion_preset_name()
    return timbre_motion_preset().name
end

local function format_timbre_motion_rate()
    return string.format("%.2fx", timbre_motion.rate)
end

local function presence_motion_status_text()
    return presence_motion.enabled and "On" or "Off"
end

local function presence_motion_preset_name()
    return presence_motion_preset().name
end

local function format_presence_motion_rate()
    return string.format("%.2fx", presence_motion.rate)
end

local function rhythm_motion_status_text()
    return rhythm_motion.enabled and "On" or "Off"
end

local function rhythm_motion_preset_name()
    return rhythm_motion_preset().name
end

local function format_rhythm_motion_rate()
    return string.format("%.2fx", rhythm_motion.rate)
end

local function format_rhythm_chord_engage()
    if rhythm_motion.chord_engage <= 0 then
        return "Off"
    end

    return string.format("%d%%", rhythm_motion.chord_engage)
end

local function effective_engine_release()
    return engine_release
end

local function freeze_release_seconds()
    return util.clamp(current_step_division() * clock.get_beat_sec(), 0.15, 3.0)
end

local function visualizer_presence_text()
    return string.upper(string.sub(presences[current_presence], 1, 1))
end

local function current_division_text()
    return tempo_divisions[rhythm_motion.current_division_index]
end

local function current_probability_text()
    return string.format("%d%%", rhythm_motion.current_probability)
end

sync_script_params = function()
    if not params or param_state.syncing then
        return
    end

    param_state.syncing = true
    params:set(param_state.ids.playback, playing and 2 or 1)
    params:set(param_state.ids.chord_mode, performance_state.chord_mode_held and 2 or 1)
    params:set(param_state.ids.freeze, ((performance_state.button_1_held or performance_state.freeze_param_held) and performance_state.chord_mode_held) and 2 or 1)
    params:set(param_state.ids.note, selected_note)
    params:set(param_state.ids.division, selected_division)
    params:set(param_state.ids.scale, selected_scale)
    params:set(param_state.ids.presence, selected_presence)
    params:set(param_state.ids.octaves, selected_octave_index)
    params:set(param_state.ids.probability, probability)
    params:set(param_state.ids.dynamics, performance_state.dynamics_index)
    params:set(param_state.ids.attack, engine_attack)
    params:set(param_state.ids.release, engine_release)
    params:set(param_state.ids.wave_type, find_wave_type_option_index(engine_wave_type))
    params:set(param_state.ids.mod2, engine_mod2)
    params:set(param_state.ids.filter_swipe, filter_swipe_base * 100)
    params:set(param_state.ids.cutoff, engine_cutoff)
    params:set(param_state.ids.resonance, engine_resonance)
    params:set(param_state.ids.drive, engine_drive)
    params:set(param_state.ids.pan_rate, engine_pan_lfo_rate)
    params:set(param_state.ids.pan_depth, engine_pan_lfo_depth)
    params:set(param_state.ids.filter_lfo_rate, filter_lfo_rate)
    params:set(param_state.ids.filter_lfo_depth, filter_lfo_depth)
    params:set(param_state.ids.filter_lfo_wave, filter_lfo_wave_index)
    params:set(param_state.ids.timbre_motion, timbre_motion.enabled and 2 or 1)
    params:set(param_state.ids.timbre_preset, timbre_motion.preset_index)
    params:set(param_state.ids.timbre_rate, timbre_motion.rate)
    params:set(param_state.ids.presence_motion, presence_motion.enabled and 2 or 1)
    params:set(param_state.ids.presence_preset, presence_motion.preset_index)
    params:set(param_state.ids.presence_rate, presence_motion.rate)
    params:set(param_state.ids.rhythm_motion, rhythm_motion.enabled and 2 or 1)
    params:set(param_state.ids.rhythm_preset, rhythm_motion.preset_index)
    params:set(param_state.ids.rhythm_rate, rhythm_motion.rate)
    params:set(param_state.ids.rhythm_chord, rhythm_motion.chord_engage)
    param_state.syncing = false
end

local function init_script_params()
    local scale_names = {}
    local octave_names = {}
    local wave_names = {}

    for index, scale in ipairs(scales) do
        scale_names[index] = scale.name
    end

    for index = 1, #octaves_options do
        if octaves_options[index] == "+/-1" then
            octave_names[index] = "+1/-1"
        elseif octaves_options[index] == "+/-2" then
            octave_names[index] = "+2/-2"
        else
            octave_names[index] = octaves_options[index]
        end
    end

    for index, value in ipairs(wave_type_options) do
        wave_names[index] = tostring(value)
    end

    params:add_separator("fake_script", "FAKE")
    params:add_option(param_state.ids.playback, "Playback", {"Off", "On"}, playing and 2 or 1)
    params:set_action(param_state.ids.playback, function(value)
        if param_state.syncing then return end
        if value == 2 then start_playback() else stop_playback() end
    end)

    params:add_option(param_state.ids.chord_mode, "Chord Mode", {"Off", "On"}, performance_state.chord_mode_held and 2 or 1)
    params:set_action(param_state.ids.chord_mode, function(value)
        if param_state.syncing then return end
        performance_state.chord_param_held = value == 2
        performance_state.chord_mode_held = performance_state.button_3_held or performance_state.chord_param_held
        ui_state.visualizer_shift_held = performance_state.button_1_held and not performance_state.chord_mode_held
        update_freeze_state()
        sync_script_params()
        redraw()
    end)

    params:add_option(param_state.ids.freeze, "Freeze", {"Off", "On"}, 1)
    params:set_action(param_state.ids.freeze, function(value)
        if param_state.syncing then return end
        performance_state.freeze_param_held = value == 2 and performance_state.chord_mode_held
        update_freeze_state()
        sync_script_params()
        redraw()
    end)

    params:add_option(param_state.ids.note, "Note", notes, selected_note)
    params:set_action(param_state.ids.note, function(value)
        if param_state.syncing then return end
        change_note(value - selected_note)
        redraw()
    end)

    params:add_option(param_state.ids.division, "Tempo Subdivision", tempo_divisions, selected_division)
    params:set_action(param_state.ids.division, function(value)
        if param_state.syncing then return end
        change_division(value - selected_division)
        redraw()
    end)

    params:add_option(param_state.ids.scale, "Scale", scale_names, selected_scale)
    params:set_action(param_state.ids.scale, function(value)
        if param_state.syncing then return end
        change_scale(value - selected_scale)
        redraw()
    end)

    params:add_option(param_state.ids.presence, "Scale Presence", presences, selected_presence)
    params:set_action(param_state.ids.presence, function(value)
        if param_state.syncing then return end
        change_presence(value - selected_presence)
        redraw()
    end)

    params:add_option(param_state.ids.octaves, "Octaves", octave_names, selected_octave_index)
    params:set_action(param_state.ids.octaves, function(value)
        if param_state.syncing then return end
        change_octaves(value - selected_octave_index)
        redraw()
    end)

    params:add{type="number", id=param_state.ids.probability, name="Probability", min=5, max=100, default=probability,
        action=function(value)
            if param_state.syncing then return end
            probability = util.clamp(value, 5, 100)
            reset_rhythm_motion()
            redraw()
        end}

    params:add_option(param_state.ids.dynamics, "Dynamics", harmony_model.dynamic_labels, performance_state.dynamics_index)
    params:set_action(param_state.ids.dynamics, function(value)
        if param_state.syncing then return end
        performance_state.dynamics_index = value
        redraw()
    end)

    params:add{type="control", id=param_state.ids.attack, name="Attack",
        controlspec=controlspec.new(0.001, 10, "exp", 0, engine_attack, ""),
        action=function(value)
            if param_state.syncing then return end
            engine_attack = value
            apply_engine_params()
            redraw()
        end}

    params:add{type="control", id=param_state.ids.release, name="Release",
        controlspec=controlspec.new(0.1, 10, "lin", 0, engine_release, ""),
        action=function(value)
            if param_state.syncing then return end
            engine_release = value
            apply_engine_params()
            redraw()
        end}

    params:add_option(param_state.ids.wave_type, "WaveType", wave_names, find_wave_type_option_index(engine_wave_type))
    params:set_action(param_state.ids.wave_type, function(value)
        if param_state.syncing then return end
        engine_wave_type = wave_type_options[value]
        reset_timbre_motion(true)
        redraw()
    end)

    params:add{type="control", id=param_state.ids.mod2, name="Mod2",
        controlspec=controlspec.new(0, 1, "lin", 0, engine_mod2, ""),
        action=function(value)
            if param_state.syncing then return end
            engine_mod2 = value
            apply_engine_params()
            redraw()
        end}

    params:add{type="control", id=param_state.ids.filter_swipe, name="Filter Swipe",
        controlspec=controlspec.new(0, 100, "lin", 1, filter_swipe_base * 100, "%"),
        action=function(value)
            if param_state.syncing then return end
            filter_swipe_base = util.clamp(value / 100, 0, 1)
            update_filter_swipe_state(true)
            sync_script_params()
            redraw()
        end}

    params:add{type="control", id=param_state.ids.cutoff, name="Cutoff",
        controlspec=controlspec.new(40, 16000, "exp", 0, engine_cutoff, "hz"),
        action=function(value)
            if param_state.syncing then return end
            engine_cutoff = value
            sync_filter_swipe_from_tone()
            apply_engine_params()
            sync_script_params()
            redraw()
        end}

    params:add{type="control", id=param_state.ids.resonance, name="Resonance",
        controlspec=controlspec.new(0, 4, "lin", 0, engine_resonance, ""),
        action=function(value)
            if param_state.syncing then return end
            engine_resonance = value
            sync_filter_swipe_from_tone()
            apply_engine_params()
            sync_script_params()
            redraw()
        end}

    params:add{type="control", id=param_state.ids.drive, name="Drive",
        controlspec=controlspec.new(0, 1, "lin", 0, engine_drive, ""),
        action=function(value)
            if param_state.syncing then return end
            engine_drive = value
            apply_engine_params()
            redraw()
        end}

    params:add{type="control", id=param_state.ids.pan_rate, name="Pan Rate",
        controlspec=controlspec.new(0, 12, "lin", 0, engine_pan_lfo_rate, "hz"),
        action=function(value)
            if param_state.syncing then return end
            engine_pan_lfo_rate = value
            apply_engine_params()
            redraw()
        end}

    params:add{type="control", id=param_state.ids.pan_depth, name="Pan Depth",
        controlspec=controlspec.new(0, 1, "lin", 0, engine_pan_lfo_depth, ""),
        action=function(value)
            if param_state.syncing then return end
            engine_pan_lfo_depth = value
            apply_engine_params()
            redraw()
        end}

    params:add{type="control", id=param_state.ids.filter_lfo_rate, name="Filter LFO Rate",
        controlspec=controlspec.new(0, 4, "lin", 0, filter_lfo_rate, "hz"),
        action=function(value)
            if param_state.syncing then return end
            filter_lfo_rate = value
            if filter_lfo_rate == 0 then filter_lfo_current = 0 else filter_lfo_phase = 0 end
            update_filter_swipe_state(true)
            redraw()
        end}

    params:add{type="control", id=param_state.ids.filter_lfo_depth, name="Filter LFO Depth",
        controlspec=controlspec.new(0, 1, "lin", 0, filter_lfo_depth, ""),
        action=function(value)
            if param_state.syncing then return end
            filter_lfo_depth = value
            if filter_lfo_depth == 0 then filter_lfo_current = 0 end
            update_filter_swipe_state(true)
            redraw()
        end}

    params:add_option(param_state.ids.filter_lfo_wave, "Filter LFO Wave", filter_lfo_waves, filter_lfo_wave_index)
    params:set_action(param_state.ids.filter_lfo_wave, function(value)
        if param_state.syncing then return end
        filter_lfo_wave_index = value
        redraw()
    end)

    params:add_option(param_state.ids.timbre_motion, "Timbre Motion", {"Off", "On"}, timbre_motion.enabled and 2 or 1)
    params:set_action(param_state.ids.timbre_motion, function(value)
        if param_state.syncing then return end
        change_timbre_motion_enabled(value == 2 and 1 or -1)
        redraw()
    end)

    params:add_option(param_state.ids.timbre_preset, "Timbre Preset", (function()
        local names = {}
        for index, preset in ipairs(timbre_motion.presets) do names[index] = preset.name end
        return names
    end)(), timbre_motion.preset_index)
    params:set_action(param_state.ids.timbre_preset, function(value)
        if param_state.syncing then return end
        timbre_motion.preset_index = value
        reset_timbre_motion(true)
        redraw()
    end)

    params:add{type="control", id=param_state.ids.timbre_rate, name="Timbre Rate",
        controlspec=controlspec.new(0.25, 4, "lin", 0, timbre_motion.rate, "x"),
        action=function(value)
            if param_state.syncing then return end
            timbre_motion.rate = value
            reset_timbre_motion(true)
            redraw()
        end}

    params:add_option(param_state.ids.presence_motion, "Presence Motion", {"Off", "On"}, presence_motion.enabled and 2 or 1)
    params:set_action(param_state.ids.presence_motion, function(value)
        if param_state.syncing then return end
        change_presence_motion_enabled(value == 2 and 1 or -1)
        redraw()
    end)

    params:add_option(param_state.ids.presence_preset, "Presence Preset", (function()
        local names = {}
        for index, preset in ipairs(presence_motion.presets) do names[index] = preset.name end
        return names
    end)(), presence_motion.preset_index)
    params:set_action(param_state.ids.presence_preset, function(value)
        if param_state.syncing then return end
        presence_motion.preset_index = value
        reset_presence_motion()
        redraw()
    end)

    params:add{type="control", id=param_state.ids.presence_rate, name="Presence Rate",
        controlspec=controlspec.new(0.25, 3, "lin", 0, presence_motion.rate, "x"),
        action=function(value)
            if param_state.syncing then return end
            presence_motion.rate = value
            reset_presence_motion()
            redraw()
        end}

    params:add_option(param_state.ids.rhythm_motion, "Rhythm Motion", {"Off", "On"}, rhythm_motion.enabled and 2 or 1)
    params:set_action(param_state.ids.rhythm_motion, function(value)
        if param_state.syncing then return end
        change_rhythm_motion_enabled(value == 2 and 1 or -1)
        redraw()
    end)

    params:add_option(param_state.ids.rhythm_preset, "Rhythm Preset", (function()
        local names = {}
        for index, preset in ipairs(rhythm_motion.presets) do names[index] = preset.name end
        return names
    end)(), rhythm_motion.preset_index)
    params:set_action(param_state.ids.rhythm_preset, function(value)
        if param_state.syncing then return end
        rhythm_motion.preset_index = value
        reset_rhythm_motion()
        redraw()
    end)

    params:add{type="control", id=param_state.ids.rhythm_rate, name="Rhythm Rate",
        controlspec=controlspec.new(0.25, 4, "lin", 0, rhythm_motion.rate, "x"),
        action=function(value)
            if param_state.syncing then return end
            rhythm_motion.rate = value
            reset_rhythm_motion()
            redraw()
        end}

    params:add{type="number", id=param_state.ids.rhythm_chord, name="Chord Engage", min=0, max=100, default=rhythm_motion.chord_engage,
        action=function(value)
            if param_state.syncing then return end
            rhythm_motion.chord_engage = util.clamp(value, 0, 100)
            redraw()
        end}
end

local function init_midi_devices()
    local count = (midi and midi.vports and #midi.vports) or 0
    midi_state.devices = {}

    for index = 1, count do
        midi_state.devices[index] = midi.connect(index)
        midi_state.devices[index].event = function(data)
            local message = midi.to_msg(data)

            if message.type == "note_on" and message.vel and message.vel > 0 then
                params:set(param_state.ids.note, (message.note % 12) + 1)
            end
        end
    end
end

local function octaves_display_text()
    if octaves_options[selected_octave_index] == "+/-1" then
        return "+1/-1"
    elseif octaves_options[selected_octave_index] == "+/-2" then
        return "+2/-2"
    end

    return octaves_options[selected_octave_index]
end

local function draw_visualizer_value(index, x, y, text, align_right)
    screen.level(index == ui_state.visualizer_param_index and 15 or 5)
    screen.move(x, y)

    if align_right then
        screen.text_right(text)
    else
        screen.text(text)
    end
end

local function draw_visualizer_octaves_value(index, x, y)
    local level = index == ui_state.visualizer_param_index and 15 or 5
    local option = octaves_options[selected_octave_index]

    if option == "+/-1" or option == "+/-2" then
        local number = string.sub(option, -1)
        local glyph_x = x
        local glyph_y = y - 7

        pixel_fill(glyph_x + 1, glyph_y, 1, level)
        pixel_fill(glyph_x, glyph_y + 1, 3, level)
        pixel_fill(glyph_x + 1, glyph_y + 2, 1, level)
        pixel_fill(glyph_x, glyph_y + 5, 3, level)

        screen.level(level)
        screen.move(x + 6, y)
        screen.text(number)
        return
    end

    draw_visualizer_value(index, x, y, octaves_display_text(), false)
end

local function movement_weight(candidate_pitch_steps, previous_pitch_steps)
    local source_pitch_steps = previous_pitch_steps

    if source_pitch_steps == nil then
        source_pitch_steps = last_pitch_steps
    end

    if source_pitch_steps == nil then
        return 1
    end

    local distance = math.abs(candidate_pitch_steps - source_pitch_steps)
    local movement_weights = harmony_model.movement_weights

    if distance == 0 then
        return movement_weights.repeat_note
    elseif distance <= 2 then
        return movement_weights.step
    elseif distance <= 5 then
        return movement_weights.near
    elseif distance <= 9 then
        return movement_weights.leap
    end

    return movement_weights.far
end

local function octave_weight(octave_offset)
    return harmony_model.octave_weights[math.abs(octave_offset)] or harmony_model.default_octave_weight
end

local function candidate_frequency(selected_candidate)
    local root_frequency = 440 * math.pow(2, (selected_note - 10) / 12)
    return root_frequency * math.pow(2, selected_candidate.octave_offset + (selected_candidate.interval / 12))
end

local function weighted_choice(candidates)
    local total_weight = 0

    for _, candidate in ipairs(candidates) do
        total_weight = total_weight + candidate.weight
    end

    if total_weight <= 0 then
        return candidates[math.random(#candidates)]
    end

    local threshold = math.random() * total_weight
    local running_weight = 0

    for _, candidate in ipairs(candidates) do
        running_weight = running_weight + candidate.weight

        if threshold <= running_weight then
            return candidate
        end
    end

    return candidates[#candidates]
end

local function build_note_candidates(previous_pitch_steps, excluded_pitch_steps)
    local profile = presence_profiles[current_presence]
    local candidates = {}
    local excluded = excluded_pitch_steps or {}

    if not profile or #profile == 0 then
        return candidates
    end

    for _, entry in ipairs(profile) do
        for _, octave_offset in ipairs(octave_intervals) do
            local pitch_steps = entry.interval + (octave_offset * 12)

            if not excluded[pitch_steps] then
                candidates[#candidates + 1] = {
                    interval = entry.interval,
                    octave_offset = octave_offset,
                    pitch_steps = pitch_steps,
                    weight = entry.weight * octave_weight(octave_offset) * movement_weight(pitch_steps, previous_pitch_steps)
                }
            end
        end
    end

    return candidates
end

local function select_next_candidate(previous_pitch_steps, excluded_pitch_steps)
    local candidates = build_note_candidates(previous_pitch_steps, excluded_pitch_steps)

    if #candidates == 0 then
        return nil, nil
    end

    local selected_candidate = weighted_choice(candidates)
    return selected_candidate, candidate_frequency(selected_candidate)
end

local function build_step_event()
    if not chord_mode_active() then
        local selected_candidate, frequency = select_next_candidate(last_pitch_steps)

        if selected_candidate == nil then
            return {}, {}
        end

        last_pitch_steps = selected_candidate.pitch_steps
        return {frequency}, {selected_candidate}
    end

    local frequencies = {}
    local selected_candidates = {}
    local excluded_pitch_steps = {}
    local simulated_pitch_steps = last_pitch_steps

    for _ = 1, chord_note_count do
        local selected_candidate, frequency = select_next_candidate(simulated_pitch_steps, excluded_pitch_steps)

        if selected_candidate == nil then
            break
        end

        frequencies[#frequencies + 1] = frequency
        selected_candidates[#selected_candidates + 1] = selected_candidate
        excluded_pitch_steps[selected_candidate.pitch_steps] = true
        simulated_pitch_steps = selected_candidate.pitch_steps
    end

    if #selected_candidates > 0 then
        last_pitch_steps = selected_candidates[#selected_candidates].pitch_steps
    end

    return frequencies, selected_candidates
end

apply_engine_params = function()
    engine.attack(engine_attack)
    engine.release(effective_engine_release())
    engine.waveType(current_wave_type)
    engine.mod2(engine_mod2)
    engine.cutoff(engine_cutoff)
    engine.resonance(engine_resonance)
    engine.drive(engine_drive)
    engine.panLfoRate(engine_pan_lfo_rate)
    engine.panLfoDepth(engine_pan_lfo_depth)
end

local function start_frozen_chord(frequencies, amp_scale, replace_existing)
    if performance_state.freeze_active or not playing or frequencies == nil or #frequencies == 0 then
        return
    end

    if replace_existing then
        engine.stopAllVoices()
    end

    performance_state.freeze_releasing = false
    performance_state.freeze_release_until = 0
    performance_state.freeze_release_seconds = freeze_release_seconds()
    engine.freezeRelease(performance_state.freeze_release_seconds)
    apply_engine_params()
    engine.eventAmp(amp_scale or 1.0)

    for _, frequency in ipairs(frequencies) do
        engine.freezeHz(frequency)
    end

    performance_state.freeze_armed = false
    performance_state.freeze_active = true
end

local function stop_frozen_chord()
    if not performance_state.freeze_active then
        performance_state.freeze_armed = false
        return
    end

    engine.stopFreezeVoices()
    performance_state.freeze_armed = false
    performance_state.freeze_active = false
    performance_state.freeze_releasing = true
    performance_state.freeze_release_until = util.time() + (performance_state.freeze_release_seconds or 0)
end

update_freeze_state = function()
    local freeze_hold = performance_state.button_1_held or performance_state.freeze_param_held

    if not performance_state.chord_mode_held then
        performance_state.freeze_param_held = false
        performance_state.freeze_armed = false
        stop_frozen_chord()
        return
    end
    if not freeze_hold then
        performance_state.freeze_armed = false
        stop_frozen_chord()
        return
    end

    if not performance_state.freeze_active then
        performance_state.freeze_armed = true
    end
end

local function freeze_arm_grace_seconds()
    local step_seconds = current_step_division() * clock.get_beat_sec()
    return util.clamp(step_seconds * 0.12, 0.012, 0.03)
end

current_step_division = function()
    local division = clock_divisions[rhythm_motion.current_division_index]

    if chord_mode_active() then
        return division * 2
    end

    return division
end

local function play_note()
    while true do
        if performance_state.chord_mode_held or performance_state.freeze_active or performance_state.freeze_releasing then
            performance_state.auto_chord_for_step = false
        elseif rhythm_motion.chord_engage > 0 then
            performance_state.auto_chord_for_step = math.random(100) <= rhythm_motion.chord_engage
        else
            performance_state.auto_chord_for_step = false
        end

        clock.sync(current_step_division())

        if performance_state.chord_mode_held and not performance_state.freeze_active then
            clock.sleep(freeze_arm_grace_seconds())
        end

        if performance_state.freeze_releasing and util.time() >= (performance_state.freeze_release_until or 0) then
            performance_state.freeze_releasing = false
            performance_state.freeze_release_until = 0
        end

        if performance_state.freeze_active or performance_state.freeze_releasing then
            -- Sustained chord is handled separately by the engine.
        elseif math.random(100) <= rhythm_motion.current_probability then
            local frequencies, selected_candidates = build_step_event()
            local event_amp_scale = event_dynamics_scale()
            local presence_changed = false

            if #frequencies > 0 then
                if performance_state.chord_mode_held and performance_state.freeze_armed and performance_state.button_1_held then
                    start_frozen_chord(frequencies, event_amp_scale)
                else
                    apply_engine_params()
                    engine.eventAmp(event_amp_scale)

                    for _, frequency in ipairs(frequencies) do
                        engine.hz(frequency)
                    end
                end

                for _, selected_candidate in ipairs(selected_candidates) do
                    trigger_visualizer(selected_candidate)
                end

                if not performance_state.freeze_active then
                    presence_changed = consume_presence_motion_step()
                end
            end

            if presence_changed and page == 7 then
                redraw()
            end
        end

        if not performance_state.freeze_active and not performance_state.freeze_releasing then
            local rhythm_changed = consume_rhythm_motion_step()
            local wave_changed = consume_timbre_motion_step()

            if wave_changed and page == 6 then
                redraw()
            elseif rhythm_changed and page == 8 then
                redraw()
            end
        end
    end
end

start_playback = function()
    if playing then
        return
    end

    reset_timbre_motion(false)
    reset_presence_motion()
    reset_rhythm_motion()
    apply_engine_params()
    clock_id = clock.run(play_note)
    playing = true
    sync_script_params()
    redraw()
end

stop_playback = function()
    if not playing then
        return
    end

    if clock_id then
        clock.cancel(clock_id)
        clock_id = nil
    end

    stop_frozen_chord()
    playing = false
    performance_state.auto_chord_for_step = false
    performance_state.freeze_releasing = false
    performance_state.freeze_release_until = 0
    reset_phrase_memory()
    sync_script_params()
    redraw()
end

local function toggle_playback()
    if playing then
        stop_playback()
    else
        start_playback()
    end
end

local function tick_visualizer()
    visual_frame = (visual_frame + 1) % 512
    visual_flash = visual_flash * 0.82

    if visual_flash < 0.02 then
        visual_flash = 0
    end

    if #visual_particles > 0 then
        local next_particles = {}

        for _, particle in ipairs(visual_particles) do
            particle.x = particle.x + particle.vx
            particle.y = particle.y + particle.vy
            particle.age = particle.age + 1

            local screen_x = 64 + particle.x
            local screen_y = 1 + particle.y

            if particle.age <= particle.life and screen_x >= -4 and screen_x <= 132 and screen_y >= -4 and screen_y <= 66 then
                next_particles[#next_particles + 1] = particle
            end
        end

        visual_particles = next_particles
    end

    if filter_lfo_rate > 0 and filter_lfo_depth > 0 and visual_metro ~= nil then
        filter_lfo_phase = (filter_lfo_phase + (filter_lfo_rate * visual_metro.time)) % 1
        filter_lfo_current = filter_lfo_wave_value(filter_lfo_phase)
        update_filter_swipe_state(true)
    elseif filter_lfo_current ~= 0 then
        filter_lfo_current = 0
        update_filter_swipe_state(true)
    end

    if page == 1 or page == 5 or page == 6 or page == 7 or page == 8 then
        redraw()
    end
end

local function draw_visualizer_page()
    local presence = current_presence
    local active_pairs = clamp_number(presence, 1, #tower_arm_pairs)
    local center_x = 64
    local tower_y = 1
    local info_y = 58
    local body_level = clamp_number(5 + presence, 1, 15)
    local accent_level = clamp_number(8 + presence, 1, 15)
    local active_level = clamp_number(accent_level + math.floor(visual_flash * 5), 1, 15)
    local inactive_level = clamp_number(2 + math.floor(presence / 2), 1, 7)

    screen.level(3)
    screen.rect(0, 62, 128, 1)
    screen.fill()

    draw_filter_swipe_feedback(center_x, tower_y, clamp_number(4 + math.floor(filter_swipe * 6) + math.floor(visual_flash * 2), 3, 15))
    draw_tower_body(center_x, tower_y, body_level, accent_level)

    for pair_index = #tower_arm_pairs, 1, -1 do
        local pair = tower_arm_pairs[pair_index]
        draw_tower_arm(center_x, tower_y, pair, pair_index <= active_pairs, active_level, inactive_level)
    end

    if #visual_particles > 0 then
        for _, particle in ipairs(visual_particles) do
            local fade = 1 - (particle.age / particle.life)
            local particle_level = clamp_number(math.floor((particle.base_level * fade) + 0.5), 1, 15)

            if particle_level > 1 then
                pixel_fill(
                    math.floor(center_x + particle.x + 0.5),
                    math.floor(tower_y + particle.y + 0.5),
                    particle.size,
                    particle_level
                )
            end
        end
    end

    draw_visualizer_value(1, 6, info_y, notes[selected_note], false)
    draw_visualizer_value(2, 18, info_y, current_division_text(), false)
    draw_visualizer_octaves_value(3, 39, info_y)
    draw_visualizer_value(4, 92, info_y, visualizer_presence_text(), false)
    draw_visualizer_value(5, 102, info_y, current_probability_text(), false)
end

function init()
    update_presence_profiles()
    update_octave_intervals()
    reset_phrase_memory()
    reset_timbre_motion(false)
    reset_presence_motion()
    reset_rhythm_motion()
    init_script_params()
    apply_engine_params()
    update_filter_swipe_state(true)
    sync_script_params()
    init_midi_devices()

    visual_metro = metro.init()
    visual_metro.time = 1 / 15
    visual_metro.count = -1
    visual_metro.event = tick_visualizer
    visual_metro:start()

    screen.aa(0)
    screen.line_width(1)
    redraw()
end

function cleanup()
    if visual_metro ~= nil then
        visual_metro:stop()
    end

    stop_playback()
    engine.stopAllVoices()
end

function key(n, z)
    if n == 1 then
        performance_state.button_1_held = z == 1
        ui_state.visualizer_shift_held = performance_state.button_1_held and not performance_state.chord_mode_held
        update_freeze_state()
        sync_script_params()

        if page == 1 then
            redraw()
        end

        return
    end

    if n == 3 then
        performance_state.button_3_held = z == 1
        performance_state.chord_mode_held = performance_state.button_3_held or performance_state.chord_param_held
        ui_state.visualizer_shift_held = performance_state.button_1_held and not performance_state.chord_mode_held

        update_freeze_state()
        sync_script_params()

        if page == 1 then
            redraw()
        end

        return
    end

    if z ~= 1 then
        return
    end

    if n == 2 then
        toggle_playback()
    end
end

function enc(n, d)
    if n == 1 then
        page = util.wrap(page + d, 1, max_pages)
        redraw()
        return
    end

    if page == 1 then
        if n == 2 then
            if ui_state.visualizer_shift_held then
                ui_state.visualizer_param_index = util.clamp(ui_state.visualizer_param_index + d, 1, #visualizer_params)
            else
                change_filter_swipe(d)
            end
        elseif n == 3 then
            change_musical_param(visualizer_params[ui_state.visualizer_param_index], d)
        end
    elseif page == 2 then
        if n == 2 then
            ui_state.current_params[1] = util.clamp(ui_state.current_params[1] + d, 1, #params_page_1)
        elseif n == 3 then
            change_musical_param(params_page_1[ui_state.current_params[1]], d)
        end
    elseif page == 3 then
        if n == 2 then
            ui_state.current_params[2] = util.clamp(ui_state.current_params[2] + d, 1, #params_page_2)
        elseif n == 3 then
            change_engine_param(params_page_2[ui_state.current_params[2]], d)
        end
    elseif page == 4 then
        if n == 2 then
            ui_state.current_params[3] = util.clamp(ui_state.current_params[3] + d, 1, #params_page_3)
        elseif n == 3 then
            change_tone_param(params_page_3[ui_state.current_params[3]], d)
        end
    elseif page == 5 then
        if n == 2 then
            ui_state.current_params[4] = util.clamp(ui_state.current_params[4] + d, 1, #params_page_4)
        elseif n == 3 then
            change_filter_lfo_param(params_page_4[ui_state.current_params[4]], d)
        end
    elseif page == 6 then
        if n == 2 then
            ui_state.current_params[5] = util.clamp(ui_state.current_params[5] + d, 1, #params_page_5)
        elseif n == 3 then
            change_timbre_motion_param(params_page_5[ui_state.current_params[5]], d)
        end
    elseif page == 7 then
        if n == 2 then
            ui_state.current_params[6] = util.clamp(ui_state.current_params[6] + d, 1, #params_page_6)
        elseif n == 3 then
            change_presence_motion_param(params_page_6[ui_state.current_params[6]], d)
        end
    elseif page == 8 then
        if n == 2 then
            ui_state.current_params[7] = util.clamp(ui_state.current_params[7] + d, 1, #params_page_7)
        elseif n == 3 then
            change_rhythm_motion_param(params_page_7[ui_state.current_params[7]], d)
        end
    end

    redraw()
end

function redraw()
    screen.clear()

    if page == 1 then
        draw_visualizer_page()
        screen.update()
        return
    end

    screen.move(2, 10)
    screen.level(15)
    screen.text(page_titles[page] or ("Page " .. page))

    local compact_layout = page == 3 or page == 8
    local y_offset = compact_layout and 18 or 20
    local line_step = compact_layout and 9 or 10

    if page == 2 then
        for i, param_name in ipairs(params_page_1) do
            screen.move(10, y_offset + ((i - 1) * line_step))
            screen.level(i == ui_state.current_params[1] and 15 or 5)

            if param_name == "Note" then
                screen.text(param_name .. ": " .. notes[selected_note])
            elseif param_name == "Tempo Subdivision" then
                screen.text(param_name .. ": " .. tempo_divisions[selected_division])
            elseif param_name == "Scale" then
                screen.text(param_name .. ": " .. scales[selected_scale].name)
            elseif param_name == "Scale Presence" then
                screen.text(param_name .. ": " .. presences[selected_presence])
            elseif param_name == "Octaves" then
                screen.text(param_name .. ": " .. octaves_display_text())
            end
        end
    elseif page == 3 then
        for i, param_name in ipairs(params_page_2) do
            screen.move(10, y_offset + ((i - 1) * line_step))
            screen.level(i == ui_state.current_params[2] and 15 or 5)

            if param_name == "Probability" then
                screen.text(param_name .. ": " .. probability .. "%")
            elseif param_name == "Dynamics" then
                screen.text(param_name .. ": " .. harmony_model.dynamic_labels[performance_state.dynamics_index])
            elseif param_name == "Attack" then
                screen.text(param_name .. ": " .. string.format("%.2f", engine_attack))
            elseif param_name == "Release" then
                screen.text(param_name .. ": " .. string.format("%.1f", engine_release))
            elseif param_name == "WaveType" then
                screen.text(param_name .. ": " .. engine_wave_type)
            elseif param_name == "Mod2" then
                screen.text(param_name .. ": " .. string.format("%.2f", engine_mod2))
            end
        end
    elseif page == 4 then
        for i, param_name in ipairs(params_page_3) do
            screen.move(10, y_offset + ((i - 1) * line_step))
            screen.level(i == ui_state.current_params[3] and 15 or 5)

            if param_name == "Cutoff" then
                screen.text(param_name .. ": " .. format_cutoff_value())
            elseif param_name == "Resonance" then
                screen.text(param_name .. ": " .. string.format("%.2f", engine_resonance))
            elseif param_name == "Drive" then
                screen.text(param_name .. ": " .. string.format("%.2f", engine_drive))
            elseif param_name == "Pan Rate" then
                screen.text(param_name .. ": " .. string.format("%.1f Hz", engine_pan_lfo_rate))
            elseif param_name == "Pan Depth" then
                screen.text(param_name .. ": " .. string.format("%.0f%%", engine_pan_lfo_depth * 100))
            end
        end
    elseif page == 5 then
        for i, param_name in ipairs(params_page_4) do
            screen.move(10, y_offset + ((i - 1) * line_step))
            screen.level(i == ui_state.current_params[4] and 15 or 5)

            if param_name == "LFO Rate" then
                screen.text(param_name .. ": " .. format_filter_lfo_rate())
            elseif param_name == "LFO Depth" then
                screen.text(param_name .. ": " .. format_filter_lfo_depth())
            elseif param_name == "LFO Wave" then
                screen.text(param_name .. ": " .. filter_lfo_wave_name())
            end
        end

        screen.move(10, 54)
        screen.level(8)
        screen.text("Base: " .. string.format("%.0f%%", filter_swipe_base * 100))
        screen.move(10, 62)
        screen.text("Sweep: " .. string.format("%.0f%%", filter_swipe * 100))
    elseif page == 6 then
        for i, param_name in ipairs(params_page_5) do
            screen.move(10, y_offset + ((i - 1) * line_step))
            screen.level(i == ui_state.current_params[5] and 15 or 5)

            if param_name == "Motion" then
                screen.text(param_name .. ": " .. timbre_motion_status_text())
            elseif param_name == "Preset" then
                screen.text(param_name .. ": " .. timbre_motion_preset_name())
            elseif param_name == "Rate" then
                screen.text(param_name .. ": " .. format_timbre_motion_rate())
            end
        end

        screen.move(10, 54)
        screen.level(8)
        screen.text("Anchor: " .. engine_wave_type)
        screen.move(10, 62)
        screen.text("Current: " .. current_wave_type)
    elseif page == 7 then
        for i, param_name in ipairs(params_page_6) do
            screen.move(10, y_offset + ((i - 1) * line_step))
            screen.level(i == ui_state.current_params[6] and 15 or 5)

            if param_name == "Motion" then
                screen.text(param_name .. ": " .. presence_motion_status_text())
            elseif param_name == "Preset" then
                screen.text(param_name .. ": " .. presence_motion_preset_name())
            elseif param_name == "Rate" then
                screen.text(param_name .. ": " .. format_presence_motion_rate())
            end
        end

        screen.move(10, 54)
        screen.level(8)
        screen.text("Anchor: " .. presences[selected_presence])
        screen.move(10, 62)
        screen.text("Current: " .. presences[current_presence])
    elseif page == 8 then
        for i, param_name in ipairs(params_page_7) do
            screen.move(10, y_offset + ((i - 1) * line_step))
            screen.level(i == ui_state.current_params[7] and 15 or 5)

            if param_name == "Motion" then
                screen.text(param_name .. ": " .. rhythm_motion_status_text())
            elseif param_name == "Preset" then
                screen.text(param_name .. ": " .. rhythm_motion_preset_name())
            elseif param_name == "Rate" then
                screen.text(param_name .. ": " .. format_rhythm_motion_rate())
            elseif param_name == "Chord Engage" then
                screen.text(param_name .. ": " .. format_rhythm_chord_engage())
            end
        end

        screen.move(10, 56)
        screen.level(8)
        screen.text("Div " .. tempo_divisions[selected_division] .. " > " .. current_division_text())
        screen.move(10, 63)
        screen.text("Prob " .. probability .. "% > " .. current_probability_text())
    end

    screen.update()
end
