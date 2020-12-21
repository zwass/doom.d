;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Pace your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!

(global-subword-mode)


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Zach Wasserman"
      user-mail-address "zach@fleetdm.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "Office Code Pro" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(setq doom-theme 'doom-one)

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/org/")

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type t)

(map! :g "C-x g" 'magit-status)


(setq inhibit-compacting-font-caches t)

(use-package! ace-jump-mode
  :config
  (map! :g "C-c SPC" 'ace-jump-mode)
  (map! :g "C-c C-SPC" 'ace-jump-mode-pop-mark)
  )

(setq uniquify-buffer-name-style 'forward)

;; May fix crashes with which-key associated with modeline
(setq which-key-allow-imprecise-window-fit t)
;; Add an extra line to work around bug in which-key imprecise
(defun add-which-key-line (f &rest r) (progn (apply f (list (cons (+ 1 (car (car r))) (cdr (car r)))))))
(advice-add 'which-key--show-popup :around #'add-which-key-line)

(setq confirm-kill-emacs 'y-or-n-p)

(setq doom-modeline-buffer-encoding nil)

(map! :g "C-i" 'indent-for-tab-command)

(smartparens-global-mode nil)

;; Compilation mode for ESLint
;; Copied from https://github.com/Fuco1/compile-eslint/blob/master/compile-eslint.el
(defun compile-eslint--find-filename ()
  "Find the filename for current error."
  (save-match-data
    (save-excursion
      (when (re-search-backward (rx bol (group "/" (+ any)) eol))
        (list (match-string 1))))))
(let ((form `(eslint
              ,(rx-to-string
                '(and (group (group (+ digit)) ":" (group (+ digit)))
                      (+ " ") (or "error" "warning")))
              compile-eslint--find-filename
              2 3 2 1)))
  (if (assq 'eslint compilation-error-regexp-alist-alist)
      (setf (cdr (assq 'eslint compilation-error-regexp-alist-alist)) (cdr form))
    (push form compilation-error-regexp-alist-alist)))
(push 'eslint compilation-error-regexp-alist)

(use-package! jest
  :after (js2-mode)
  :hook (js2-mode . jest-minor-mode)
)

;; https://prathamesh.tech/2019/06/21/creating-pull-requests-from-emacs/
(defun visit-github-pull-request-url ()
  "Visit the current branch's PR on Github."
  (interactive)
  (browse-url
   (format "https://github.com/%s/pull/new/%s"
           (replace-regexp-in-string
            "\\`.+github\\.com:\\(.+\\)\\.git\\'" "\\1"
            (magit-get "remote"
                       (magit-get-push-remote)
                       "url"))
           (magit-get-current-branch))))
