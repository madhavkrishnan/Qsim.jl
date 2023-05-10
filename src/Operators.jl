
"""
	function ptrace(operator, qbit::Integer)

An inefficient qubit  partial trace implementation.
"""
function ptrace(op, qbit::Integer)

	z0 = zero_state(1)
	z1 = X * z0
	
	r,c = size(op)
	qbit_no = Int(log2(r))
	
	trl1 = qbit_op(z0', qbit, qbit_no)
	trl2 = qbit_op(z1', qbit, qbit_no)
	trr1 = qbit_op(z0, qbit, qbit_no)
	trr2 = qbit_op(z1, qbit, qbit_no)

	return trl1 * op * trr1 + trl2 * op * trr2
end

