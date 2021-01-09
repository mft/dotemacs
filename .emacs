; -*- coding: utf-8 -*-

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

;;; 言語環境
(set-locale-environment "C")
;(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
;;; 以下の設定は
;;; http://nox-insomniae.ddo.jp/insomnia/2009/09/emacs23-mew-summary.html
;;; を参考にしている
;; iso-8859-* 優先
(set-charset-priority
 'ascii
 'latin-iso8859-1
 'cyrillic-iso8859-5
 'greek-iso8859-7
 'mule-unicode-0100-24ff
 'japanese-jisx0208
 'unicode
)
;; キリル・ギリシア文字の width を 1 に
;; (Unicode-cyrillic は不要)
;;; iso-8859-5 キリル文字
(map-charset-chars
 (lambda
   (range ignore)
   (set-char-table-range char-width-table range 1))
 'cyrillic-iso8859-5)
;;; iso-8859-7 ギリシア文字
(map-charset-chars
 (lambda
   (range ignore)
   (set-char-table-range char-width-table range 1))
 'greek-iso8859-7)
;;; Bidirectional texts are too rare to support by default
(setq-default bidi-display-reordering nil)


;;; フォント回り
;;; 参考: http://borg4.vdomains.jp/~goro/diary/2009/384
;;;       http://d.hatena.ne.jp/tunefs/20091002/p1
(when (and (>= emacs-major-version 23) (display-graphic-p))
  (set-frame-font "Courier-10")
  (modify-all-frames-parameters (list (assq 'font
(frame-parameters)))) ;複数フレームに対応
  (set-fontset-font
   (frame-parameter nil 'font)
   'katakana-jisx0201
   '("Hiragino Maru Gothic Pro" . "iso10646-1"))
  (set-fontset-font
   (frame-parameter nil 'font)
   'japanese-jisx0212
   '("Hiragino Maru Gothic Pro" . "iso10646-1"))
  (set-fontset-font
   (frame-parameter nil 'font)
   'japanese-jisx0208
   '("Hiragino Maru Gothic Pro" . "iso10646-1"))
  (set-fontset-font
   (frame-parameter nil 'font)
   'latin-iso8859-1
   '("courier" . "iso-10646-1"))
)


;;; Mac のおかしな挙動対策 (単独だと"\"なのに"C-\"が"C-¥"になる)
(when (eq system-type 'darwin)
  (global-set-key [?\C-¥] (lookup-key (current-global-map) "\C-\\"))
  (global-set-key [?\M-¥] (lookup-key (current-global-map) "\M-\\"))
  (global-set-key [?\C-\M-¥] (lookup-key (current-global-map) "\C-\M-\\"))
  (global-set-key [?\C-x ?\r ?\C-¥] (lookup-key (current-global-map)
"\C-x r \C-\\")))


;;; その他の標準搭載機能
;;; 24 で default on になったようだが要らない
(when (>= emacs-major-version 24)
  (tool-bar-mode -1))
;;; 25 で default on になったようだが要らない
(when (>= emacs-major-version 25)
  (global-eldoc-mode -1))
;;; buffer menu より高機能
(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)

;; flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

;; projectile
(use-package projectile
  :config
  (projectile-mode +1)
  :bind-keymap
  ("C-c p" . 'projectile-command-map))

;;;; packages
;;; yaml-mode
(use-package yaml-mode
  :mode
  "\\.ya?ml$")

;;; lsp-mode (language server protocol)
(setq lsp-keymap-prefix "C-c l")
(use-package lsp-mode
  :hook
  (python-mode . lsp)
  :commands lsp)

;;; python-mode (with pipenv.el)
(use-package python
  :mode
  ("\\.py$" . python-mode))
(use-package pipenv
  :hook
  (python-mode . pipenv-mode)
  :init
  (setq
   pipenv-projectile-after-switch-function
   #'pipenv-projectile-after-switch-extended))

;;; css-mode
(use-package css-mode
  :mode
  "\\.scss$")

;;; csv-mode
(use-package csv-mode)

;;; po-mode
(use-package po-mode
  :mode
  "\\.po[\\'\\.]?$")

;;; uniquify
(use-package uniquify
  :init
  (setq uniquify-buffer-name-style 'post-forward-angle-brackets))

;;; editorconfig-mode
;;; (editorconfig-mode 1)

;; ;;; lsp-mode
;; (require 'lsp-mode)
;; (require 'lsp-python)
;; (add-hook 'python-mode-hook #'lsp-mode)

;;; ropemacs
;; (defun load-ropemacs ()
;;   "Load pymacs and ropemacs"
;;   (interactive)
;;   (require 'pymacs)
;;   (setq pymacs-python-command "/Users/matsui/Gentoo/usr/bin/python2.7")
;;   (pymacs-load "ropemacs" "rope-")
;;   ;; Automatically save project python buffers before refactorings
;;   (setq ropemacs-confirm-saving 'nil))


(put 'narrow-to-region 'disabled nil)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(abbrev-all-caps t)
 '(ansi-color-names-vector
   ["black" "#d55e00" "#009e73" "#f8ec59" "#0072b2" "#cc79a7" "#56b4e9" "white"])
 '(css-indent-offset 2)
 '(flycheck-checkers
   '(ada-gnat asciidoctor asciidoc awk-gawk bazel-buildifier c/c++-clang c/c++-gcc c/c++-cppcheck cfengine chef-foodcritic coffee coffee-coffeelint coq css-csslint css-stylelint cuda-nvcc cwl d-dmd dockerfile-hadolint elixir-credo emacs-lisp ember-template erlang-rebar3 erlang eruby-erubis eruby-ruumba fortran-gfortran go-gofmt go-golint go-vet go-build go-test go-errcheck go-unconvert go-staticcheck groovy haml handlebars haskell-stack-ghc haskell-ghc haskell-hlint html-tidy javascript-eslint javascript-jshint javascript-standard json-jsonlint json-python-json json-jq jsonnet less less-stylelint llvm-llc lua-luacheck lua markdown-markdownlint-cli markdown-mdl nix nix-linter opam perl perl-perlcritic php php-phpmd php-phpcs processing proselint protobuf-protoc protobuf-prototool pug puppet-parser puppet-lint python-flake8 python-pylint python-pycompile python-mypy r-lintr racket rpm-rpmlint rst-sphinx rst ruby-rubocop ruby-standard ruby-reek ruby-rubylint ruby ruby-jruby rust-cargo rust rust-clippy scala scala-scalastyle scheme-chicken scss-lint scss-stylelint sass/scss-sass-lint sass scss sh-bash sh-posix-dash sh-posix-bash sh-zsh sh-shellcheck slim slim-lint sql-sqlint systemd-analyze tcl-nagelfar terraform terraform-tflint tex-chktex tex-lacheck texinfo textlint typescript-tslint verilog-verilator vhdl-ghdl xml-xmlstarlet xml-xmllint yaml-jsyaml yaml-ruby yaml-yamllint))
 '(global-flycheck-mode t)
 '(goal-column nil)
 '(indent-tabs-mode nil)
 '(js-indent-level 2)
 '(nxml-child-indent nil)
 '(package-archives
   '(("gnu" . "https://elpa.gnu.org/packages/")
     ("melpa" . "https://melpa.org/packages/")))
 '(package-enable-at-startup nil)
 '(package-selected-packages
   '(lsp-mode company use-package pipenv projectile flycheck json-mode julia-mode exec-path-from-shell po-mode editorconfig yaml-mode python-mode markdown-mode csv-mode))
 '(warning-suppress-types '((undo discard-info))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;; .emacs ends here
