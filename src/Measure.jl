# Measure qubits


"""
	function del_qbit(state, qbit::Integer, qbitstate)

Return state with the qbit removed. Will only work correctly when qbit is not entangled with the rest of the state!
"""
function del_qbit(state, qbit::Integer, qbitstate)

	# Decide which qbitstate amplitude to use for deletion
	qidx = abs(qbitstate[1]) > abs(qbitstate[2]) ? 1 : 2
	
	# Find state dim
	qmax = state |> length |> log2 |> Int
	
	# Computational state
	cs = qidx == 1 ? sparse([1, 0]) : sparse([0, 1])
	
	# plus state
	ps = sparse([1,1])
	
	op_vec = [ps for i in 1:qmax-1] 
	insert!(op_vec, qbit, cs)

	locs = findall(!iszero, kron(op_vec...))
	


	state =  state[locs] / qbitstate[qidx]

	# Renormalise
	state = state / sqrt(state' * state)


end

"""
	function measure(state, qbit::Integer, qout; delete=false)

Project qbit into state qout and return the state. Will delete measured qubit if delete=true.
"""
function measure(state, qbit::Integer, qout;  delete=false)
	
	# Find state dim
	qmax = state |> length |> log2 |> Int

	
	# output projector
	pqout = qout  * qout'
	
	# Measure
	state = qbit_op(pqout, qbit, qmax) * state
	
	if delete
		# Delete measured qubit
		state = del_qbit(state, qbit, qout)
	end

	return state
end

