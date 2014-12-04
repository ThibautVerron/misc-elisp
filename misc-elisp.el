;;;;; Work-around kmacro-edit-lossage issue with mouse events

;; Originally posted on http://emacs.stackexchange.com/a/4071/184"

(defadvice recent-keys (after tv/recent-keys-no-mouse first ())
  "Return only the keys since the last mouse event"
  (let* ((vec ad-return-value)
         (lst (append vec nil))
         (nmax (length vec))
         (i (- nmax 1)))
    (while
        (and
         (>= i 0)
         (not
          (let ((mod (event-modifiers (elt vec i))))
            (or (memq 'click mod)
                (memq 'double mod)
                (memq 'triple mod)
                (memq 'drag mod)
                (memq 'down mod)))))
      (setq i (- i 1)))
    (setq ad-return-value (vconcat (nthcdr (+ i 1) lst) nil))))

(defun tv/kmacro-edit-lossage-no-mouse ()
  "Same as `kmacro-edit-lossage', but does not fail if the keys contain mouse events.

In this case, only the keys since the last mouse event are kept."
  (interactive)
  (ad-activate-regexp "tv/recent-keys-no-mouse")
  (call-interactively #'kmacro-edit-lossage)
  (ad-deactivate-regexp "tv/recent-keys-no-mouse"))

(global-set-key (kbd "C-x C-k l") 'tv/kmacro-edit-lossage-no-mouse)
