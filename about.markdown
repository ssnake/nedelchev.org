---
layout: page
title: About
description: A bit about me.
permalink: /about/
---
<div class="prose__body" markdown="1">

## Welcome everyone!

My name is Max. I'm a computer geek from Ukraine.


## Background

I've been playing with computers since I was a kid. My father was an engineer and he was into electronics. He could repair TVs and radios. He was subscribed to a magazine that was promoting a ZX Spectrum kit. So, my first computer was a ZX Spectrum which was assembled by my dad.

The ZX Spectrum had a rectangle-shaped box with a keyboard. It connected to a TV set. Games were loaded from cassette tapes. I started learning programming. The first language was BASIC. My first programs were "PLOT and DRAW" programs to draw pictures of cars, houses, etc. Then I got acquainted with IF and FOR commands. By leveraging these commands, I was able to create simple games such as HIGH and LOW.
![ZX Spectrum](/assets/images/zx_spectrum.jpg)
After the ZX Spectrum, I got a Soviet PC called Practic. It had a black and white screen and a diskette drive. I got acquainted with MS-DOS. At the same time, my friend from my building had a 486DX2 computer which was more powerful, and he could play games like Prince of Persia, Civilization I, Supaplex, Metal Mutants, and Wolfenstein 3D. Unfortunately, my PC was not able to run almost all of these games. For example, I was able to run Prince of Persia, but the performance was slow—the speed was like 0.5x. So, I started to learn programming in order to create my own games, because when you're a kid, all you want to do is play games.
![Practic PC](/assets/images/practik.jpg)

A significant improvement came with the AMD K5 PR133. It was 1996. It was the era of Doom 2, Quake, Duke Nukem 3D, etc. I kept learning languages. The languages on my plate were Pascal and C/C++, plus a bit of assembler.

A further improvement was a PC with Celeron 333MHz. I got familiar with overclocking. I was able to overclock it to 413MHz. PC games were Half-Life, Unreal Tournament, Warcraft 2, etc. As for programming frameworks, at that time Delphi was super popular. I started learning Win32 API, DirectX, and Delphi.

At that time, the internet was not so available. It was expensive and slow. We were using dial-up connections with 56K modems. In our building, we set up a LAN 10Mbps network which connected 3 apartments. This allowed us to play games together without the internet. We played FIFA 99, Duke Nukem 3D, Warcraft 2, Half-Life, and Red Alert. However, one of our most favorite games was [MineBombers](https://fi.wikipedia.org/wiki/Mine_Bombers).

<iframe width="100%" height="315" src="https://www.youtube.com/embed/j-NvmIiVzqs" title="Mine Bombers ( Versus Mode - DOS - 1995 )" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>


Mine Bombers is a mixture of Bomberman and Boulder Dash in which 2-4 players mine for gold and diamonds while trying to kill each other. It was released for DOS and came with a level editor.

I had a strong desire to create my own version of MineBombers but for Windows and with network play. I managed to create an alpha version of it. It allowed playing with up to 4 players on the same computer, but I never managed to implement network play.

Here you can play it in your browser using ReactOS emulated via v86!

**Controls:**
- Player 1: WASD to move, Q to place bomb
- Player 2: IJKL to move, M to place bomb

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
  <div class="vm-note"><strong>Note:</strong> This downloads ~119MB on first load (pre-booted snapshot). The game is cached after the first visit.</div>
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
            url: "/assets/v86/images/reactos.img",
            async: true,
            size: 2 * 1024 * 1024 * 1024
        },
        initial_state: {
            url: "/assets/v86/images/reactos.state.bin",
        },
        boot_order: 0x132,
        acpi: true,
        autostart: true,
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

## Nowadays

I have extensive experience with frameworks and technologies, but I'm still learning new things.
What matters to me is critical thinking and the capability to think outside the box. 

Feel free to contact me if you have any questions or want to collaborate on a project.

[max@nedelchev.org](mailto:max@nedelchev.org)

</div>
