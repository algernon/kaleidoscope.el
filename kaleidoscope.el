;;; kaleidoscope.el -- Controlling Kaleidoscope-powered devices
;;
;; Copyright (c) 2017 Gergely Nagy
;;
;; Author: Gergely Nagy
;; URL: https://github.com/algernon/kaleidoscope.el
;; Package-Requires: ((s "1.11.0"))
;;
;; This file is NOT part of GNU Emacs.
;;
;;; Commentary:
;;
;; This is a small library to talk to Kaleidoscope-powered devices - such as the
;; Keyboardio Model 01 - from within Emacs. It provides low-level functions that
;; aid in communication.
;;
;;; License: GPLv3+

;;; Code:

(provide 'kaleidoscope)

;;;; Settings

(defgroup kaleidoscope nil
  "Customization group for 'kaleidoscope'."
  :group 'comm)

(defcustom kaleidoscope/device-port "/dev/ttyACM0"
  "Serial port the device is connected to."
  :group 'kaleidoscope
  :type 'string)

;;;; Helpers

(defun kaleidoscope/send-command (command &optional args)
  "Send a command with (optional) arguments to the device. The
command must be a keyword, and the arguments a pre-formatted
string."
  (process-send-command "*kaleidoscope*"
   (s-join " "
           (list (s-chop-prefix ":" (s-replace "/" "." (symbol-name command)))
                 args))))

(defun kaleidoscope/color-to-rgb (color)
  "Convert a color name or hexadecimal RGB representation to a
string suitable for Kaleidoscope's LED commands."
  (mapconcat (lambda (c) (format "%d" (round (* 255 c))))
             (color-name-to-rgb color)
             " "))

;;;; Main entry point

;;;###autoload
(defun kaleidoscope-start ()
  "Connect to the device on 'kaleidoscope/device-port'."
  (interactive)

  (make-serial-process :port kaleidoscope/device-port
                       :speed 9600
                       :name "*kaleidoscope*"
                       :buffer "*kaleidoscope*"))

;;;###autoload
(defun kaleidoscope-quit ()
  "Disconnect from the device."
  (interactive)

  (quit-process "*kaleidoscope*"))
