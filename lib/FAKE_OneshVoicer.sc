// FAKE_OneshVoicer
//
// Namespaced local copy of the `OneshVoicer` class used by the FAKE engine.
// Adapted from `pixels/lib/OneshVoicer.sc`.
//
// Original work:
//   pixels
//   Copyright (c) 2020 Arman Bohn
//   Licensed under the MIT License
//
// This file is included under a renamed class to avoid duplicate class
// definition conflicts on systems that already have pixels installed.

FAKE_OneshVoicer {
	var <maxVoices = 32;
	var <voices;
	var <stealMode = 1;
	var <>stealIdx = 0;

	*new { arg maxVoices;
		^super.new.init(maxVoices);
	}

	init { arg mv;
		maxVoices = mv;
		voices = Array.new;
	}

	stealMode_ { arg mode;
		postln("steal mode: " ++ mode);
		stealMode = mode;
	}

	maxVoices_ { arg max;
		if (max < maxVoices && stealMode != 3, {
			var activeVoiceCount = this.countActiveVoices;
			while ({ activeVoiceCount > max }, {
				this.stealVoice(activeVoiceCount);
				activeVoiceCount = this.countActiveVoices;
			});
		});
		maxVoices = max;
	}

	countActiveVoices {
		voices = voices.select({ arg v; v.isPlaying });
		^voices.size;
	}

	newVoice { arg fn;
		var activeVoiceCount;

		activeVoiceCount = this.countActiveVoices;

		if (activeVoiceCount < maxVoices, {
			this.addVoice(fn);
		}, {
			this.stealVoice(activeVoiceCount);
			if (stealMode != 3, {
				this.addVoice(fn);
			});
		});
	}

	stealVoice { arg activeVoiceCount;
		switch(stealMode,
			0, { this.stealVoiceIdx(stealIdx) },
			1, { this.stealVoiceIdx(0) },
			2, { this.stealVoiceIdx(activeVoiceCount - 1) },
			3, { }
		);
	}

	stealVoiceIdx { arg idx;
		var idxClamp, v;
		idxClamp = idx.max(0).min(voices.size - 1);
		v = voices[idxClamp];

		if (v.isNil.not, {
			if (v.isPlaying, {
				v.set(\gate, 0);
			});
			voices.removeAt(idxClamp);
		});
	}

	addVoice { arg fn;
		var syn;
		syn = fn.value;
		if (syn.isNil.not, {
			NodeWatcher.register(syn, true);
			voices = voices.add(syn);
		});
	}

	stopAllVoices {
		voices.do({ |v| v.set(\gate, 0); });
	}
}
