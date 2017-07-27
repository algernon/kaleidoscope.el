;;; Kaleidoscope -- Kaleidoscope-powered device control from Emacs
;;
;; Copyright (c) 2017 Gergely Nagy
;;
;; Author: Gergely Nagy
;; URL: https://github.com/algernon/kaleidoscope.el
;; Package-Requires: ((evil "1.2.12"))
;;
;; This file is NOT part of GNU Emacs.
;;
;;; Commentary:
;;
;; TODO
;;
;;; License: GPLv3+

;;; Code:

;;;; Settings

(defgroup kaleidoscope nil
  "Customization group for 'Kaleidoscope'."
  :group 'comm)

(defcustom kaleidoscope/insert-state-color "#66CE00"
  "Color to flash when entering the 'insert' state."
  :group 'kaleidoscope
  :type 'color)

(defcustom kaleidoscope/visual-state-color "#BFBFBF"
  "Color to flash when entering the 'visual' state."
  :group 'kaleidoscope
  :type 'color)

(defcustom kaleidoscope/normal-state-color "#EFAE0E"
  "Color to flash when entering the 'normal' state."
  :group 'kaleidoscope
  :type 'color)

(defcustom kaleidoscope/replace-state-color "#D3691E"
  "Color to flash when entering the 'replace' state."
  :group 'kaleidoscope
  :type 'color)

(defcustom kaleidoscope/keyboard-port "/dev/ttyACM0"
  "Serial port to connect to the keyboard with."
  :group 'kaleidoscope
  :type 'string)

(defcustom kaleidoscope/flash-duration "1 sec"
  "Duration of the flash."
  :group 'kaleidoscope
  :type 'string)

;;;; Helpers

(defun kaleidoscope/command (command)
  (process-send-string "*kaleidoscope*" (format "%s\n" command)))

(defun kaleidoscope/color-to-rgb (color)
  (mapconcat (lambda (c) (format "%d" (round (* 255 c))))
             (color-name-to-rgb color)
             " "))

(defun kaleidoscope/leds-off ()
  (kaleidoscope/command "led.setAll 0 0 0"))

(defun kaleidoscope/flash ()
  (let ((color (eval (intern (concat "kaleidoscope/" (symbol-name evil-next-state) "-state-color")))))
    (kaleidoscope/command (format "led.setAll %s" (kaleidoscope/color-to-rgb color)))
    (run-at-time kaleidoscope/flash-duration nil
                 #'kaleidoscope/leds-off)))

;;;; Main entry point

(make-serial-process :port kaleidoscope/keyboard-port
                     :speed 9600
                     :name "*kaleidoscope*"
                     :buffer "*kaleidoscope*")

(mapc (lambda (state)
        (add-hook state #'kaleidoscope/flash))
      '(evil-insert-state-entry-hook
        evil-visual-state-entry-hook
        evil-replace-state-entry-hook
        evil-normal-state-entry-hook))

(provide 'kaleidoscope)
