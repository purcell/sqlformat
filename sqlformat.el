;;; sqlformat.el --- Reformat SQL using sqlformat or pgformatter  -*- lexical-binding: t; -*-

;; Copyright (C) 2018  Steve Purcell

;; Author: Steve Purcell <steve@sanityinc.com>
;; Keywords: languages
;; Package-Requires: ((emacs "24"))
;; Version: 0

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; Provides commands and a minor mode for easily reformatting SQL
;; using external programs such as "sqlformat" and "pg_format".

;; Install the "sqlparse" (Python) package to get "sqlformat", or
;; "pgformatter" to get "pg_format".

;; Customise the `sqlformat-command' variable as desired, then call
;; `sqlformat' or `sqlformat-buffer' as convenient.

;; Enable `sqlformat-mode' in SQL buffers like this:

;;     (add-hook 'sql-mode-hook 'sqlformat-mode)

;; The `sqlformat' command will then be bound to "C-c C-f" by default.
;; If `sqlformat-mode-format-on-save' is enabled, this mode will apply
;; the configured `sqlformat-command' to the buffer every time it is
;; saved.

;;; Code:


;; Minor mode and customisation

(defgroup sqlformat nil
  "Reformat SQL using sqlformat or pgformatter."
  :group 'sql)

(defcustom sqlformat-command 'sqlformat
  "Command used for reformatting.
This command should receive SQL input via STDIN and output the
reformatted SQL to STDOUT, returning an appropriate exit code."
  :type '(choice (const :tag "Use \"sqlformat\"" sqlformat)
                 (const :tag "Use \"pgformatter\"" pgformatter)
                 (string :tag "Custom command")))

(defcustom sqlformat-mode-format-on-save nil
  "When non-nil, format the buffer on save."
  :type 'boolean)

(defcustom sqlformat-mode-lighter " SQLFmt"
  "Mode lighter for `sqlformat-mode'."
  :type 'string)

(defvar sqlformat-mode-map (make-sparse-keymap)
  "Keymap for `sqlformat-mode'.")

(define-key sqlformat-mode-map (kbd "C-c C-f") 'sqlformat)

(defun sqlformat--on-save ()
  "Function called from `before-save-hook' when `sqlformat-mode' is active."
  (when sqlformat-mode-format-on-save
    (sqlformat-buffer)))

;;;###autoload
(define-minor-mode sqlformat-mode
  "Easy access to SQL reformatting using external programs, optionally including on save."
  :global nil
  :keymap sqlformat-mode-map
  :lighter '(:eval sqlformat-mode-lighter)
  (if sqlformat-mode
      (add-hook 'before-save-hook 'sqlformat--on-save nil t)
    (remove-hook 'before-save-hook 'sqlformat--on-save t)))



;; Commands for reformatting

;;;###autoload
(defun sqlformat-buffer ()
  "Reformat the entire SQL buffer using the `sqlformat' command."
  (interactive)
  (sqlformat (point-min) (point-max)))

;;;###autoload
(defun sqlformat (beg end)
  "Reformat SQL in region from BEG to END using `sqlformat-command'.
If no region is active, the current statement (paragraph) is reformatted.
Install the \"sqlparse\" (Python) package to get \"sqlformat\", or
\"pgformatter\" to get \"pg_format\"."
  (interactive "r")
  (unless (use-region-p)
    (setq beg (save-excursion
                (backward-paragraph)
                (skip-syntax-forward " >")
                (point))
          end (save-excursion
                (forward-paragraph)
                (skip-syntax-backward " >")
                (point))))
  (let ((command (pcase sqlformat-command
                   (`sqlformat "sqlformat -r -")
                   (`pgformatter "pg_format -")
                   (custom custom)))
        (sqlbuf (current-buffer)))
    (with-temp-buffer
      (let ((outbuf (current-buffer)))
        (with-current-buffer sqlbuf
          (message "Command is %S" command)
          (when (zerop (shell-command-on-region beg end command outbuf nil "*sqlformat-errors*" t))
            (save-excursion
              (delete-region beg end)
              (goto-char beg)
              (insert-buffer-substring outbuf))))))))


(provide 'sqlformat)
;;; sqlformat.el ends here
