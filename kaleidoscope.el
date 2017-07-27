;;; Kaleidoscope -- Kaleidoscope-powered device control from Emacs
;;
;; Copyright (c) 2017 Gergely Nagy
;;
;; Author: Gergely Nagy
;; URL: https://github.com/algernon/kaleidoscope.el
;; Package-Requires: ((evil "1.2.12") (s "1.11.0"))
;;
;; This file is NOT part of GNU Emacs.
;;
;;; Commentary:
;;
;; TODO
;;
;;; License: GPLv3+

;;; Code:

(provide 'kaleidoscope)

;;;; Settings

(defgroup kaleidoscope nil
  "Customization group for 'Kaleidoscope'."
  :group 'comm)

(defcustom kaleidoscope/keyboard-port "/dev/ttyACM0"
  "Serial port to connect to the keyboard with."
  :group 'kaleidoscope
  :type 'string)

;;;; Helpers

(defun kaleidoscope/send-command (command args)
  (process-send-command "*kaleidoscope*"
   (s-join " "
           (list (s-chop-prefix ":" (s-replace "/" "." (symbol-name command)))
                 args))))

(defun kaleidoscope/color-to-rgb (color)
  (mapconcat (lambda (c) (format "%d" (round (* 255 c))))
             (color-name-to-rgb color)
             " "))

;;;; Main entry point

;;;###autoload
(defun kaleidoscope-start ()
  (interactive)

  (make-serial-process :port kaleidoscope/keyboard-port
                       :speed 9600
                       :name "*kaleidoscope*"
                       :buffer "*kaleidoscope*"))

;;;###autoload
(defun kaleidoscope-quit ()
  (interactive)

  (quit-process "*kaleidoscope*"))
