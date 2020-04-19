;;; shrface+.el -- "shrface+": extensions to library `shrface.el' -*- lexical-binding: t; -*-

;; Copyright (C) 2020 Damon Chan

;; Author: Damon Chan <elecming@gmail.com>
;; URL: https://github.com/chenyanming/shrface-plus
;; Keywords: faces
;; Created: 19 April 2020
;; Version: 1.0
;; Package-Requires: ((emacs "24") (org "9.0"))

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; shrface+: extensions to library `shrface.el'
;; Apply org faces to non-org buffers
;
;; The following major modes are supported:
;;
;; 1. w3m mode
;; 2. info mode
;; 3. helpful mode

;;; Code:

(require 'shrface)

(defun shrface-plus-w3m-headline-fontify ()
  "Fontify bold text in the buffer containing halfdump."
  (goto-char (point-min))
  (while (re-search-forward "^<b>.*</b>$" nil t)
    (beginning-of-line)
    (let ((start (match-beginning 0)))
      (insert (propertize (concat (shrface-bullets-level-string 1) " ") 'face 'shrface-h1-face))
      (delete-region start (match-beginning 0))
      (when (re-search-forward "</b>" nil t) ;; "</b[ \t\r\f\n]*"
        (delete-region (match-beginning 0) (match-end 0))
        (w3m-add-face-property start (match-beginning 0) 'shrface-h1-face)))))

(defun shrface-plus-helpful-heading (text)
  "Propertize TEXT as a heading."
  (format "%s\n" (propertize (concat "◉ " text) 'face 'shrface-h2-face)))

(defun shrface-plus-info-mode-fontify ()
  "Fontify info mode bufffer"
  ;; (face-remap-add-relative 'info-title-1 '(:height nil))
  ;; (face-remap-add-relative 'info-menu-header 'org-title)
  (face-remap-add-relative 'info-title-1 'shrface-h1-face)
  (face-remap-add-relative 'info-title-2 'shrface-h2-face)
  (face-remap-add-relative 'info-title-3 'shrface-h3-face)
  (face-remap-add-relative 'info-title-4 'shrface-h4-face)
  (face-remap-add-relative 'info-xref 'shrface-href-face)
  (face-remap-add-relative 'info-xref-visited 'org-done)
  (face-remap-add-relative 'Info-quoted 'shrface-verbatim))

(defun shrface-plus-helpful-mode-fontify ()
  "Fontify helpful mode bufffer"
  ;; (face-remap-add-relative 'helpful-heading 'org-level-2)
  (advice-add 'helpful--heading :override 'shrface-plus-helpful-heading))

(defun shrface-plus-w3m-mode-fontify ()
  "Fontify w3m mode bufffer"
  (face-remap-add-relative 'w3m-header-line-title 'shrface-h1-face)
  (face-remap-add-relative 'w3m-anchor 'shrface-href-face)
  ;; (face-remap-add-relative 'w3m-current-anchor 'link)
  )

(defun shrface-plus ()
  "Fontify all supported major mode"
  (interactive)
  (cond ((eq major-mode 'w3m-mode)
         (shrface-plus-w3m-mode-fontify))
        ((eq major-mode 'Info-mode)
         (shrface-plus-info-mode-fontify))
        ((eq major-mode 'helpful-mode)
         (shrface-plus-helpful-mode-fontify))))

;; (add-hook 'shrface-mode-hook #'shrface-plus)
(provide 'shrface+)
;;; shrface+.el ends here;;;
