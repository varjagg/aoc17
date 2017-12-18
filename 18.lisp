(in-package #:cl-user)

(defun interpret (input)
  (with-open-file (s input :direction :input)
    (let*  ((contents (loop for line = (read-line s nil) for entry = (read-from-string (format nil "(~A)" line))
			 while line collecting entry))
	    (program (make-array (length contents)
				 :initial-contents contents))
	    (registers (make-hash-table)))
      (flet ((fetch (arg)
	       (if (numberp arg)
		   arg
		   (gethash arg registers 0))))
	(loop with pc = 0
	   with sound = 0
	   for command = (aref program pc)
	   while (<= 0 pc (1- (length program))) do
	     (case (first command)
	       (set (setf (gethash (second command) registers) (fetch (third command))))
	       (add (incf (gethash (second command) registers 0) (fetch (third command))))
	       (mul (setf (gethash (second command) registers) (* (fetch (second command)) (fetch (third command)))))
	       (mod (setf (gethash (second command) registers) (mod (fetch (second command)) (fetch (third command)))))
	       (snd (setf sound (fetch (second command))))
	       (rcv (when (plusp (fetch (second command))) (return sound)))
	       (jgz (when (plusp (fetch (second command)))
		      (incf pc (1- (fetch (third command)))))))
	     (incf pc))))))

;; pt2

(defun make-interpreter (program id qout)
  (let ((registers (make-hash-table))
	(pc 0))
    (flet ((fetch (arg)
	     (if (numberp arg)
		 arg
		 (gethash arg registers 0))))
      (setf (gethash 'p registers) id)
      #'(lambda (message)
	  (loop for command = (aref program pc)
	     while (<= 0 pc (1- (length program))) do
	       (case (first command)
		 (set (setf (gethash (second command) registers) (fetch (third command))))
		 (add (incf (gethash (second command) registers 0) (fetch (third command))))
		 (mul (setf (gethash (second command) registers) (* (fetch (second command)) (fetch (third command)))))
		 (mod (setf (gethash (second command) registers) (mod (fetch (second command)) (fetch (third command)))))
		 (snd (append qout (list (fetch (second command)))))
		 (rcv (when (plusp (fetch (second command))) (return sound)))
		 (jgz (when (plusp (fetch (second command)))
			(incf pc (1- (fetch (third command)))))))
	       (incf pc))))))

(defun interpret2 (input)
  (with-open-file (s input :direction :input)
    (let*  ((contents (loop for line = (read-line s nil) for entry = (read-from-string (format nil "(~A)" line))
			 while line collecting entry))
	    (program (make-array (length contents)
				 :initial-contents contents))
	    (processes (make-array 2))
	    (q0 '())
	    (q1 '())
	    (dispatcher #'(lambda (id)
			    (if (= id 0)
				(pop q0)
				(pop q1)))))
      (setf )
      (loop with int1 = (make-interpreter program 0 q1) and int2 (make-interpreter program 1 q2) do
	   (funcall int1 )))))