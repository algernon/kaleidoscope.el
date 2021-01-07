kaleidoscope.el
===============

[![MELPA: kaleidoscope](https://melpa.org/packages/kaleidoscope-badge.svg)](https://melpa.org/#/kaleidoscope)
[![MELPA: kaleidoscope-evil-state-flash](https://melpa.org/packages/kaleidoscope-evil-state-flash-badge.svg)](https://melpa.org/#/kaleidoscope-evil-state-flash)

An Emacs interface to [Kaleidoscope][kaleidoscope] powered devices, such as
the [Keyboard.io Model01][kbdio:model01]. It requires appropriate hardware, and
a customised firmware that allows bi-directional communication
(the [FocusSerial][focus:serial] plugin does just this).

 [kaleidoscope]: https://github.com/keyboardio/Kaleidoscope
 [kbdio:model01]: https://shop.keyboard.io/
 [focus:serial]: https://kaleidoscope.readthedocs.io/en/latest/plugins/Kaleidoscope-FocusSerial.html

Usage
-----

There are two parts for this package, `kaleidoscope.el` and
`kaleidoscope-evil-state-flash.el`. The former implements the lower level
communication, and the rest is an example of what can be built upon this
foundation.

To use either, one needs to require `kaleidoscope`, and start the communication
as such:

```emacs-lisp
(require 'kaleidoscope)
(kaleidoscope-start)
```

To stop talking to the keyboard, and release the device lock, one can call
`(kaleidoscope-quit)`.

While the channel is active, the `kaleidoscope-send-command` function can be
used to send commands to the keyboard. The results will appear in the
`*kaleidoscope*` buffer.

```emacs-lisp
(kaleidoscope-send-command :help)
(kaleidoscope-send-command :led/setAll "255 0 0")
```

Using `kaleidoscope-evil-state-flash`
-------------------------------------

The `kaleidoscope-evil-state-flash` package ships with a function that sets up
hooks so that whenever Evil changes state, the keyboard will briefly flash in a
color configured for the target state. Assuming the keyboard is set to a LED
mode that allows this (such as `LEDOff`).

To enable or disable this flashing, call `kaleidoscope-evil-state-flash-setup`
or `kaleidoscope-evil-state-flash-teardown` respectively.

Note that for the LED Control to work, your Kaleidoscope firmware must have the
`FOCUS_HOOK_LEDCONTROL` enabled on top of enabling the [Focus plugin][kaleidoscope:focus].

```cpp
Focus.addHook(FOCUS_HOOK_LEDCONTROL);
```

Demo
----

A short, video of the package (showing `kaleidoscope-evil-state-flash` in
action) can be [found here][demo].

[demo]: https://www.youtube.com/watch?v=XrrqZXmg6k4

Copyright & License
-------------------

Copyright (c) 2017 Gergely Nagy, released under the terms of the GNU GPLv3+.
