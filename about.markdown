---
layout: page
title: About
description: A bit about me.
permalink: /about/
---
<div class="prose__body" markdown="1">

## Welcome everyone!

My name is Max. I'm a computer geek from Ukraine. If you want to reach me, you can email me at [max@nedelchev.org](mailto:max@nedelchev.org).


## Yearly years

I've been playing with computers since I was a kid. My father was an engineer and he was into electronics. He could repair TVs and radios. He was subscribed to a magazine that was promoting a ZX Spectrum kit. So, my first computer was a ZX Spectrum which was assembled by my dad.

The ZX Spectrum had a rectangle-shaped box with a keyboard. It connected to a TV set. Games were loaded from cassette tapes. I started learning programming. The first language was BASIC. My first programs were "PLOT and DRAW" programs to draw pictures of cars, houses, etc. Then I got acquainted with IF and FOR commands. By leveraging these commands, I was able to create simple games such as HIGH and LOW.
![ZX Spectrum](/assets/images/zx_spectrum.jpg)
After the ZX Spectrum, I got a Soviet PC called Practic. It had a black and white screen and a diskette drive. I got acquainted with MS-DOS. At the same time, my friend from my building had a 486DX2 computer which was more powerful, and he could play games like Prince of Persia, Civilization I, Supaplex, Metal Mutants, and Wolfenstein 3D. Unfortunately, my PC was not able to run almost all of these games. For example, I was able to run Prince of Persia, but the performance was slow—the speed was like 0.5x. So, I started to learn programming in order to create my own games, because when you're a kid, all you want to do is play games.
![Practic PC](/assets/images/pracktik2.png)

A significant improvement came with the AMD K5 PR133. It was 1996. It was the era of Doom 2, Quake, Duke Nukem 3D, etc. I kept learning languages. The languages on my plate were Pascal and C/C++, plus a bit of assembler.

Around the year 2000, I upgraded to a PC powered by an Intel Celeron 333MHz — a significant leap forward. It was around this time that I discovered overclocking. By adjusting the front-side bus frequency, I managed to push the CPU to a stable 413MHz, squeezing out extra performance without spending a penny. The gaming scene was thriving: I spent countless hours in Half-Life, Unreal Tournament, and Warcraft 2, games that felt like technological marvels at the time. On the programming side, Delphi had taken the Windows development world by storm with its rapid application development approach. I dug into Delphi alongside Win32 API and DirectX, learning how to build native Windows applications and experiment with real-time graphics — the foundation of my ambition to create my own games.

At that time, the internet was not so available. It was expensive and slow. We were using dial-up connections with 56K modems. In our building, we set up a LAN 10Mbps network which connected 3 apartments. This allowed us to play games together without the internet. We played FIFA 99, Duke Nukem 3D, Warcraft 2, Half-Life, and Red Alert. However, one of our most favorite games was [MineBombers](https://fi.wikipedia.org/wiki/Mine_Bombers).

<iframe width="100%" height="315" src="https://www.youtube.com/embed/j-NvmIiVzqs" title="Mine Bombers ( Versus Mode - DOS - 1995 )" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>


Mine Bombers is a mixture of Bomberman and Boulder Dash in which 2-4 players mine for gold and diamonds while trying to kill each other. It was released for DOS and came with a level editor.

I had a strong desire to create my own version of MineBombers but for Windows and with network play. I managed to create an alpha version of it. It allowed playing with up to 4 players on the same computer, but I never managed to implement network play.
You can check the source code [here](https://github.com/ssnake/tnt).

Here you can play it in your browser using ReactOS emulated via v86!

**Controls:**
- Player 1: 
  - SEDF to move
  - 1 - stop
  - q - place a bomb/fire
  - a - select a weapon
  - z - trigger remote detonators
- Player 2: 
  - Arrows to move
  - Enter - place a bomb/fire
  - Ctrl - select a weapon
  - Space - trigger remote detonators
- Player 3:
  - Numpads - to move
  - Numpad 0 - stop
  - Numpad 1 - place a bomb/fire
  - Numpad 2 - trigger remote detonators
  - Numpad . - select a weapon

<style>
  .vm-wrap { max-width: 850px; margin: var(--space-8) auto; }
  .vm-note {
    background: var(--color-surface);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-md);
    padding: var(--space-4);
    margin-bottom: var(--space-6);
    font-size: var(--text-sm);
    color: var(--color-text-muted);
  }
  .vm-note strong { color: var(--color-text); }
  #screen_container {
    position: relative;
    width: 800px;
    height: 600px;
    margin: 0 auto;
    border: 1px solid var(--color-border);
    border-radius: var(--radius-md);
    background: #000;
  }
  #screen_container canvas {
    width: 100% !important;
    height: 100% !important;
    image-rendering: pixelated;
    border-radius: var(--radius-md);
  }
  .vm-controls { text-align: center; margin: var(--space-4) 0; }
  .vm-btn {
    padding: var(--space-3) var(--space-6);
    font-size: var(--text-sm);
    font-family: var(--font-sans);
    font-weight: 600;
    cursor: pointer;
    background: var(--color-accent);
    color: #fff;
    border: none;
    border-radius: var(--radius-sm);
    transition: background var(--transition);
  }
  .vm-btn:hover { background: var(--color-accent-hover); }
  .vm-btn:disabled { opacity: 0.5; cursor: not-allowed; }
  #vm-status {
    text-align: center;
    font-family: var(--font-mono);
    font-size: var(--text-xs);
    color: var(--color-text-muted);
    padding: var(--space-3) var(--space-4);
    background: var(--color-surface);
    border: 1px solid var(--color-border);
    border-radius: var(--radius-sm);
    margin-top: var(--space-3);
  }
</style>

<div class="vm-wrap">
  <div class="vm-note"><strong>Note:</strong> This downloads ~20MB on first load (compressed pre-booted snapshot). The game is cached after the first visit.</div>
  <div id="screen_container"></div>
  <div class="vm-controls">
    <button id="start_btn" class="vm-btn" onclick="startGame()">Start Emulator</button>
  </div>
  <div id="vm-status">Click "Start Emulator" to begin</div>
</div>

<script src="/assets/v86/libv86.js"></script>
<script>
let emulator = null;

function updateStatus(msg) {
    document.getElementById("vm-status").textContent = msg;
}

function startGame() {
    document.getElementById("start_btn").disabled = true;
    updateStatus("Initializing emulator...");

    emulator = new V86({
        wasm_path: "/assets/v86/v86.wasm",
        memory_size: 512 * 1024 * 1024,
        vga_memory_size: 8 * 1024 * 1024,
        screen_container: document.getElementById("screen_container"),
        bios: { url: "/assets/v86/seabios.bin" },
        vga_bios: { url: "/assets/v86/vgabios.bin" },
        hda: {
            url: "/assets/v86/images/reactos.img.zst",
            async: true,
            size: 512 * 1024 * 1024,
            use_parts: true,
            fixed_chunk_size: 99 * 1024 * 1024
        },
        initial_state: {
            url: "/assets/v86/images/reactos.state.bin.zst",
        },
        boot_order: 0x132,
        acpi: true,
        autostart: true,
        disable_speaker: true,
    });

    emulator.add_listener("emulator-ready", function() {
        updateStatus("Emulator ready!");
    });

    emulator.add_listener("download-progress", function(e) {
        if (e.file_name && e.file_name.includes("reactos.img")) {
            const percent = e.total ? Math.round(e.loaded / e.total * 100) : 0;
            const mb = (e.loaded / (1024 * 1024)).toFixed(0);
            updateStatus(`Downloading ReactOS: ${mb}MB (${percent}%)`);
        }
    });

    emulator.add_listener("emulator-loaded", function() {
        updateStatus("The game is loaded!");
    });

    updateStatus("Loading v86 components...");
}
</script>
## NASA Hackathon

In 2016, I participated in the NASA Space Apps Challenge, a global hackathon where participants from diverse backgrounds collaborate to solve real-world problems presented by NASA. I competed locally at the event in Kyiv, Ukraine.

Among the various challenges provided by NASA, I chose to focus on aircraft contrails (condensation trails). Scientists often struggle to distinguish natural cloud formations from artificial contrails, making atmospheric research more difficult. To address this, our team developed a specialized tool to help researchers accurately identify and study these formations. Here is a demonstration of our solution:

<iframe title="vimeo-player" src="https://player.vimeo.com/video/164688220?h=c8c889c35e" width="640" height="360" frameborder="0" referrerpolicy="strict-origin-when-cross-origin" allow="autoplay; fullscreen; picture-in-picture; clipboard-write; encrypted-media; web-share"   allowfullscreen></iframe>

Our application won the silver medal at the local stage and was selected as a Global Nominee. You can learn more about it on our [official project page](https://2016.spaceappschallenge.org/challenges/aero/clouds-or-contrails/projects/contrails).

## Nowadays

I've started this blog in the era of raising of AI. Nowadays AI agents are capable to do human-like tasks. It seems that the future is already here.

</div>
