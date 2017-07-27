;;; Kaleidoscope -- Kaleidoscope-powered device control from Emacs
;;
;; Copyright (c) 2017 Gergely Nagy
;;
;; Author: Gergely Nagy
;; URL: https://github.com/algernon/kaleidoscope.el
;;
;; This file is NOT part of GNU Emacs.
;;
;;; Commentary:
;;
;; TODO
;;
;;; License: GPLv3+

;;; Code:

(require 'kaleidoscope)

;;;; Settings

(defgroup kaleidoscope/evil-state-flash nil
  "Customization group for 'Kaleidoscope'."
  :group 'kaleidoscope)

(defcustom kaleidoscope/evil-state-flash/insert-state-color "#66CE00"
  "Color to flash when entering the 'insert' state."
  :group 'kaleidoscope/evil-state-flash
  :type 'color)

(defcustom kaleidoscope/evil-state-flash/visual-state-color "#BFBFBF"
  "Color to flash when entering the 'visual' state."
  :group 'kaleidoscope/evil-state-flash
  :type 'color)

(defcustom kaleidoscope/evil-state-flash/normal-state-color "#EFAE0E"
  "Color to flash when entering the 'normal' state."
  :group 'kaleidoscope/evil-state-flash
  :type 'color)

(defcustom kaleidoscope/evil-state-flash/replace-state-color "#D3691E"
  "Color to flash when entering the 'replace' state."
  :group 'kaleidoscope/evil-state-flash
  :type 'color)

(defcustom kaleidoscope/evil-state-flash/duration "1 sec"
  "Duration of the flash."
  :group 'kaleidoscope/evil-state-flash
  :type 'string)

;;;; Helpers

(defun kaleidoscope/evil-state-flash ()
  (let ((color (eval (intern (concat "kaleidoscope/evil-state-flash"
                                     (symbol-name evil-next-state)
                                     "-state-color")))))
    (kaleidoscope/send-command :led/setAll (kaleidoscope/color-to-rgb color))
    (run-at-time kaleidoscope/evil-state-flash/duration nil
                 (kaleidoscope/send-command :led/setAll "0 0 0"))))

;;;; Main entry point

;;;###autoload
(defun kaleidoscope/evil-state-flash-setup ()
  (interactive)

  (mapc (lambda (state)
          (add-hook state #'kaleidoscope/evil-state-flash))
        '(evil-insert-state-entry-hook
          evil-visual-state-entry-hook
          evil-replace-state-entry-hook
          evil-normal-state-entry-hook)))

;;;###autoload
(defun kaleidoscope/evil-state-flash-teardown ()
  (interactive)

  (mapc (lambda (state)
          (remove-hook state #'kaleidoscope/evil-state-flash))
        '(evil-insert-state-entry-hook
          evil-visual-state-entry-hook
          evil-replace-state-entry-hook
          evil-normal-state-entry-hook)))

(provide 'kaleidoscope-evil-state-flash)
