// FAKE_Bgs
//
// Namespaced local copy of the `Bgs` class used by the FAKE engine.
// Adapted from `pixels/lib/bgs.sc`.
//
// Original work:
//   pixels
//   Copyright (c) 2020 Arman Bohn
//   Licensed under the MIT License
//
// This file is included under a renamed class to avoid duplicate class
// definition conflicts on systems that already have pixels/thebangs installed.

FAKE_Bgs {

	*square {
		arg freq, pw, cutoff, gain, env;
		^MoogFF.ar(Pulse.ar(freq, pw), cutoff.min(16000).max(10), gain);
	}

	*square_mod1 {
		arg freq, pw, cutoff, gain, env;
		^MoogFF.ar(Pulse.ar(freq, pw * env), cutoff.min(16000).max(10), gain * env);
	}

	*square_mod2 {
		arg freq, pw, cutoff, gain, env;
		^MoogFF.ar(Pulse.ar(freq, pw * env), (cutoff * env).min(16000).max(10), gain);
	}

	*sinfmlp {
		arg hz1, mod1, hz2, mod2, env;
		^LPF.ar(PMOsc.ar(hz1, hz1 * mod2, mod1) * 0.666, hz2);
	}

	*sinfb {
		arg hz1, mod1, hz2, mod2, env;
		^MoogFF.ar(SinOscFB.ar(hz1, mod1 * 4), hz2, mod2);
	}

	*reznoise {
		arg hz1, mod1, hz2, mod2, env;
		var hh = [hz1, hz2];
		var snd = LFNoise2.ar((hh * (2 ** mod1)).min(SampleRate.ir * 0.5));
		^MoogFF.ar(snd, hh, mod2);
	}

	*klanglin {
		arg hz1, mod1, hz2, mod2, env;

		var freqGrowth, ampDecay,
		freqArr, ampArr, phaseArr,
		sz, amp;

		freqGrowth = hz1 * mod1 * 2;
		ampDecay = 1 - (0.5 ** mod2);
		freqArr = Array.series(16, hz1, freqGrowth).select({ |x| x <= hz2 });
		if (freqArr.isEmpty, { freqArr = [hz1] });
		sz = freqArr.size;
		ampArr = Array.geom(16, 1, ampDecay);
		ampArr = ampArr[0..(sz - 1)];
		amp = 1.0 / ampArr.sum * 0.25;
		phaseArr = Array.fill(sz, { |i| i * (pi / sz) });
		^Mix.new(freqArr.collect({ |f, i|
			Pan2.ar(SinOsc.ar(f, phaseArr[i]) * ampArr[i], i.linlin(0, sz - 1, -0.5, 0.5))
		})) * amp;
	}

	*klangexp {
		arg hz1, mod1, hz2, mod2, env;

		var freqGrowth, ampDecay,
		freqArr, ampArr, phaseArr,
		sz, amp;
		freqGrowth = 2 ** mod1;
		ampDecay = 1 - (0.5 ** mod2);
		freqArr = Array.geom(16, hz1, freqGrowth).select({ |x| x <= hz2 });
		if (freqArr.isEmpty, { freqArr = [hz1] });
		sz = freqArr.size;
		ampArr = Array.geom(16, 1, ampDecay);
		ampArr = ampArr[0..(sz - 1)];
		amp = 1.0 / ampArr.sum * 0.25;
		phaseArr = Array.fill(sz, { |i| i * (pi / sz) });
		^Mix.new(freqArr.collect({ |f, i|
			Pan2.ar(SinOsc.ar(f, phaseArr[i]) * ampArr[i], i.linlin(0, sz - 1, -0.5, 0.5))
		})) * amp;
	}
}
