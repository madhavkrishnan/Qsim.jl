# Measure qubits


"""
	function del_qbit(state, qseq)

Return state with qbits in qseq removed. 

qseq must of the form ((qbit1, state1), (qbit2, state2,...). Will only work if qbits are not entangled.
"""
function del_qbit(state, qseq)
	
	norm = 1

	# Decide which qbitstate amplitude to use for deletion
	qidx = [abs(qbitstate[1]) > abs(qbitstate[2]) ? 1 : 2 for (qbit, qbitstate) in qseq]
	

	# Find state dim
	qmax = state |> length |> log2 |> Int
	
	# plus state
	ps = sparse([1,1])
	
	op_vec = [ps for i in 1:qmax]

	for i in eachindex(qseq)
		op_vec[qseq[i][1]] = qidx[i] == 1 ? sparse([1, 0]) : sparse([0, 1])
		norm *= qseq[i][2][qidx[i]]

	end

	locs = findall(!iszero, kron(op_vec...))
	
	state =  state[locs] / norm

	# Renormalise
	state = state / sqrt(state' * state)

	return state


end


"""
	function del_qbit(state, qbit::Integer, qbitstate)

Return state with the qbit removed. Will only work correctly when qbit is not entangled with the rest of the state!
"""
function del_qbit(state, qbit, qbitstate)

	qseq = [(qbit, qbitstate)]

	return del_qbit(state, qseq)

end


#"""
#	function del_qbit(state, qbit::Integer, qbitstate)
#
#Return state with the qbit removed. Will only work correctly when qbit is not entangled with the rest of the state!
#"""
#function del_qbit(state, qbit::Integer, qbitstate)
#
#	# Decide which qbitstate amplitude to use for deletion
#	qidx = abs(qbitstate[1]) > abs(qbitstate[2]) ? 1 : 2
#	
#	# Find state dim
#	qmax = state |> length |> log2 |> Int
#	
#	# Computational state
#	cs = qidx == 1 ? sparse([1, 0]) : sparse([0, 1])
#	
#	# plus state
#	ps = sparse([1,1])
#	
#	op_vec = [ps for i in 1:qmax-1] 
#	insert!(op_vec, qbit, cs)
#
#	locs = findall(!iszero, kron(op_vec...))
#	
#
#
#	state =  state[locs] / qbitstate[qidx]
#
#	# Renormalise
#	state = state / sqrt(state' * state)
#
#	return state

#end

#"""
#	function measure(state, qbit::Integer, qout; delete=false)
#
#Project qbit into state qout and return the state. Will delete measured qubit if delete=true.
#"""
#function measure(state, qbit::Integer, qout;  delete=false)
#	
#	# Find state dim
#	qmax = state |> length |> log2 |> Int
#
#	
#	# output projector
#	pqout = qout  * qout'
#	
#	# Measure
#	state = qbit_op(pqout, qbit, qmax) * state
#	
#	if delete
#		# Delete measured qubit
#		state = del_qbit(state, qbit, qout)
#	else
#		# Renormalise
#		state = state / sqrt(state' * state)
#	end
#
#	return state
#end
#
"""
	function measure(state, mseq; delete=false)

Measure state given a measurement sequence `mseq`. 

Will delete measured qubits if delete=true.
"""
function measure(state, mseq;  delete=false)
	
	# Find state dim
	qmax = state |> length |> log2 |> Int
	
	# Measurement projector
	qbit_id = sparse([1.0 + 0.0im 0; 0 1])
	proj = [qbit_id for i in 1:qmax]
	

	for (qbit, qout) in mseq
		# output projector
		proj[qbit] = qout  * qout'
	end

	# Measure
	state = kron(proj...) * state

	if delete
		# Delete measured qubits
		state = del_qbit(state, mseq)
	else
		# Renormalise
		state = state / sqrt(state' * state)
	end

	return state
end


"""
	function measure(state, qbit::Integer, qout; delete=false)

Project qbit into state qout and return the state. Will delete measured qubit if delete=true.

"""
function measure(state, qbit, qout;  delete=false)
	
	mseq = [(qbit, qout)]

	return measure(state, mseq, delete=delete)

end
