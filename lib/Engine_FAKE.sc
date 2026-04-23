Engine_FAKE : CroneEngine {

  var server;
  var group;
  var voicer;
  var freezeVoicer;

  var hz1;
  var hz2;
  var mod1;
  var mod2;
  var amp;
  var pan;
  var attack;
  var release;

  var bangs;
  var thebang;
  var whichbang;

  var baseAmp;
  var waveAmpCompensation;

  var toneCutoff;
  var toneResonance;
  var drive;
  var panLfoRate;
  var panLfoDepth;
  var freezeRelease;
  var eventAmpScale;

  *new { |context, doneCallback|
    ^super.new(context, doneCallback)
  }

  alloc {
    server = context.server;
    group = Group.new(server);
    voicer = OneshVoicer.new(8);
    freezeVoicer = OneshVoicer.new(8);

    hz1 = 330;
    hz2 = 10000;
    mod1 = 0.5;
    mod2 = 0.5;
    pan = 0.0;
    attack = 0.01;
    release = 2.0;

    baseAmp = 0.1;
    waveAmpCompensation = [1.0, 1.0, 1.0, 1.20, 1.0, 1.0, 1.25];

    toneCutoff = 16000;
    toneResonance = 0.0;
    drive = 0.0;
    panLfoRate = 0.0;
    panLfoDepth = 0.0;
    freezeRelease = 0.25;
    eventAmpScale = 1.0;

    bangs = [\square, \square_mod1, \square_mod2, \sinfmlp, \sinfb, \reznoise, \klanglin];
    this.setWaveType(0);

    this.addCommand("hz", "f", { |msg|
      this.playVoice(msg[1]);
    });

    this.addCommand("freezeHz", "f", { |msg|
      this.playVoice(msg[1], true);
    });

    this.addCommand("attack", "f", { |msg|
      attack = msg[1];
    });

    this.addCommand("release", "f", { |msg|
      release = msg[1];
    });

    this.addCommand("waveType", "f", { |msg|
      this.setWaveType(msg[1]);
    });

    this.addCommand("mod2", "f", { |msg|
      mod2 = msg[1];
    });

    this.addCommand("cutoff", "f", { |msg|
      toneCutoff = msg[1];
    });

    this.addCommand("resonance", "f", { |msg|
      toneResonance = msg[1];
    });

    this.addCommand("drive", "f", { |msg|
      drive = msg[1];
    });

    this.addCommand("panLfoRate", "f", { |msg|
      panLfoRate = msg[1];
    });

    this.addCommand("panLfoDepth", "f", { |msg|
      panLfoDepth = msg[1];
    });

    this.addCommand("freezeRelease", "f", { |msg|
      freezeRelease = msg[1].clip(0.05, 8.0);
    });

    this.addCommand("eventAmp", "f", { |msg|
      eventAmpScale = msg[1].clip(0.4, 1.1);
    });

    this.addCommand("stealMode", "i", { |msg|
      voicer.stealMode = msg[1];
    });

    this.addCommand("maxVoices", "i", { |msg|
      voicer.maxVoices = msg[1];
    });

    this.addCommand("stopAllVoices", "", { |msg|
      voicer.stopAllVoices;
      freezeVoicer.stopAllVoices;
    });

    this.addCommand("stopFreezeVoices", "", { |msg|
      freezeVoicer.stopAllVoices;
    });
  }

  setWaveType { |waveType|
    var rawWaveType = waveType.asInteger.clip(0, 6);
    var actualWaveType = if(rawWaveType == 5, { 6 }, { rawWaveType });

    whichbang = actualWaveType;
    thebang = bangs[whichbang];
    amp = baseAmp * waveAmpCompensation[actualWaveType];
  }

  playVoice { |freq, sustain = false|
    var currentBang = thebang;
    var currentHz1 = if(freq.isNil, { hz1 }, { freq });
    var currentHz2 = hz2;
    var currentMod1 = mod1;
    var currentMod2 = mod2;
    var currentAmp = amp;
    var currentPan = pan;
    var currentAttack = attack;
    var currentRelease = release;
    var currentToneCutoff = toneCutoff.clip(40, 16000);
    var currentToneResonance = toneResonance.clip(0, 4);
    var currentDrive = drive.clip(0, 1);
    var currentPanLfoRate = panLfoRate.clip(0, 12);
    var currentPanLfoDepth = panLfoDepth.clip(0, 1);
    var currentFreezeRelease = freezeRelease.clip(0.05, 8.0);
    var currentEventAmpScale = eventAmpScale.clip(0.4, 1.1);
    var targetVoicer = if(sustain, { freezeVoicer }, { voicer });

    targetVoicer.newVoice({
      {
        arg gate = 1;
        var snd, toneEnv, ender, attackTime;
        var driveGain, driveTrim, shaped;
        var cutoff, resonance, rq, resonanceBoost;
        var panMotion, voicePan;

        if(sustain, {
          attackTime = currentAttack.max(0.005);
          // For freeze voices, avoid retriggering a second percussive envelope.
          // Keep timbre steady and fade only the overall amplitude in/out.
          toneEnv = 1;
          ender = EnvGen.ar(Env.asr(attackTime, 1, currentFreezeRelease), gate: gate, doneAction: Done.freeSelf);
        }, {
          toneEnv = EnvGen.ar(Env.perc(currentAttack, currentRelease), doneAction: Done.freeSelf);
          ender = EnvGen.ar(Env.asr(0, 1, 0.01), gate: gate, doneAction: Done.freeSelf);
        });

        snd = Bgs.perform(currentBang, currentHz1, currentMod1, currentHz2, currentMod2, toneEnv);

        driveGain = 1 + (currentDrive * 8);
        driveTrim = driveGain.pow(-0.35);
        shaped = LeakDC.ar(tanh(snd * driveGain)) * driveTrim;

        cutoff = Lag.kr(currentToneCutoff, 0.03);
        resonance = currentToneResonance;
        rq = LinLin.kr(resonance, 0, 4, 1.0, 0.08);
        resonanceBoost = LinLin.kr(resonance, 0, 4, 1.0, 1.12);
        shaped = RLPF.ar(shaped, cutoff, rq) * resonanceBoost;

        panMotion = 0;
        if(currentPanLfoRate > 0 and: { currentPanLfoDepth > 0 }, {
          panMotion = SinOsc.kr(currentPanLfoRate, Rand(0, 2pi), currentPanLfoDepth);
        });

        voicePan = (currentPan + panMotion).clip(-1, 1);

        Out.ar(0, Pan2.ar(shaped * toneEnv * currentAmp * currentEventAmpScale * ender, voicePan));
      }.play(group)
    });
  }

  free {
    voicer.stopAllVoices;
    freezeVoicer.stopAllVoices;
  }
}
